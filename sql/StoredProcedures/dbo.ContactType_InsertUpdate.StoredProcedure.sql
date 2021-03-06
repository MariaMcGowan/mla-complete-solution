USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ContactType_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ContactType_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[ContactType_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactType_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ContactType_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[ContactType_InsertUpdate]
	@I_vContactTypeID int
	,@I_vContactType nvarchar(255) = null
	,@I_vSortOrder int = null
	,@I_vIsActive bit = null
	,@I_vUserName nvarchar(255) = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if 1 = IsNull((select IsRequired from ContactType where ContactTypeID = @I_vContactTypeID),0)
begin
	set @I_vIsActive = 1
end

if @I_vContactTypeID = 0
begin
	declare @ContactTypeID table (ContactTypeID int)
	insert into dbo.ContactType (
		
		ContactType
		, SortOrder
		, IsActive
	)
	output inserted.ContactTypeID into @ContactTypeID(ContactTypeID)
	select
		
		@I_vContactType
		,@I_vSortOrder
		,@I_vIsActive
	select top 1 @I_vContactTypeID = ContactTypeID, @iRowID = ContactTypeID from @ContactTypeID
end
else
begin
	update dbo.ContactType
	set
		
		ContactType = @I_vContactType
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vContactTypeID = ContactTypeID
	select @iRowID = @I_vContactTypeID
end

select @I_vContactTypeID as ID,'forward' As referenceType



GO
