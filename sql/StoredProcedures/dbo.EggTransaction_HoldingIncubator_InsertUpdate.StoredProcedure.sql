USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_HoldingIncubator_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_HoldingIncubator_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_HoldingIncubator_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_HoldingIncubator_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_HoldingIncubator_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[EggTransaction_HoldingIncubator_InsertUpdate]
@I_vDeliveryCartFlockID int = null
,@I_vQtyChange int
,@I_vQtyChangeReasonID int
,@I_vQtyChangeActualDate date
,@I_vUserName varchar(100)
,@O_iErrorState int=0 output
,@oErrString varchar(255)='' output
,@iRowID varchar(255)=NULL output
As

declare @QtyBeforeChange int = null
declare @DeliveryID int
declare @FlockID int

if isnull(@I_vDeliveryCartFlockID ,0) <> 0
begin
	select @DeliveryID = DeliveryID, @FlockID = FlockID
	from DeliveryCart dc
	inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
	where DeliveryCartFlockID = @I_vDeliveryCartFlockID

	select top 1 @QtyBeforeChange = ClutchQtyAfterTransaction
	from EggTransaction
	where FlockID = @FlockID
	order by EggTransactionID desc

	if @QtyBeforeChange is null
	begin
		declare @Clutches table (ClutchID int, ClutchQtyAfterTransaction int)
		declare @LoopCnt int
		declare @ClutchCnt int
		declare @ClutchQty int
		declare @ClutchID int

		-- grab it from the individual clutches
		-- can't grab all clutches for the flock
		-- only want clutches that were on orders
		-- with the same delivery date
		insert into @Clutches (ClutchID)
		select distinct c.ClutchID
		from [Order] o
		inner join OrderDelivery od on o.OrderID = od.OrderID
		inner join OrderIncubator oi on o.OrderID = oi.OrderID
		inner join OrderIncubatorCart oic on oi.OrderIncubatorID = oic.OrderIncubatorID
		inner join Clutch c on oic.ClutchID = c.ClutchID
		where DeliveryID = @DeliveryID and FlockID = @FlockID

		set @LoopCnt = 0
		select @ClutchCnt = count(*) from @Clutches
		set @QtyBeforeChange = 0

		while @LoopCnt < @ClutchCnt
		begin
			select top 1 ClutchID from @Clutches where ClutchQtyAfterTransaction is null

			select top 1 @ClutchQty = ClutchQtyAfterTransaction
			from EggTransaction
			where ClutchID = @ClutchID
			order by EggTransactionID desc

			update @Clutches set ClutchQtyAfterTransaction = @ClutchQty where ClutchID = @ClutchID

			select @QtyBeforeChange = @QtyBeforeChange + @ClutchQty

			set @LoopCnt = @LoopCnt + 1

		end



	end

	insert into EggTransaction (FlockID, QtyChange, QtyChangeReasonID, QtyChangeActualDate, QtyChangeRecordedDate, UseName, ClutchQtyAfterTransaction, DeliveryCartFlockID)
	select @FlockID, @I_vQtyChange, @I_vQtyChangeReasonID, @I_vQtyChangeActualDate, getdate(), @I_vUserName, @QtyBeforeChange + @I_vQtyChange, @I_vDeliveryCartFlockID

	-- MCM change 04/07/2017
	-- Change made to store original actual qty to the planned qty
	update DeliveryCartFlock set PlannedQty = ActualQty, ActualQty = ActualQty + @I_vQtyChange 
	where DeliveryCartFlockID = @I_vDeliveryCartFlockID

	-- MCM change 04/07/2017
	-- Change made to store original actual qty to the planned qty
	update Delivery set PlannedQty = ActualQty, ActualQty = ActualQty + @I_vQtyChange
	where DeliveryID = @DeliveryID
end



GO
