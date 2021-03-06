USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Delivery_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Delivery_Get]
GO
/****** Object:  StoredProcedure [dbo].[Delivery_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Delivery_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Delivery_Get] AS' 
END
GO


ALTER proc [dbo].[Delivery_Get]
@OrderID int = null
,@UserName varchar(100)
,@IncludeNew bit = 1
As

select
	d.DeliveryID
	, OrderID
	, DeliveryDescription
	, PlannedQty
	, ActualQty
	, TruckID
	, convert(varchar,TimeOfDelivery,22) TimeOfDelivery
	, DriverID
	, DeliverySlip
	, HoldingIncubatorID
	, DeliveryID_forLink = 
		case
			when HoldingIncubatorID is null then null
			else HoldingIncubatorID
		end
	, @UserName as UserName
from OrderDelivery od
inner join Delivery d on od.DeliveryID = d.DeliveryID
where @OrderID = OrderID
union all
select
	DeliveryID = convert(int,0)
	, OrderID = @OrderID
	, DeliveryDescription = convert(nvarchar(255),null)
	, PlannedQty = convert(int,null)
	, ActualQty = convert(int,null)
	, TruckID = convert(int,null)
	, TimeOfDelivery = ''
	, DriverID = convert(int, null)
	, DeliverySlip = convert(nvarchar(255),null)
	, HoldingIncubatorID = convert(int, null)
	, DeliveryID_forLink = convert(int, null)
	, @UserName as UserName
where @IncludeNew = 1



GO
