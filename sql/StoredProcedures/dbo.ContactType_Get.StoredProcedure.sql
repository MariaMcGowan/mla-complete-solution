USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ContactType_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ContactType_Get]
GO
/****** Object:  StoredProcedure [dbo].[ContactType_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactType_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ContactType_Get] AS' 
END
GO


ALTER proc [dbo].[ContactType_Get]
@ContactTypeID int = null
,@IncludeNew bit = 0
,@UserName nvarchar(255) = ''
As

select
	ContactTypeID
	, ContactType
	, SortOrder
	, IsActive
	, @UserName As UserName
	, case when IsRequired = 1 then 'Required- please do not change' else '' end as RequiredType
from dbo.ContactType
where IsNull(@ContactTypeID,ContactTypeID) = ContactTypeID
union all
select
	ContactTypeID = convert(int,0)
	, ContactType = convert(nvarchar(255),null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,null)
	, '' as RequiredType
,@UserName As UserName
where @IncludeNew = 1



GO
