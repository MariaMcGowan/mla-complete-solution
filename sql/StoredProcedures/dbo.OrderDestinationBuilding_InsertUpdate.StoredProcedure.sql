USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderDestinationBuilding_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderDestinationBuilding_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OrderDestinationBuilding_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDestinationBuilding_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderDestinationBuilding_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[OrderDestinationBuilding_InsertUpdate]
	@I_vOrderID int
	,@I_vDestinationBuildingID int
	,@I_vOrderDestinationBuildingID int = null
	,@I_vPlannedQty int = null
	,@I_vOrderQty int = null
	,@I_vUserName varchar(100) = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

if @I_vOrderDestinationBuildingID = 0
begin
	declare @OrderDestinationBuildingID table (OrderDestinationBuildingID int)
	insert into dbo.OrderDestinationBuilding (
		OrderID
		,DestinationBuildingID
		,PlannedQty
		,OrderQty
	)
	output inserted.OrderDestinationBuildingID into @OrderDestinationBuildingID(OrderDestinationBuildingID)
	select
		@I_vOrderID
		,@I_vDestinationBuildingID
		,@I_vPlannedQty
		,@I_vOrderQty

	select top 1 @I_vOrderDestinationBuildingID = OrderDestinationBuildingID, @iRowID = OrderDestinationBuildingID from @OrderDestinationBuildingID
end
else
begin
	update dbo.OrderDestinationBuilding
	set
		OrderID = @I_vOrderID
		,DestinationBuildingID = @I_vDestinationBuildingID
		,PlannedQty = @I_vPlannedQty
		,OrderQty = @I_vOrderQty
	where @I_vOrderDestinationBuildingID = OrderDestinationBuildingID
	select @iRowID = @I_vOrderDestinationBuildingID
end



GO
