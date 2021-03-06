USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderSummary_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderSummary_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderSummary_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderSummary_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderSummary_Get] AS' 
END
GO
ALTER proc [dbo].[OrderSummary_Get] 
@OrderID int

as

declare @EggQty int = 0
declare @DeliverySlip varchar(100) = ''

select @EggQty = sum(odc.ActualQty) 
from [Order] o1
inner join OrderHoldingIncubator ohi on o1.OrderID = ohi.OrderID
inner join DeliveryCart dc on dc.OrderHoldingIncubatorID = ohi.OrderHoldingIncubatorID
inner join OrderDeliveryCart odc on dc.DeliveryCartID = odc.DeliveryCartID
where o1.OrderID = @OrderID

select @DeliverySlip = @DeliverySlip + ', ' + DeliverySlip
from Delivery d
where d.OrderID = @OrderID

if left(@DeliverySlip, 2) = ', '
begin
	select @DeliverySlip = substring(@DeliverySlip, 3, 100)
end

select o.OrderID, LotNbr, DestinationID, DestinationBuildingID, CustomerReferenceNbr, @EggQty as EggQty, OrderStatusID, 
DeliveryDate, @DeliverySlip as DeliverySlip
from [Order] o
where o.OrderID = @OrderID
GO
