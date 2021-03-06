USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CoolerClutch_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CoolerClutch_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[CoolerClutch_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoolerClutch_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CoolerClutch_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[CoolerClutch_InsertUpdate]
	@I_vCoolerClutchID int
	,@I_vCoolerID int
	,@I_vFlockID int
	,@I_vLayDate date
	,@I_vReceivedDate date
	,@I_vPlannedQty int = 0
	,@I_vActualQty int = 0
	,@I_vUserName varchar(100) = ''
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

declare @CoolerClutchID int
declare @I_vClutchID int
declare @AddingNew bit = 0
declare @CurrentActualQty int
declare @CurrentPlannedQty int

select @CoolerClutchID = @I_vCoolerClutchID

select @I_vReceivedDate = isnull(nullif(@I_vReceivedDate, ''), convert(date, getdate()))

select @I_vClutchID = ClutchID from Clutch where FlockID = @I_vFlockID and LayDate = @I_vLayDate
if @I_vClutchID is null
begin
	declare @ClutchID table (ClutchID int)
	insert into Clutch (Clutch,FlockID,LayDate,IsActive)
	output inserted.ClutchID into @ClutchID(ClutchID)
	select
		''
		,@I_vFlockID
		,@I_vLayDate
		,1
	select @I_vClutchID = ClutchID from @ClutchID
end

-- Check if the clutch is in the cooler under a different CoolerCLutchID
if isnull(@CoolerClutchID,0) = 0 and exists (select 1 from CoolerClutch where ClutchID = @I_vClutchID)
begin
	select top 1 @CoolerClutchID = CoolerClutchID
	from CoolerClutch
	where ClutchID = @I_vClutchID
	and CoolerID = @I_vCoolerID
	order by CoolerClutchID
end


if isnull(@CoolerClutchID,0) = 0 
begin
	declare @CoolerClutch table (CoolerClutchID int)
	insert into CoolerClutch (
		
		CoolerID
		, ClutchID
		, PlannedQty
		, ActualQty
		, InitialQty
	)
	output inserted.CoolerClutchID into @CoolerClutch(CoolerClutchID)
	select
		
		@I_vCoolerID
		,@I_vClutchID
		,@I_vPlannedQty
		,@I_vActualQty
		,@I_vActualQty
	

	select top 1 @CoolerClutchID = CoolerClutchID, @iRowID = CoolerClutchID from @CoolerClutch

	-- this is a new cooler clutch
	-- Add record into EggTransaction
	insert into EggTransaction(ClutchID, QtyChange, QtyChangeReasonID, QtyChangeActualDate, QtyChangeRecordedDate, CoolerClutchID, ClutchQtyAfterTransaction, UseName)
	select @I_vClutchID, @I_vActualQty, (select QuantityChangeReasonID from QuantityChangeReason where QuantityChangeReason = 'Cooler Load'), @I_vReceivedDate, getdate(), @CoolerClutchID, @I_vActualQty, @I_vUserName
end
else
begin
	-- Is this an addition? as in, did someone choose the plus sign and the CoolerClutchID was originally 0?
	if isnull(@I_vCoolerClutchID,0) = 0
	begin
		-- this was intended to be a cooler load entry	
		select @CurrentActualQty = ActualQty, @CurrentPlannedQty = PlannedQty
		from CoolerClutch
		where @CoolerClutchID = CoolerClutchID
	
		update CoolerClutch
		set	
			CoolerID = @I_vCoolerID
			,ClutchID = @I_vClutchID
			,PlannedQty = @I_vPlannedQty + @CurrentPlannedQty
			,ActualQty = @I_vActualQty + @CurrentActualQty
		where @CoolerClutchID = CoolerClutchID

		-- this is actually a cooler load
		-- Add record into EggTransaction
		insert into EggTransaction(ClutchID, QtyChange, QtyChangeReasonID, QtyChangeActualDate, QtyChangeRecordedDate, CoolerClutchID, ClutchQtyAfterTransaction, UseName)
		select @I_vClutchID, @I_vActualQty, (select QuantityChangeReasonID from QuantityChangeReason where QuantityChangeReason = 'Cooler Load'), @I_vReceivedDate, getdate(), @CoolerClutchID, @I_vActualQty + @CurrentActualQty, @I_vUserName


		select @iRowID = @CoolerClutchID
	end
	else
	begin
		-- This is just a regular change
		select @CurrentActualQty = ActualQty 
		from CoolerClutch
		where @CoolerClutchID = CoolerClutchID
	
		update CoolerClutch
		set	
			CoolerID = @I_vCoolerID
			,ClutchID = @I_vClutchID
			,PlannedQty = @I_vPlannedQty
			,ActualQty = @I_vActualQty
		where @CoolerClutchID = CoolerClutchID

		-- this is a manual cooler clutch adjustment
		-- Add record into EggTransaction
		insert into EggTransaction(ClutchID, QtyChange, QtyChangeReasonID, QtyChangeActualDate, QtyChangeRecordedDate, CoolerClutchID, ClutchQtyAfterTransaction, UseName)
		select @I_vClutchID, @I_vActualQty - @CurrentActualQty, (select QuantityChangeReasonID from QuantityChangeReason where QuantityChangeReason = 'Manual Adjustment'), @I_vReceivedDate, getdate(), @CoolerClutchID, @I_vActualQty, @I_vUserName

		select @iRowID = @I_vCoolerClutchID

	end
end



GO
