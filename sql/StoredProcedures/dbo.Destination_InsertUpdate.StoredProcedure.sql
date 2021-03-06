USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Destination_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Destination_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Destination_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Destination_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Destination_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[Destination_InsertUpdate]
	@I_vDestinationID int
	,@I_vDestination varchar(255)
	,@I_vPrimaryContactID int
	,@I_vSecondaryContactID int
	,@I_vNotes varchar(1000)
	,@I_vSortOrder int
	,@I_vIsActive bit
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if @I_vDestinationID = 0
begin
	declare @DestinationID table (DestinationID int)
	insert into dbo.Destination (
		
		Destination
		, PrimaryContactID
		, SecondaryContactID
		, Notes
		, SortOrder
		, IsActive
	)
	output inserted.DestinationID into @DestinationID(DestinationID)
	select
		
		@I_vDestination
		,@I_vPrimaryContactID
		,@I_vSecondaryContactID
		,@I_vNotes
		,@I_vSortOrder
		,@I_vIsActive
	select top 1 @I_vDestinationID = DestinationID, @iRowID = DestinationID from @DestinationID
end
else
begin
	update dbo.Destination
	set
		
		Destination = @I_vDestination
		,PrimaryContactID = @I_vPrimaryContactID
		,SecondaryContactID = @I_vSecondaryContactID
		,Notes = @I_vNotes
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vDestinationID = DestinationID
	select @iRowID = @I_vDestinationID
end

select @I_vDestinationID as ID,'forward' As referenceType



GO
