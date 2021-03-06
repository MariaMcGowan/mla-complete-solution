USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[ScreenSecurityDefaultPermissions]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[ScreenSecurityDefaultPermissions]
GO
/****** Object:  StoredProcedure [csb].[ScreenSecurityDefaultPermissions]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[ScreenSecurityDefaultPermissions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[ScreenSecurityDefaultPermissions] AS' 
END
GO
ALTER PROC [csb].[ScreenSecurityDefaultPermissions]
AS
	SELECT Display='', Value=0
	UNION ALL
	SELECT 'Deny', -1 
	UNION ALL
	SELECT 'Allow', 1
GO
