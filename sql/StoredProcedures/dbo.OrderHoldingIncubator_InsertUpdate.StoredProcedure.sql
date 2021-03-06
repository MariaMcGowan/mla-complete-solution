USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderHoldingIncubator_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderHoldingIncubator_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OrderHoldingIncubator_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderHoldingIncubator_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderHoldingIncubator_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[OrderHoldingIncubator_InsertUpdate]
	@I_vOrderHoldingIncubatorID int
	,@I_vOrderID int
	,@I_vHoldingIncubatorID int
	,@I_vPlannedQty int = null
	,@I_vActualQty int = null
	,@I_vProfileNumber int = null
	,@I_vStartDate date = null
	,@I_vStartTime time = null
	,@I_vProgramBy int = null
	,@I_vCheckedByPrimary int = null
	,@I_vCheckedBySecondary int = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if @I_vOrderHoldingIncubatorID = 0
begin
	declare @OrderHoldingIncubatorID table (OrderHoldingIncubatorID int)
	insert into OrderHoldingIncubator (
		
		OrderID
		, HoldingIncubatorID
		, PlannedQty
		, ActualQty
		, ProfileNumber
		, StartDateTime
		, ProgramBy
		, CheckedByPrimary
		, CheckedBySecondary
	)
	output inserted.OrderHoldingIncubatorID into @OrderHoldingIncubatorID(OrderHoldingIncubatorID)
	select
		
		@I_vOrderID
		,@I_vHoldingIncubatorID
		,@I_vPlannedQty
		,@I_vActualQty
		,@I_vProfileNumber
		,convert(datetime,@I_vStartDate) + convert(datetime,@I_vStartTime)
		,@I_vProgramBy
		,@I_vCheckedByPrimary
		,@I_vCheckedBySecondary
	select top 1 @I_vOrderHoldingIncubatorID = OrderHoldingIncubatorID, @iRowID = OrderHoldingIncubatorID from @OrderHoldingIncubatorID
end
else
begin
	update OrderHoldingIncubator
	set
		
		OrderID = @I_vOrderID
		,HoldingIncubatorID = @I_vHoldingIncubatorID
		,PlannedQty = @I_vPlannedQty
		,ActualQty = @I_vActualQty
		,ProfileNumber = @I_vProfileNumber
		,StartDateTime = convert(datetime,@I_vStartDate) + convert(datetime,@I_vStartTime)
		,ProgramBy = @I_vProgramBy
		,CheckedByPrimary = @I_vCheckedByPrimary
		,CheckedBySecondary = @I_vCheckedBySecondary
	where @I_vOrderHoldingIncubatorID = OrderHoldingIncubatorID
	select @iRowID = @I_vOrderHoldingIncubatorID
end



GO
