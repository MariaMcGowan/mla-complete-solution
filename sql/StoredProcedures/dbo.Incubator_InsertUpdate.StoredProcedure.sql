USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Incubator_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Incubator_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Incubator_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Incubator_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Incubator_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[Incubator_InsertUpdate]
	@I_vIncubatorID int
	,@I_vIncubator varchar(255) = null
	,@I_vNotes varchar(1000) = null
	,@I_vSortOrder int = null
	,@I_vColumn_Count int = null
	,@I_vRow_Count int = null
	,@I_vIsActive bit = null
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if @I_vIncubatorID = 0
begin
	declare @IncubatorID table (IncubatorID int)
	insert into dbo.Incubator (
		
		Incubator
		, CartCapacity
		, Notes
		, SortOrder
		, IsActive
		, Column_Count
		, Row_Count
	)
	output inserted.IncubatorID into @IncubatorID(IncubatorID)
	select
		
		@I_vIncubator
		,isnull(@I_vRow_Count, 0) * isnull(@I_vColumn_Count, 0)
		,@I_vNotes
		,@I_vSortOrder
		,@I_vIsActive
		,@I_vColumn_Count
		,@I_vRow_Count

	select top 1 @I_vIncubatorID = IncubatorID, @iRowID = IncubatorID from @IncubatorID
end
else
begin
	update dbo.Incubator
	set
		
		Incubator = @I_vIncubator
		,CartCapacity = isnull(@I_vRow_Count, 0) * isnull(@I_vColumn_Count, 0)
		,Notes = @I_vNotes
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
		,Column_Count = @I_vColumn_Count
		,Row_Count = @I_vRow_Count
	where @I_vIncubatorID = IncubatorID
	select @iRowID = @I_vIncubatorID
end


select @I_vIncubatorID as ID,'forward' As referenceType



GO
