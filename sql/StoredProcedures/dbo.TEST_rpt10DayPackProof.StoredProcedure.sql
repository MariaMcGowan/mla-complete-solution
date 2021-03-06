USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[TEST_rpt10DayPackProof]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[TEST_rpt10DayPackProof]
GO
/****** Object:  StoredProcedure [dbo].[TEST_rpt10DayPackProof]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TEST_rpt10DayPackProof]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TEST_rpt10DayPackProof] AS' 
END
GO

ALTER proc [dbo].[TEST_rpt10DayPackProof] @DeliveryDate date = null, @LotNbr varchar(100) = null
as

declare @LotNbrs varchar(100)
declare @SetBy varchar(1000)

create table #DeliveryDate (DeliveryDate date)
insert into #DeliveryDate (DeliveryDate)
select DeliveryDate
from [Order]
where OrderStatusID <> 5
and isnull(LotNbr, '') <> ''
and isnull(DeliveryDate, '01/01/1900') <> '01/01/1900'
and (DeliveryDate = isnull(@DeliveryDate, '01/01/1900') or LotNbr = isnull(@LotNbr, 'XXXXXXXX'))
group by DeliveryDate

create table #OrderList (OrderID int, DeliveryDate date, LotNbr varchar(10), Processed bit)
declare @OrderID int

insert into #OrderList (OrderID, DeliveryDate, LotNbr, Processed)
select OrderID, DeliveryDate, LotNbr, 0
from [Order] o
where OrderStatusID <> 5
and exists (select 1 from #DeliveryDate where DeliveryDate = o.DeliveryDate)


set @LotNbrs = ''

while exists (select 1 from #OrderList where Processed = 0)
begin
	set @LotNbr = ''

	select top 1 @OrderID = OrderID, @LotNbr = LotNbr
	from #OrderList 
	where Processed = 0
	order by LotNbr

	execute [dbo].[RecalcOrderFlockActualQty] @OrderID
	update #OrderList set Processed = 1 where OrderID = @OrderID

	select @LotNbrs = @LotNbrs + ',' + @LotNbr
end

if len(@LotNbrs) > 0
	set @LotNbrs = right(@LotNbrs, len(@LotNbrs)-1)

declare @Incubators varchar(100) = ''

select @Incubators = @Incubators + ', ' + Incubator
from #OrderList ol
inner join OrderIncubator oi on ol.OrderID = oi.OrderID
inner join Incubator i on oi.IncubatorID = i.IncubatorID
group by Incubator
order by Incubator

if left(@Incubators,2) = ', '
	set @Incubators = right(@Incubators, len(@Incubators)-2)


set @SetBy = ''

select @SetBy = @SetBy + ', ' + Contact
from
(
-- Program BY
select distinct c.Contact
from #OrderList ol
inner join OrderIncubator oi on ol.OrderID = oi.OrderID
left outer join Contact c on oi.ProgramBy = c.ContactID
union all
-- Primary Checker
select distinct c.Contact
from #OrderList ol
inner join OrderIncubator oi on ol.OrderID = oi.OrderID
left outer join Contact c on oi.CheckedByPrimary = c.ContactID
union all
-- Secondary Checker
select distinct c.Contact
from #OrderList ol
inner join OrderIncubator oi on ol.OrderID = oi.OrderID
left outer join Contact c on oi.CheckedBySecondary = c.ContactID
) data
group by Contact
order by Contact



set @SetBy = ltrim(rtrim(@SetBy))

if len(@SetBy) > 1
begin
	if left(@SetBy, 1) = ',' 
		set @SetBy = ltrim(right(@SetBy, len(@SetBy) - 1))
end


select distinct 
ic.IncubatorLocationNumber as RackNbr,
CONVERT(char(10), oi.StartDateTime,101) as SetDate, convert(char(10), o.DeliveryDate, 101) as DeliveryDate, 
@Incubators as Incubators, @SetBy as SetBy, 
@LotNbrs as LotNbr, Flock, convert(char(10),cl.LayDate, 101) as LayDate, datediff(day,laydate,StartDateTime) - 1 as DayCnt
from #OrderList ol
inner join [Order] o on ol.OrderID = o.OrderID
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
order by 1

drop table #OrderList
GO
