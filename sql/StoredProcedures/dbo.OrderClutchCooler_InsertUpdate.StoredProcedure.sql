USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderClutchCooler_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderClutchCooler_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OrderClutchCooler_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderClutchCooler_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderClutchCooler_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[OrderClutchCooler_InsertUpdate]
	@I_vOrderClutchCoolerID int
	,@I_vOrderFlockClutchID int
	,@I_vCoolerID int = null
	,@I_vPlannedQty int = 0
	,@I_vActualQty int = 0
	,@I_vDateTimeDelivered datetime = null
	,@I_vDateDelivered date = null
	,@I_vTimeDelivered time = null
	,@I_vDateTimeMovedToIncubator datetime = null
	,@I_vDateMovedToIncubator date = null
	,@I_vTimeMovedToIncubator time = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

If @I_vDateDelivered is not null
begin
	select @I_vDateTimeDelivered = convert(datetime,@I_vDateDelivered) + convert(datetime,@I_vTimeDelivered)
end

If @I_vDateMovedToIncubator is not null
begin
	select @I_vDateMovedToIncubator = convert(datetime,@I_vDateMovedToIncubator) + convert(datetime,@I_vTimeMovedToIncubator)
end


if @I_vOrderClutchCoolerID = 0
begin
	declare @OrderClutchCoolerID table (OrderClutchCoolerID int)
	insert into OrderClutchCooler (
		
		OrderFlockClutchID
		, CoolerID
		, PlannedQty
		, ActualQty
		, DateTimeDelivered
		, DateTimeMovedToIncubator
	)
	output inserted.OrderClutchCoolerID into @OrderClutchCoolerID(OrderClutchCoolerID)
	select
		
		@I_vOrderFlockClutchID
		,@I_vCoolerID
		,@I_vPlannedQty
		,@I_vActualQty
		,@I_vDateTimeDelivered
		,@I_vDateTimeMovedToIncubator
	select top 1 @I_vOrderClutchCoolerID = OrderClutchCoolerID, @iRowID = OrderClutchCoolerID from @OrderClutchCoolerID
end
else
begin
	update OrderClutchCooler
	set
		
		OrderFlockClutchID = @I_vOrderFlockClutchID
		,CoolerID = @I_vCoolerID
		,PlannedQty = @I_vPlannedQty
		,ActualQty = @I_vActualQty
		,DateTimeDelivered = @I_vDateTimeDelivered
		,DateTimeMovedToIncubator = @I_vDateTimeMovedToIncubator
	where @I_vOrderClutchCoolerID = OrderClutchCoolerID
	select @iRowID = @I_vOrderClutchCoolerID
end



GO
