USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderFlockClutch_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderFlockClutch_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OrderFlockClutch_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderFlockClutch_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderFlockClutch_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[OrderFlockClutch_InsertUpdate]
	@I_vOrderFlockClutchID int
	,@I_vOrderFlockID int
	,@I_vLayDate date
	,@I_vPlannedQty int = null
	,@I_vActualQty int = null
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

declare @FlockID int
declare @ClutchID int

select @FlockID = FlockID from OrderFlock where OrderFlockID = @I_vOrderFlockID
select @ClutchID = ClutchID from Clutch where FlockID = @FlockID and LayDate = @I_vLayDate

if @ClutchID is null
begin
	declare @Clutch table (ClutchID int)
	insert into Clutch (FlockID, LayDate, PlannedQty, ActualQty, IsActive)
	output inserted.ClutchID into @Clutch(ClutchID)
	select @FlockID, @I_vLayDate, @I_vPlannedQty, @I_vActualQty, 1

	select top 1 @ClutchID = ClutchID from @Clutch
end


if @I_vOrderFlockClutchID = 0
begin
	declare @OrderFlockClutchID table (OrderFlockClutchID int)
	insert into OrderFlockClutch (
		OrderFlockID
		, ClutchID
		, PlannedQty
		, ActualQty
	)
	output inserted.OrderFlockClutchID into @OrderFlockClutchID(OrderFlockClutchID)
	select
		
		@I_vOrderFlockID
		,@ClutchID
		,@I_vPlannedQty
		,@I_vActualQty

	select top 1 @I_vOrderFlockClutchID = OrderFlockClutchID, @iRowID = OrderFlockClutchID from @OrderFlockClutchID
end
else
begin
	update OrderFlockClutch
	set

		OrderFlockID = @I_vOrderFlockID
		,ClutchID = @ClutchID
		,PlannedQty = @I_vPlannedQty
		,ActualQty = @I_vActualQty
	where @I_vOrderFlockClutchID = OrderFlockClutchID
	select @iRowID = @I_vOrderFlockClutchID
end



GO
