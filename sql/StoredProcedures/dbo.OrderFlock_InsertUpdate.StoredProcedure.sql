USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderFlock_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderFlock_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OrderFlock_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderFlock_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderFlock_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[OrderFlock_InsertUpdate]
	@I_vOrderFlockID int
	,@I_vOrderID int
	,@I_vFlockID int
	,@I_vPlannedQty int = null
	,@I_vActualQty int = null
	,@I_vUserName nvarchar(255) = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if @I_vOrderFlockID = 0
begin
	declare @OrderFlockID table (OrderFlockID int)
	insert into OrderFlock (
		OrderID
		, FlockID
		, PlannedQty
		, ActualQty
	)
	output inserted.OrderFlockID into @OrderFlockID(OrderFlockID)
	select
		@I_vOrderID
		,@I_vFlockID
		,@I_vPlannedQty
		,@I_vActualQty
	select top 1 @I_vOrderFlockID = OrderFlockID, @iRowID = OrderFlockID from @OrderFlockID
end
else
begin
	update OrderFlock
	set
		OrderID = @I_vOrderID
		,FlockID = @I_vFlockID
		,PlannedQty = @I_vPlannedQty
		,ActualQty = @I_vActualQty
	where @I_vOrderFlockID = OrderFlockID
	select @iRowID = @I_vOrderFlockID
end



GO
