USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubatorCart_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderIncubatorCart_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubatorCart_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubatorCart_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderIncubatorCart_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[OrderIncubatorCart_InsertUpdate]
	@I_vOrderIncubatorCartID int
	,@I_vOrderIncubatorID int
	,@I_vIncubatorCartID int = 0
    ,@I_vIncubatorCart nvarchar(255) = ''
    ,@I_vCartNumber varchar(25) = ''
    ,@I_vIncubatorLocationNumber int = null
	,@I_vPlannedQty int = 0
	,@I_vActualQty int = 0
	,@I_vCoolerID int = null
	,@I_vIncubatorID int = null
	,@I_vLoadDate date = null
	,@I_vLoadTime time = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

if @I_vLoadDate = '1/1/1900' or @I_vLoadDate = ''
	select @I_vLoadDate = null
if @I_vLoadTime = convert(time,'0:00') or @I_vLoadTime = ''
	select @I_vLoadTime = null

if @I_vIncubatorCartID = 0
begin
	declare @IncubatorCartID table (IncubatorCartID int)
	insert into IncubatorCart (
		
		IncubatorCart
		, SortOrder
		, IsActive
		, CartNumber
		, IncubatorLocationNumber
		, CoolerID
		, IncubatorID
		, LoadDateTime
	)
	output inserted.IncubatorCartID into @IncubatorCartID(IncubatorCartID)
	select
		
		@I_vIncubatorCart
		,IsNull((select MAX(SortOrder) from IncubatorCart),0) + 1
		,1
		,@I_vCartNumber
		,@I_vIncubatorLocationNumber
		,@I_vCoolerID
		,@I_vIncubatorID
		,convert(datetime, @I_vLoadDate) + convert(datetime,@I_vLoadTime)
	select top 1 @I_vIncubatorCartID = IncubatorCartID, @iRowID = IncubatorCartID from @IncubatorCartID
end
else
begin
	update IncubatorCart
	set
		
		IncubatorCart = @I_vIncubatorCart
		--,SortOrder = @I_vSortOrder
		--,IsActive = @I_vIsActive
		,CartNumber = @I_vCartNumber
		,IncubatorLocationNumber = @I_vIncubatorLocationNumber
		--,CoolerID = @I_vCoolerID
		--,IncubatorID = @I_vIncubatorID
		,LoadDateTime = convert(datetime, @I_vLoadDate) + convert(datetime,@I_vLoadTime)
	where @I_vIncubatorCartID = IncubatorCartID
	select @iRowID = @I_vIncubatorCartID
end

if @I_vOrderIncubatorCartID = 0
begin
	declare @OrderIncubatorCartID table (OrderIncubatorCartID int)
	insert into OrderIncubatorCart (
		
		OrderIncubatorID
		, IncubatorCartID
		, PlannedQty
		, ActualQty
	)
	output inserted.OrderIncubatorCartID into @OrderIncubatorCartID(OrderIncubatorCartID)
	select
		
		@I_vOrderIncubatorID
		,@I_vIncubatorCartID
		,@I_vPlannedQty
		,@I_vActualQty
	select top 1 @I_vOrderIncubatorCartID = OrderIncubatorCartID, @iRowID = OrderIncubatorCartID from @OrderIncubatorCartID
end
else
begin
	update OrderIncubatorCart
	set
		
		OrderIncubatorID = @I_vOrderIncubatorID
		,IncubatorCartID = @I_vIncubatorCartID
		,PlannedQty = @I_vPlannedQty
		,ActualQty = @I_vActualQty
	where @I_vOrderIncubatorCartID = OrderIncubatorCartID
	select @iRowID = @I_vOrderIncubatorCartID
end



GO
