USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderDeliveryCart_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderDeliveryCart_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OrderDeliveryCart_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDeliveryCart_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderDeliveryCart_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[OrderDeliveryCart_InsertUpdate]
	@I_vOrderDeliveryCartID int
	,@I_vDeliveryCartID int
	,@I_vPlannedQty int = 0
	,@I_vActualQty int = 0
	,@I_vFlockID int = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if @I_vOrderDeliveryCartID = 0
begin
	declare @OrderDeliveryCartID table (OrderDeliveryCartID int)
	insert into OrderDeliveryCart (
		
		DeliveryCartID
		, PlannedQty
		, ActualQty
		, FlockID
	)
	output inserted.OrderDeliveryCartID into @OrderDeliveryCartID(OrderDeliveryCartID)
	select
		
		@I_vDeliveryCartID
		,@I_vPlannedQty
		,@I_vActualQty
		,@I_vFlockID
	select top 1 @I_vOrderDeliveryCartID = OrderDeliveryCartID, @iRowID = OrderDeliveryCartID from @OrderDeliveryCartID
end
else
begin
	update OrderDeliveryCart
	set
		
		DeliveryCartID = @I_vDeliveryCartID
		,PlannedQty = @I_vPlannedQty
		,ActualQty = @I_vActualQty
		,FlockID = @I_vFlockID
	where @I_vOrderDeliveryCartID = OrderDeliveryCartID
	select @iRowID = @I_vOrderDeliveryCartID
end



GO
