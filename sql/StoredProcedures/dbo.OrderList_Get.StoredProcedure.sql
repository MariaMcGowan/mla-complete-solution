USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderList_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderList_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderList_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderList_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderList_Get] AS' 
END
GO


ALTER proc [dbo].[OrderList_Get]
@OrderID int = null
,@UserName nvarchar(255) = ''
,@LotNbr nvarchar(255) = null
,@DestinationBuildingID int = null
,@DeliveryDate_Start date = null
,@DeliveryDate_End date = null
,@OrderStatusID int = null
,@IncludeNew bit = 0
As

select @LotNbr = nullif(@LotNbr, ''), 
@DestinationBuildingID = nullif(@DestinationBuildingID, ''),
@DeliveryDate_Start = isnull(nullif(@DeliveryDate_Start, ''), '01/01/2000'), 
@DeliveryDate_End = isnull(nullif(@DeliveryDate_End, ''), '12/12/3000'), 
@OrderStatusID = nullif(@OrderStatusID, '')


select
	o.OrderID
	, OrderNbr
	, LotNbr
	, CustomerReferenceNbr
	, IncubationDayCnt = 
		case
			when DeliveryDate is null or PlannedSetDate is null then 11
			else DateDiff(day,PlannedSetDate, DeliveryDate) - 1
		end
	, DeliveryDate
	, PlannedSetDate
	, d.DestinationID
	, Destination
	, DestinationBuildingID
	, PlannedQty
	, OrderQty
	, ClutchPlannedQty = isnull(ClutchPlannedQty,0)
	, OrderStatusID
	, DeliverySpecComments
	, @UserName As UserName
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
union all
select
	OrderID = convert(int,0)
	, OrderNbr = convert(varchar(100),null)
	, LotNbr = convert(varchar(100),null)
	, CustomerReferenceNbr = convert(varchar(100),null)
	, IncubationDayCnt = 11
	, DeliveryDate = convert(date,null)
	, PlannedSetDate = convert(date, null)
	, DestinationID = 1
	, Destination = 'Sanofi'
	, DestinationBuildingID = convert(int,null)
	, PlannedQty = convert(int,null)
	, OrderQty = convert(int, null)
	, ClutchPlannedQty = convert(int, null)
	, OrderStatusID = convert(int,null)
	, DeliverySpecComments = convert(varchar(1000), null)
	, @UserName As UserName
	--, FlockList = convert(varchar(100),null)
where @IncludeNew = 1
order by 6 desc



GO
