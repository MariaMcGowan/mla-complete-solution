USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[UserGroup_GetSelectList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[UserGroup_GetSelectList]
GO
/****** Object:  StoredProcedure [csb].[UserGroup_GetSelectList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[UserGroup_GetSelectList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[UserGroup_GetSelectList] AS' 
END
GO


ALTER PROCEDURE [csb].[UserGroup_GetSelectList]
AS
	SELECT
	   UserGroup
	   , UserGroupID
	FROM csb.UserGroup
	ORDER BY UserGroup

GO
