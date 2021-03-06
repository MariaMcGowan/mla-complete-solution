USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Contact_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Contact_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Contact_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contact_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Contact_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[Contact_InsertUpdate]
	@I_vContactID int
	,@I_vFirstName varchar(50) = null
	,@I_vLastName varchar(50)  = null
	,@I_vEmail varchar(100)  = null
	,@I_vOfficePhone varchar(15)  = null
	,@I_vMobilePhone varchar(15)  = null
	,@I_vFaxNumber varchar(15)  = null
	,@I_vPrimaryMethodOfContact varchar(100)  = null
	,@I_vNotes varchar(1000)  = null
	,@I_vSortOrder int  = null
	,@I_vIsActive bit = null
	,@I_vContactTypeID int = null
	,@I_vUserName nvarchar(255) = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
as


declare @Contact varchar(100)
set @Contact = isnull(@I_vFirstName,'') + ' ' + isnull(@I_vLastName,'')

if @I_vContactID = 0
begin
	declare @ContactID table (ContactID int)
	insert into dbo.Contact (		
		Contact
		, FirstName
		, LastName
		, Email
		, OfficePhone
		, MobilePhone
		, FaxNumber
		, PrimaryMethodOfContact
		, Notes
		, SortOrder
		, IsActive
		, ContactTypeID
	)
	output inserted.ContactID into @ContactID(ContactID)

	select
		
		@Contact
		,@I_vFirstName
		,@I_vLastName
		,@I_vEmail
		,@I_vOfficePhone
		,@I_vMobilePhone
		,@I_vFaxNumber
		,@I_vPrimaryMethodOfContact
		,@I_vNotes
		,@I_vSortOrder
		,@I_vIsActive
		,@I_vContactTypeID
	select top 1 @I_vContactID = ContactID, @iRowID = ContactID from @ContactID
end
else
begin
	update dbo.Contact
	set
		Contact = @Contact
		,FirstName = @I_vFirstName
		,LastName = @I_vLastName
		,Email = @I_vEmail
		,OfficePhone = @I_vOfficePhone
		,MobilePhone = @I_vMobilePhone
		,FaxNumber = @I_vFaxNumber
		,PrimaryMethodOfContact = @I_vPrimaryMethodOfContact
		,ContactTypeID = @I_vContactTypeID
		,Notes = @I_vNotes
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vContactID = ContactID
	select @iRowID = @I_vContactID
end

select @I_vContactID as ID,'forward' As referenceType



GO
