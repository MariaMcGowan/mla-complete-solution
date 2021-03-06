USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryCart_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[DeliveryCart_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryCart_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryCart_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeliveryCart_InsertUpdate] AS' 
END
GO
ALTER proc [dbo].[DeliveryCart_InsertUpdate]
	@I_vDeliveryCartID int
	,@I_vDeliveryCart varchar(255) = ''
	,@I_vSortOrder int = null
	,@I_vIsActive bit = 1
	,@I_vCartNumber varchar(25) = ''
	,@I_vIncubatorLocationNumber int = null
	,@I_vOrderHoldingIncubatorID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if @I_vDeliveryCartID = 0
begin
	declare @DeliveryCartID table (DeliveryCartID int)
	insert into DeliveryCart (
		
		DeliveryCart
		, SortOrder
		, IsActive
		, CartNumber
		, IncubatorLocationNumber
		, OrderHoldingIncubatorID
	)
	output inserted.DeliveryCartID into @DeliveryCartID(DeliveryCartID)
	select
		
		@I_vDeliveryCart
		,@I_vSortOrder
		,@I_vIsActive
		,@I_vCartNumber
		,@I_vIncubatorLocationNumber
		,@I_vOrderHoldingIncubatorID
	select top 1 @I_vDeliveryCartID = DeliveryCartID, @iRowID = DeliveryCartID from @DeliveryCartID
end
else
begin
	update DeliveryCart
	set
		
		DeliveryCart = @I_vDeliveryCart
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
		,CartNumber = @I_vCartNumber
		,IncubatorLocationNumber = @I_vIncubatorLocationNumber
		,OrderHoldingIncubatorID = @I_vOrderHoldingIncubatorID
	where @I_vDeliveryCartID = DeliveryCartID
	select @iRowID = @I_vDeliveryCartID
end
GO
