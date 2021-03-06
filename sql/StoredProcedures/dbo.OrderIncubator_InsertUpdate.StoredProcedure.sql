USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubator_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderIncubator_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubator_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubator_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderIncubator_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[OrderIncubator_InsertUpdate]
	@I_vOrderIncubatorID int
	,@I_vOrderID int
	,@I_vIncubatorID int
	,@I_vPlannedQty int = null
	,@I_vActualQty int = null
	,@I_vProfileNumber int = null
	,@I_vStartDate date = null
	,@I_vStartTime varchar(10) = null
	,@I_vProgramBy int = null
	,@I_vCandleDate date = null
	,@I_vCheckedByPrimary int = null
	,@I_vCheckedBySecondary int = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

declare @StartTime  time

select @StartTime = convert(time, @I_vStartTime)


declare @StartDateTime datetime


SELECT @StartDateTime = CONVERT(DATETIME, CONVERT(CHAR(8), @I_vStartDate, 112) 
  + ' ' + CONVERT(CHAR(8), @StartTime, 108))


if isnull(@I_vPlannedQty,0) = 0
	select @I_vPlannedQty = SUM(PlannedQty)
		from OrderIncubatorCart
		where OrderIncubatorID = @I_vOrderIncubatorID

if isnull(@I_vActualQty,0) = 0
	select @I_vActualQty = SUM(ActualQty)
		from OrderIncubatorCart
		where OrderIncubatorID = @I_vOrderIncubatorID


if @I_vOrderIncubatorID = 0
begin
	declare @OrderIncubatorID table (OrderIncubatorID int)
	insert into OrderIncubator (
		
		OrderID
		, IncubatorID
		, PlannedQty
		, ActualQty
		, ProfileNumber
		, StartDateTime
		, CandleDate
		, ProgramBy
		, CheckedByPrimary
		, CheckedBySecondary
	)
	output inserted.OrderIncubatorID into @OrderIncubatorID(OrderIncubatorID)
	select
		
		@I_vOrderID
		,@I_vIncubatorID
		,@I_vPlannedQty
		,@I_vActualQty
		,@I_vProfileNumber
		,@StartDateTime
		,@I_vCandleDate
		,@I_vProgramBy
		,@I_vCheckedByPrimary
		,@I_vCheckedBySecondary
	select top 1 @I_vOrderIncubatorID = OrderIncubatorID, @iRowID = OrderIncubatorID from @OrderIncubatorID
end
else
begin
	update OrderIncubator
	set
		
		OrderID = @I_vOrderID
		,IncubatorID = @I_vIncubatorID
		,PlannedQty = @I_vPlannedQty
		,ActualQty = @I_vActualQty
		,ProfileNumber = @I_vProfileNumber
		,StartDateTime = @StartDateTime
		,CandleDate = @I_vCandleDate
		,ProgramBy = @I_vProgramBy
		,CheckedByPrimary = @I_vCheckedByPrimary
		,CheckedBySecondary = @I_vCheckedBySecondary
	where @I_vOrderIncubatorID = OrderIncubatorID
	select @iRowID = @I_vOrderIncubatorID
end




GO
