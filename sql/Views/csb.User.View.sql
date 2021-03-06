USE [MLA]
GO
/****** Object:  View [csb].[User]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP VIEW IF EXISTS [csb].[User]
GO
/****** Object:  View [csb].[User]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[csb].[User]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [csb].[User]
WITH SCHEMABINDING
AS
	SELECT
		UserID = u.UserTableID
		, UserTableID = u.UserTableID
		, UserGroupID = u.UserGroupID
		, UserName = u.UserID
		, FullName = u.ContactName
	FROM csb.UserTable u
' 
GO
