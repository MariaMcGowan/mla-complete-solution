USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubator_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HoldingIncubator_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubator_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldingIncubator_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HoldingIncubator_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[HoldingIncubator_InsertUpdate]
	@I_vHoldingIncubatorID int
	,@I_vHoldingIncubator varchar(255) = null
	,@I_vCartCapacity int = null
	,@I_vRow_Count int = null
	,@I_vColumn_Count int = null
	,@I_vNotes varchar(1000) = null
	,@I_vSortOrder int = null
	,@I_vIsActive bit = null
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if @I_vHoldingIncubatorID = 0
begin
	declare @HoldingIncubatorID table (HoldingIncubatorID int)
	insert into dbo.HoldingIncubator (
		HoldingIncubator
		, CartCapacity
		, Row_Count
		, Column_Count
		, Notes
		, SortOrder
		, IsActive
	)
	output inserted.HoldingIncubatorID into @HoldingIncubatorID(HoldingIncubatorID)
	select
		
		@I_vHoldingIncubator
		,@I_vCartCapacity
		,@I_vRow_Count
		,@I_vColumn_Count
		,@I_vNotes
		,@I_vSortOrder
		,@I_vIsActive
	select top 1 @I_vHoldingIncubatorID = HoldingIncubatorID, @iRowID = HoldingIncubatorID from @HoldingIncubatorID
end
else
begin
	update dbo.HoldingIncubator
	set
		
		HoldingIncubator = @I_vHoldingIncubator
		,CartCapacity = @I_vCartCapacity
		,Row_Count = @I_vRow_Count
		,Column_Count = @I_vColumn_Count
		,Notes = @I_vNotes
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vHoldingIncubatorID = HoldingIncubatorID
	select @iRowID = @I_vHoldingIncubatorID
end


select @I_vHoldingIncubatorID as ID,'forward' As referenceType


GO
