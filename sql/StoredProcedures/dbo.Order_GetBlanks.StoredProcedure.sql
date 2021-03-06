USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Order_GetBlanks]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Order_GetBlanks]
GO
/****** Object:  StoredProcedure [dbo].[Order_GetBlanks]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_GetBlanks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Order_GetBlanks] AS' 
END
GO


ALTER proc [dbo].[Order_GetBlanks]
@OrderID int = null
,@AddRowCount int = 1
,@UserName nvarchar(255) = ''
,@LotNbr nvarchar(255) = null
,@DestinationBuildingID int = null
,@DeliveryDate_Start date = null
,@DeliveryDate_End date = null
,@OrderStatusID int = null
,@NewOrders bit = 0
As

select @LotNbr = nullif(@LotNbr, ''), 
@DestinationBuildingID = nullif(@DestinationBuildingID, ''),
@DeliveryDate_Start = isnull(nullif(@DeliveryDate_Start, ''), '01/01/2000'), 
@DeliveryDate_End = isnull(nullif(@DeliveryDate_End, ''), '12/12/3000'), 
@OrderStatusID = nullif(@OrderStatusID, ''),
@NewOrders = isnull(nullif(@NewOrders, ''),0)

if @NewOrders = 0
	set @AddRowCount = 0

create table #Data (OrderID int, OrderNbr varchar(20), LotNbr varchar(20), CustomerReferenceNbr varchar(100), 
IncubationDayCnt int, DeliveryDate date, PlannedSetDate date, DestinationID int, Destination varchar(50), DestinationBuildingID int, 
PlannedQty int, OrderQty int, ClutchPlannedQty int, OrderStatusID int, UserName varchar(100), FlockList varchar(500), 
Blank bit)

insert into #Data (OrderID, OrderNbr, LotNbr, CustomerReferenceNbr, DeliveryDate, PlannedSetDate, 
DestinationID, Destination, DestinationBuildingID, PlannedQty, OrderQty, ClutchPlannedQty, OrderStatusID,
UserName, Blank)
--, FlockList)
select
	o.OrderID
	, OrderNbr
	, LotNbr
	, CustomerReferenceNbr
	, DeliveryDate
	, PlannedSetDate
	, d.DestinationID
	, Destination
	, DestinationBuildingID
	, PlannedQty
	, OrderQty
	, ClutchPlannedQty = isnull(ClutchPlannedQty,0)
	, OrderStatusID
	, @UserName As UserName
	,0
	--, FlockList = isnull(f.FlockNames,'')
from [ORDER] o
inner join Destination d on isnull(o.DestinationID,1) = d.DestinationID
left outer join 
(
	select o.OrderID, sum(ofcl.PlannedQty) as ClutchPlannedQty
	from [Order] o
	inner join OrderFlock ofl on o.OrderID = ofl.OrderID
	inner join OrderFlockClutch ofcl on ofl.OrderFlockID = ofcl.OrderFlockID
	group by o.OrderID
) c on o.OrderID = c.OrderID
where IsNull(@OrderID,o.OrderID) = o.OrderID
--and OrderStatusID <> 5
and IsNull(@LotNbr, o.LotNbr) = o.LotNbr
and DeliveryDate between isNull(@DeliveryDate_Start, DeliveryDate) and isNull(@DeliveryDate_End, DeliveryDate) 
and IsNull(@DestinationBuildingID , DestinationBuildingID) = DestinationBuildingID
and IsNull(@OrderStatusID, OrderStatusID) = OrderStatusID




while @AddRowCount > 0
begin
	insert into #Data (OrderID, OrderNbr, LotNbr, CustomerReferenceNbr, DeliveryDate, PlannedSetDate, 
	DestinationID, Destination, DestinationBuildingID, PlannedQty, OrderQty, ClutchPlannedQty, OrderStatusID,
	UserName, FlockList, Blank)
	select
		OrderID = convert(int,0)
		, OrderNbr = 'MLA-XXX0000000'
		, LotNbr = right(cast(DatePart(Year,getdate()) as varchar), 2) + 'XX000'
		, CustomerReferenceNbr = convert(varchar(100),null)
		, DeliveryDate = convert(date,null)
		, PlannedSetDate = convert(date, null)
		, DestinationID = 1
		, Destination = 'Sanofi'
		, DestinationBuildingID = convert(int,null)
		, PlannedQty = convert(int,null)
		, OrderQty = convert(int, null)
		, ClutchPlannedQty = convert(int, null)
		, OrderStatusID = convert(int,null)
		, @UserName As UserName
		, FlockList = convert(varchar(100),null)
		, 1

	set @AddRowCount = @AddRowCount - 1
end

update #Data 
set IncubationDayCnt = 
	case
		when DeliveryDate is null or PlannedSetDate is null then 11
		else DateDiff(day,PlannedSetDate, DeliveryDate) - 1
	end


select OrderID = convert(int,OrderID)
		, OrderNbr
		, LotNbr
		, CustomerReferenceNbr
		, DeliveryDate = convert(date,DeliveryDate)
		, IncubationDayCnt = convert(int, IncubationDayCnt)
		, PlannedSetDate = convert(date, PlannedSetDate)
		, DestinationID
		, Destination
		, DestinationBuildingID = convert(int,DestinationBuildingID)
		, PlannedQty = convert(int,PlannedQty)
		, OrderQty = convert(int, OrderQty)
		, ClutchPlannedQty = convert(int, ClutchPlannedQty)
		, OrderStatusID = convert(int,OrderStatusID)
		, UserName
		, FlockList
		, Blank

from #Data
order by Blank desc, DeliveryDate, LotNbr

drop table #Data



GO
