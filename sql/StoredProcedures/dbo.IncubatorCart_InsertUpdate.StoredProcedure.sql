USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorCart_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorCart_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorCart_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorCart_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorCart_InsertUpdate] AS' 
END
GO
ALTER proc [dbo].[IncubatorCart_InsertUpdate]
	@I_vIncubatorCartID int
	,@I_vIncubatorCart varchar(255)
	,@I_vShelfCount int
	,@I_vEggCapacityPerShelf int
	,@I_vEggCapacity int
	,@I_vNotes varchar(1000)
	,@I_vSortOrder int
	,@I_vIsActive bit
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if @I_vIncubatorCartID = 0
begin
	declare @IncubatorCartID table (IncubatorCartID int)
	insert into dbo.IncubatorCart (
		
		IncubatorCart
		, ShelfCount
		, EggCapacityPerShelf
		, EggCapacity
		, Notes
		, SortOrder
		, IsActive
	)
	output inserted.IncubatorCartID into @IncubatorCartID(IncubatorCartID)
	select
		
		@I_vIncubatorCart
		,@I_vShelfCount
		,@I_vEggCapacityPerShelf
		,@I_vEggCapacity
		,@I_vNotes
		,@I_vSortOrder
		,@I_vIsActive
	select top 1 @I_vIncubatorCartID = IncubatorCartID, @iRowID = IncubatorCartID from @IncubatorCartID
end
else
begin
	update dbo.IncubatorCart
	set
		
		IncubatorCart = @I_vIncubatorCart
		,ShelfCount = @I_vShelfCount
		,EggCapacityPerShelf = @I_vEggCapacityPerShelf
		,EggCapacity = @I_vEggCapacity
		,Notes = @I_vNotes
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vIncubatorCartID = IncubatorCartID
	select @iRowID = @I_vIncubatorCartID
end
GO
