USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[rptTimeInCooler]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[rptTimeInCooler]
GO
/****** Object:  StoredProcedure [dbo].[rptTimeInCooler]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rptTimeInCooler]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[rptTimeInCooler] AS' 
END
GO



ALTER proc [dbo].[rptTimeInCooler] 
	@DeliveryDate date = null, @LotNbr varchar(100) = null

as

declare @DeliveryDateTable table (DeliveryDate date)

insert into @DeliveryDateTable (DeliveryDate)
select DeliveryDate
from [Order]
where OrderStatusID <> 5
and isnull(LotNbr, '') <> ''
and isnull(DeliveryDate, '01/01/1900') <> '01/01/1900'
and (DeliveryDate = isnull(@DeliveryDate, '01/01/1900') or LotNbr = isnull(@LotNbr, 'XXXXXXXX'))
group by DeliveryDate

declare @OrderList table (OrderID int, DeliveryDate date, LotNbr varchar(10), Processed bit)
declare @OrderID int

insert into @OrderList (OrderID, DeliveryDate, LotNbr, Processed)
select OrderID, DeliveryDate, LotNbr, 0
from [Order] o
where OrderStatusID <> 5
and exists (select 1 from @DeliveryDateTable where DeliveryDate = o.DeliveryDate)

-- need to include lot numbers at the top
declare @LotNbr01 varchar(10) = ''
	, @LotNbr02 varchar(10) = ''
	, @LotNbr03 varchar(10) = ''
	, @LotNbr04 varchar(10) = ''
	, @LotNbr05 varchar(10) = ''
	, @LotNbr06 varchar(10) = ''

declare @LotNbrTable table (ID int, LotNbr varchar(10))

insert into @LotNbrTable(ID, LotNbr)
SELECT ROW_NUMBER() OVER (Order by LotNbr) AS ID, LotNbr
from [Order] o
where DeliveryDate = @DeliveryDate

select @LotNbr01 = isnull(LotNbr, '') from @LotNbrTable where ID = 1
select @LotNbr02 = isnull(LotNbr, '') from @LotNbrTable where ID = 2
select @LotNbr03 = isnull(LotNbr, '') from @LotNbrTable where ID = 3
select @LotNbr04 = isnull(LotNbr, '') from @LotNbrTable where ID = 4
select @LotNbr05 = isnull(LotNbr, '') from @LotNbrTable where ID = 5
select @LotNbr06 = isnull(LotNbr, '') from @LotNbrTable where ID = 6


declare @DetailData table (RowNbr int, Rack int, Flock varchar(10), LayDate date, Days int, SetDate date, DeliveryDate date, LotNbr01 varchar(10), LotNbr02 varchar(10), LotNbr03 varchar(10), LotNbr04 varchar(10), LotNbr05 varchar(10), LotNbr06 varchar(10))

insert into @DetailData (RowNbr, Rack, Flock, LayDate, Days, SetDate, DeliveryDate, LotNbr01, LotNbr02, LotNbr03, LotNbr04, LotNbr05, LotNbr06)
select ROW_NUMBER() OVER (Order by IncubatorLocationNumber) AS RowNbr 
	, ic.IncubatorLocationNumber as Rack
	, frm.FarmNumber as Flock
	, c.LayDate
	, DateDiff(day, LayDate, SetDate) as Days
	, SetDate
	, @DeliveryDate as DeliveryDate
	, @LotNbr01 as LotNbr01
	, @LotNbr02 as LotNbr02
	, @LotNbr03 as LotNbr03
	, @LotNbr04 as LotNbr04
	, @LotNbr05 as LotNbr05
	, @LotNbr06 as LotNbr06
from @OrderList o
	left outer join OrderIncubator oi on o.OrderID = oi.OrderID --and oi.IncubatorID = @IncubatorID
	left outer join OrderIncubatorCart oic on oi.OrderIncubatorID = oic.OrderIncubatorID
	left outer join Clutch c on oic.ClutchID = c.ClutchID
	left outer join Flock f on c.FlockID = f.FlockID
	left outer join Farm frm on f.FarmID = frm.FarmID
	left outer join IncubatorCart ic on oic.IncubatorCartID = ic.IncubatorCartID
	left outer join Incubator i on oi.IncubatorID = i.IncubatorID		
	where DeliveryDate = @DeliveryDate and isnull(oic.ActualQty,0)>0
	order by ic.IncubatorLocationNumber


declare @SummaryData table (RowNbr int, Flock varchar(10), RackCnt int, AvgDays numeric(10,2), AvgHours numeric(10,2))
insert into @SummaryData (RowNbr, Flock, RackCnt, AvgDays, AvgHours)
select ROW_NUMBER() OVER (Order by frm.FarmNumber) AS RowNbr 
	, frm.FarmNumber as Flock
	, count(*) as RackCnt
	, convert(numeric(10,2), sum(DateDiff(day, LayDate, SetDate)) / (count(*) * 1.0))
	, convert(numeric(10,2), sum(DateDiff(day, LayDate, SetDate)) / (count(*) * 1.0) * 24.0) 
from
	@OrderList o
	left outer join OrderIncubator oi on o.OrderID = oi.OrderID --and oi.IncubatorID = @IncubatorID
	left outer join OrderIncubatorCart oic on oi.OrderIncubatorID = oic.OrderIncubatorID
	left outer join Clutch c on oic.ClutchID = c.ClutchID
	left outer join Flock f on c.FlockID = f.FlockID
	left outer join Farm frm on f.FarmID = frm.FarmID
	left outer join IncubatorCart ic on oic.IncubatorCartID = ic.IncubatorCartID
	left outer join Incubator i on oi.IncubatorID = i.IncubatorID		
	where DeliveryDate = @DeliveryDate and isnull(oic.ActualQty,0)>0
group by frm.FarmNumber
order by frm.FarmNumber


select Rack, d.Flock as DetailData_Flock, LayDate, Days, 
s.Flock as SummaryData_Flock, RackCnt, AvgDays, AvgHours,
SetDate, DeliveryDate, LotNbr01, LotNbr02, LotNbr03, LotNbr04, LotNbr05, LotNbr06
from @DetailData d
left outer join @SummaryData s on d.RowNbr = s.RowNbr
order by d.RowNbr



GO
