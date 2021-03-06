USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CoolerClutch_EggTransaction]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CoolerClutch_EggTransaction]
GO
/****** Object:  StoredProcedure [dbo].[CoolerClutch_EggTransaction]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoolerClutch_EggTransaction]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CoolerClutch_EggTransaction] AS' 
END
GO


ALTER proc [dbo].[CoolerClutch_EggTransaction] @ClutchID int, @QtyChange int
as

declare @ClutchQtyBeforeChange int
declare @CoolerCnt int
declare @RemainingCnt int
declare @AdjQty int
declare @CoolerClutchID int
declare @LoopCnt int
declare @ClutchQty int

--Must keep Cooler Inventory Up to Date
--the one thing to consider is that a clutch can be in multiple coolers
--and therefore multiple coolerclutchids may have to be adjusted

if @QtyChange > 0
begin
	-- We are putting eggs back in the cooler			
	select top 1 @CoolerClutchID = CoolerClutchID, @ClutchQty = ActualQty
	from CoolerClutch
	where ClutchID = @ClutchID 
	--and ActualQty > 0
	order by ActualQty desc -- Put back to the cooler that has the most
		
	update CoolerClutch set ActualQty = ActualQty + @QtyChange where CoolerClutchID = @CoolerClutchID
	insert into EggTransaction(ClutchID, QtyChange, QtyChangeReasonID, QtyChangeActualDate, QtyChangeRecordedDate, CoolerClutchID, ClutchQtyAfterTransaction)
	select @ClutchID, @QtyChange, (select QuantityChangeReasonID from QuantityChangeReason where QuantityChangeReason = 'Incubator Load'), getdate(), getdate(), @CoolerClutchID, @ClutchQtyBeforeChange + @QtyChange
end
else
begin
	-- We know that this is pulling from the coolers, but we are going to reset the @QtyChange to positive
	-- to keep the original logic
	set @QtyChange = abs(@QtyChange)

	-- We have to pull eggs from one or more coolers
	select @RemainingCnt = @QtyChange, @LoopCnt = 0
	
	-- Loop through the CoolerClutch to adjust inventory for one or more coolers
	while @RemainingCnt > 0 and @LoopCnt < 10
	begin
		set @LoopCnt = @LoopCnt + 1

		select top 1 @ClutchQtyBeforeChange = ClutchQtyAfterTransaction
		from EggTransaction
		where ClutchID = @ClutchID
		order by EggTransactionID desc

		select top 1 @CoolerClutchID = CoolerClutchID, @ClutchQty = ActualQty
		from CoolerClutch
		where ClutchID = @ClutchID and ActualQty > 0
		order by ActualQty -- Pull from the cooler that has the least amount

		if @RemainingCnt > @ClutchQty
		begin
			set @AdjQty = @ClutchQty
		end
		else
		begin
			set @AdjQty = @RemainingCnt
		end

		update CoolerClutch set ActualQty = ActualQty - @AdjQty where CoolerClutchID = @CoolerClutchID

		insert into EggTransaction(ClutchID, QtyChange, QtyChangeReasonID, QtyChangeActualDate, QtyChangeRecordedDate, CoolerClutchID, ClutchQtyAfterTransaction)
		select @ClutchID, -1 * @AdjQty, (select QuantityChangeReasonID from QuantityChangeReason where QuantityChangeReason = 'Incubator Load'), getdate(), getdate(), @CoolerClutchID, @ClutchQtyBeforeChange - @AdjQty

		select @RemainingCnt = @RemainingCnt - @AdjQty
	end
end



GO
