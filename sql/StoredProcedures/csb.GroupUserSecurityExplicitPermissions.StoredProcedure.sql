USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[GroupUserSecurityExplicitPermissions]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[GroupUserSecurityExplicitPermissions]
GO
/****** Object:  StoredProcedure [csb].[GroupUserSecurityExplicitPermissions]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[GroupUserSecurityExplicitPermissions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[GroupUserSecurityExplicitPermissions] AS' 
END
GO

ALTER PROCEDURE [csb].[GroupUserSecurityExplicitPermissions]
AS
	SELECT Display='', Value='' 
	UNION ALL
	SELECT 'No Access', 'No Access' 
	UNION ALL
	SELECT 'Read Only', 'Read Only' 
	UNION ALL
	SELECT 'Read/Write', 'Read/Write'
GO
