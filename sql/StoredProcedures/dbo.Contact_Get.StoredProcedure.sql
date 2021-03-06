USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Contact_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Contact_Get]
GO
/****** Object:  StoredProcedure [dbo].[Contact_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contact_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Contact_Get] AS' 
END
GO


ALTER proc [dbo].[Contact_Get]
@ContactID int = null
,@IncludeNew bit = 1
,@UserName nvarchar(255) = ''
As

select
	ContactID
	, Contact
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
	,@UserName As UserName
from Contact
where IsNull(@ContactID,ContactID) = ContactID
union all
select ContactID = convert(int,0)
	, Contact = convert(nvarchar(255),null)
	, FirstName = convert(varchar(50),null)
	, LastName = convert(varchar(50),null)
	, Email = convert(varchar(100),null)
	, OfficePhone = convert(varchar(15),null)
	, MobilePhone = convert(varchar(15),null)
	, FaxNumber = convert(varchar(15),null)
	, PrimaryMethodOfContact = convert(varchar(100),null)
	, Notes = convert(varchar(1000),null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,null)
	, ContactTypeID = convert(int,0)
	, UserName = @UserName 
where @IncludeNew = 1



GO
