USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Delivery_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Delivery_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Delivery_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Delivery_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Delivery_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[Delivery_InsertUpdate]
       @I_vDeliveryID int
       ,@I_vOrderID int = null
       ,@I_vHoldingIncubatorID int = null
       ,@I_vDeliveryDescription nvarchar(255) = ''
       ,@I_vPlannedQty int = 0
       ,@I_vActualQty int = 0
       ,@I_vTruckID int = null
       ,@I_vTimeOfDelivery time = null
       ,@I_vDriverID int = null
	   ,@I_vHoldingIncubatorNotes varchar(1000) = null
	   ,@I_vDeliverySlip varchar(10) = ''
       ,@O_iErrorState int=0 output
       ,@oErrString varchar(255)='' output
       ,@iRowID varchar(255)=NULL output
AS


declare @DeliverySlipCnt int = 0
declare @LotNbr varchar(20) = ''

select @LotNbr = LotNbr from [Order] where OrderID = @I_vOrderID
select @DeliverySlipCnt = count(1) 
from Delivery d
inner join OrderDelivery od on d.DeliveryID = od.DeliveryID
where OrderID = @I_vOrderID and isnull(DeliverySlip, '') <> ''

if @I_vDeliveryID = 0
begin
       declare @DeliveryID table (DeliveryID int)
       insert into Delivery (
             DeliveryDescription
             , HoldingIncubatorID
             , PlannedQty
             , ActualQty
             , TruckID
             , TimeOfDelivery
             , DriverID
			 , HoldingIncubatorNotes
             --, DeliverySlip
       )
       output inserted.DeliveryID into @DeliveryID(DeliveryID)
       select 
             @I_vDeliveryDescription
             ,@I_vHoldingIncubatorID
             ,@I_vPlannedQty
             ,@I_vActualQty
             ,@I_vTruckID
             ,@I_vTimeOfDelivery
             ,@I_vDriverID
			 ,@I_vHoldingIncubatorNotes
             --,@LotNbr + '.' + right('00' + cast((@DeliverySlipCnt + 1) as varchar),2)
       select top 1 @I_vDeliveryID = DeliveryID, @iRowID = DeliveryID from @DeliveryID

       insert into OrderDelivery (OrderID, DeliveryID, DeliverySlip)
       select
             @I_vOrderID
             , @I_vDeliveryID
             ,(select rtrim(LotNbr) + '.' + right('00' + cast((
                    (select count(1) from OrderDelivery where OrderID = @I_vOrderID and IsNull(DeliverySlip,'') <> '')
                    + 1) as varchar),2)
                    from [Order] where OrderID = @I_vOrderID)
end
else
begin
       update Delivery
       set    
             DeliveryDescription = @I_vDeliveryDescription
             ,HoldingIncubatorID = @I_vHoldingIncubatorID
             ,PlannedQty = @I_vPlannedQty
             ,ActualQty = @I_vActualQty
             ,TruckID = @I_vTruckID
             ,TimeOfDelivery = @I_vTimeOfDelivery
             ,DriverID = @I_vDriverID
			 ,HoldingIncubatorNotes = @I_vHoldingIncubatorNotes
             --,DeliverySlip = 
             --     case
             --           when isnull(DeliverySlip, '') = '' then @LotNbr + '.' + right('00' + cast((@DeliverySlipCnt + 1) as varchar),2)
             --           else DeliverySlip
             --     end
       where @I_vDeliveryID = DeliveryID
       select @iRowID = @I_vDeliveryID

	   update OrderDelivery
	   set DeliverySlip = @I_vDeliverySlip
	   where OrderID = @I_vOrderID and DeliveryID = @I_vDeliveryID
end


update [Order] set OrderStatusID = 3 where OrderID = @I_vOrderID



GO
