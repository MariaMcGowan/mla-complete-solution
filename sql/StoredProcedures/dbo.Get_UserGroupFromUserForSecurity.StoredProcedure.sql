USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Get_UserGroupFromUserForSecurity]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Get_UserGroupFromUserForSecurity]
GO
/****** Object:  StoredProcedure [dbo].[Get_UserGroupFromUserForSecurity]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_UserGroupFromUserForSecurity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Get_UserGroupFromUserForSecurity] AS' 
END
GO


ALTER PROC [dbo].[Get_UserGroupFromUserForSecurity]
	@UserID varchar(255) = NULL
AS
	SELECT ug.UserGroup
	FROM csb.UserTable ut
	INNER JOIN csb.UserGroup ug ON ut.UserGroupID = ug.UserGroupID
	WHERE ut.UserID = @UserID



GO
