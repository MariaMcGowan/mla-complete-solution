USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[rpt10DayPackProof]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[rpt10DayPackProof]
GO
/****** Object:  StoredProcedure [dbo].[rpt10DayPackProof]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt10DayPackProof]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[rpt10DayPackProof] AS' 
END
GO

ALTER proc [dbo].[rpt10DayPackProof] @DeliveryDate date = null, @LotNbr varchar(100) = null
as

declare @LotNbrs varchar(100)
declare @SetBy varchar(1000)

select @DeliveryDate = nullif(@DeliveryDate, '')
	, @LotNbr = nullif(@LotNbr, '')

declare @OrderList table (OrderID int, DeliveryDate date, LoadPlanningID int, Processed bit)
declare @LoadPlanningList table (LoadPlanningID int, LotNbrList varchar(500), EggsSetByList varchar(500), IncubatorList varchar(500))
declare @LoadPlanningID int, @OrderID int


insert into @OrderList (OrderID, DeliveryDate, LoadPlanningID, Processed)
select OrderID, DeliveryDate, LoadPlanningID, 0
from [Order] o
where OrderStatusID <> 5
and LotNbr = isnull(@LotNbr, LotNbr)
and DeliveryDate = isnull(@DeliveryDate, DeliveryDate)
--and exists (select 1 from #DeliveryDate where DeliveryDate = o.DeliveryDate)

insert into @LoadPlanningList(LoadPlanningID, LotNbrList, IncubatorList, EggsSetByList) 
select LoadPlanningID, 
	LotNbrList = 
       STUFF((SELECT ',' + LotNbr
				FROM   [Order]
				where LoadPlanningID = o.LoadPlanningID
				order by LotNbr
				FOR XML PATH('')), 1, 1, ''), 
	IncubatorList = 
		STUFF((select ',' + Incubator
				from @OrderList ol
				inner join OrderIncubator oi on ol.OrderID = oi.OrderID
				inner join Incubator i on oi.IncubatorID = i.IncubatorID
				where LoadPlanningID = o.LoadPlanningID
				group by Incubator
				order by Incubator
				FOR XML PATH('')), 1, 1, ''), 
	EggsSetByList = 
		STUFF((select ',' + Contact
				from 
				(
					-- Program BY
					select distinct c.Contact
					from @OrderList ol
					inner join OrderIncubator oi on ol.OrderID = oi.OrderID
					left outer join Contact c on oi.ProgramBy = c.ContactID
					where LoadPlanningID = o.LoadPlanningID
					union all
					-- Primary Checker
					select distinct c.Contact
					from @OrderList ol
					inner join OrderIncubator oi on ol.OrderID = oi.OrderID
					left outer join Contact c on oi.CheckedByPrimary = c.ContactID
					where LoadPlanningID = o.LoadPlanningID
					union all
					-- Secondary Checker
					select distinct c.Contact
					from @OrderList ol
					inner join OrderIncubator oi on ol.OrderID = oi.OrderID
					left outer join Contact c on oi.CheckedBySecondary = c.ContactID
					where LoadPlanningID = o.LoadPlanningID
				) data
				group by Contact
				order by Contact
				FOR XML PATH('')), 1, 1, '')
from [Order] o
where exists (select 1 from @OrderList where OrderID = o.OrderID)
group by LoadPlanningID


while exists (select 1 from @OrderList where Processed = 0)
begin
	select top 1 @OrderID = OrderID
	from @OrderList 
	where Processed = 0

	execute [dbo].[RecalcOrderFlockActualQty] @OrderID
	update @OrderList set Processed = 1 where OrderID = @OrderID
end


--declare @Incubators varchar(100) = ''

--select @Incubators = @Incubators + ', ' + Incubator
--from @OrderList ol
--inner join OrderIncubator oi on ol.OrderID = oi.OrderID
--inner join Incubator i on oi.IncubatorID = i.IncubatorID
--group by Incubator
--order by Incubator

--if left(@Incubators,2) = ', '
--	set @Incubators = right(@Incubators, len(@Incubators)-2)


--set @SetBy = ''

--select @SetBy = @SetBy + ', ' + Contact
--from
--(
---- Program BY
--select distinct c.Contact
--from @OrderList ol
--inner join OrderIncubator oi on ol.OrderID = oi.OrderID
--left outer join Contact c on oi.ProgramBy = c.ContactID
--union all
---- Primary Checker
--select distinct c.Contact
--from @OrderList ol
--inner join OrderIncubator oi on ol.OrderID = oi.OrderID
--left outer join Contact c on oi.CheckedByPrimary = c.ContactID
--union all
---- Secondary Checker
--select distinct c.Contact
--from @OrderList ol
--inner join OrderIncubator oi on ol.OrderID = oi.OrderID
--left outer join Contact c on oi.CheckedBySecondary = c.ContactID
--) data
--group by Contact
--order by Contact



--set @SetBy = ltrim(rtrim(@SetBy))

--if len(@SetBy) > 1
--begin
--	if left(@SetBy, 1) = ',' 
--		set @SetBy = ltrim(right(@SetBy, len(@SetBy) - 1))
--end


select distinct 
l.LoadPlanningID, 
i.Incubator + '-' + convert(varchar(4), ic.IncubatorLocationNumber) as RackNbr,
--CONVERT(char(10), oi.StartDateTime,101) as SetDate, -- ticket #12274
CONVERT(char(10), o.PlannedSetDate,101) as SetDate, 
convert(char(10), o.DeliveryDate, 101) as DeliveryDate, 
l.IncubatorList as Incubators, l.EggsSetByList as SetBy, 
l.LotNbrList as LotNbr, Flock, convert(char(10),cl.LayDate, 101) as LayDate, 
--datediff(day,laydate,StartDateTime)  -- ticket #12274
DayCnt = datediff(day,laydate,o.PlannedSetDate),
ic.IncubatorLocationNumber, 
i.Incubator
--- 1 
from @OrderList ol
inner join @LoadPlanningList l on ol.LoadPlanningID = l.LoadPlanningID
inner join [Order] o on ol.OrderID = o.OrderID
inner join OrderIncubator oi on o.OrderID = oi.OrderID
inner join OrderIncubatorCart oic on oi.OrderIncubatorID = oic.OrderIncubatorID
inner join IncubatorCart ic on oic.IncubatorCartID = ic.IncubatorCartID
inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
inner join Incubator i on oi.IncubatorID = i.IncubatorID
--inner join OrderFlock ofl on o.OrderID = ofl.OrderID
--inner join OrderFlockClutch ofc on ofl.OrderFlockID = ofc.OrderFlockID
--left outer join OrderIncubatorEggsSetBy oie on oi.OrderIncubatorID = oie.OrderIncubatorID
--left outer join Contact c on oie.ContactID = c.ContactID
inner join Clutch cl on oic.ClutchID = cl.ClutchID
inner join Flock fl on cl.FlockID = fl.FlockID
where isnull(oic.ActualQty,0) > 0 and oi.StartDateTime is not null
order by l.LoadPlanningID, i.Incubator, ic.IncubatorLocationNumber


GO
