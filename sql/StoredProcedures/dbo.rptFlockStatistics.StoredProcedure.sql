USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[rptFlockStatistics]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[rptFlockStatistics]
GO
/****** Object:  StoredProcedure [dbo].[rptFlockStatistics]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rptFlockStatistics]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[rptFlockStatistics] AS' 
END
GO


ALTER proc [dbo].[rptFlockStatistics] @FlockID int = null
as

declare @EggsPerIncubatorCart int = 4608
             ,@EggsPerHoldingIncubatorCart int = 4320
             ,@EggsPerShelf int = 1080
             ,@EggsPerTray int = 36
             ,@EggsPerCase int = 360

declare @Incubator table (FlockID int, LotNbr varchar(10), AbbreviatedLotNbr varchar(3), SetDate date, EggCnt int)
declare @HoldingIncubator table (FlockID int, LotNbr varchar(10), AbbreviatedLotNbr varchar(3), EggCnt int, EggWgt numeric(8,2))
declare @FlockRacks table (FlockID int, LotNbr varchar(10), AbbreviatedLotNbr varchar(3), RackCnt int)

select @FlockID = nullif(@FlockID, '')

insert into @Incubator (FlockID, AbbreviatedLotNbr, SetDate, EggCnt)
select FlockID, right(LotNbr,3), min(SetDate) as SetDate, sum(oic.ActualQty) as EggCnt
from OrderIncubatorCart oic
inner join OrderIncubator oi on oic.OrderIncubatorID = oi.OrderIncubatorID
inner join Clutch c on oic.ClutchID = c.ClutchID
inner join [Order] o on oi.OrderID = o.OrderID
where isnull(oic.ActualQty,0)<> 0 and FlockID = isnull(@FlockID, FlockID)
group by FlockID, right(LotNbr,3)


insert into @HoldingIncubator (FlockID, AbbreviatedLotNbr, EggCnt, EggWgt)
select dcf.FlockID, right(LotNbr, 3), sum(isnull(dcf.ActualQty,0) - IsNull(et.QtyChange,0)) as EggCnt,
lpd.weightPreConversion*16/30
from DeliveryCartFlock dcf
inner join DeliveryCart dc on dc.DeliveryCartID = dcf.DeliveryCartID
inner join [Order] o on dc.OrderID = o.OrderID
inner join LoadPlanning lp on o.DeliveryDate = lp.DeliveryDate
inner join LoadPLanning_Detail lpd on lp.LoadPlanningID = lpd.LoadPlanningID and dcf.FlockID = lpd.FlockID
left outer join EggTransaction et on dcf.DeliveryCartFlockID = et.DeliveryCartFlockID
where dcf.FlockID = isnull(@FlockID, dcf.FlockID)
group by dcf.FlockID, right(LotNbr,3), weightPreConversion

insert into @FlockRacks (FlockID, AbbreviatedLotNbr, RackCnt)
select fl.FlockID, right(o.LotNbr,3), count(*)
from [Order] o 
inner join OrderIncubator oi on o.OrderID = oi.OrderID
inner join OrderIncubatorCart oic on oi.OrderIncubatorID = oic.OrderIncubatorID
inner join IncubatorCart ic on oic.IncubatorCartID = ic.IncubatorCartID
inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
--inner join OrderFlock ofl on o.OrderID = ofl.OrderID
--inner join OrderFlockClutch ofc on ofl.OrderFlockID = ofc.OrderFlockID
--left outer join OrderIncubatorEggsSetBy oie on oi.OrderIncubatorID = oie.OrderIncubatorID
--left outer join Contact c on oie.ContactID = c.ContactID
inner join Clutch cl on oic.ClutchID = cl.ClutchID
inner join Flock fl on cl.FlockID = fl.FlockID
where isnull(oic.ActualQty,0) > 0 and oi.StartDateTime is not null 
and fl.FlockID = isnull(@FlockID, fl.FlockID)
group by fl.FlockID, right(LotNbr,3)

select Flock, CONVERT(char(10), SetDate,101) as SetDate, i.AbbreviatedLotNbr as LotNbr,
sum(isnull(RackCnt, 0)) as RackCnt,
Cases = convert(numeric(6,2), Round(convert(numeric(19,2),sum(i.EggCnt)) / @EggsPerCase,2)),
ActualYield = 
case
	when isnull(sum(i.EggCnt),0) = 0 then null
	else convert(numeric(5,2),ROUND(100 * (convert(numeric,isnull(sum(hi.EggCnt),0)) / convert(numeric,sum(i.EggCnt))),2)) / 100 
end,
WgtDz = avg(EggWgt),
EggsDelivered = isnull(sum(i.EggCnt),0),
CummEggsDelivered = sum(sum(i.EggCnt)) over 
(partition by Flock order by SetDate ROWS UNBOUNDED PRECEDING)
from Flock f
inner join @Incubator i on f.FlockID = i.FlockID
left outer join @HoldingIncubator hi on i.FlockID = hi.FlockID and i.AbbreviatedLotNbr = hi.AbbreviatedLotNbr
left outer join @FlockRacks fr on f.FlockID = fr.FlockID and fr.AbbreviatedLotNbr = i.AbbreviatedLotNbr
where f.FlockID = isnull(@FlockID, f.FlockID)
group by Flock, setDate,i.AbbreviatedLotNbr
order by 1, 2




GO
