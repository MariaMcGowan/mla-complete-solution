USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[UserTable_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[UserTable_GetList]
GO
/****** Object:  StoredProcedure [csb].[UserTable_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[UserTable_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[UserTable_GetList] AS' 
END
GO
ALTER proc [csb].[UserTable_GetList] @IncludeAll int = 1, @UserTableID int = null, @UserName varchar(100) = null
AS

	if @UserTableID is not null and @UserTableID = 0
		select @IncludeAll = 0


    SELECT
	   UserTableID
	   , UserID
	   , EmailAddress
	   , UserGroupID
	   , ContactName
	   , Inactive
    FROM csb.userTable
	where UserTableID = @UserTableID
	or @IncludeAll = 1
    UNION ALL
    SELECT
	   convert(int,0) as UserTableID
	   , 'THESUMMITGRP\{Enter User ID Here}' as UserID
	   , '' as EmailAddress
	   , convert(int,null) as UserGroupID
	   , '' as ContactName
	   , CONVERT(BIT, 0) as Inactive
	where @UserTableID = 0
GO
