USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[UserGroup_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[UserGroup_GetList]
GO
/****** Object:  StoredProcedure [csb].[UserGroup_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[UserGroup_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[UserGroup_GetList] AS' 
END
GO

ALTER PROCEDURE [csb].[UserGroup_GetList]
	@IncludeAll bit = 0
	, @UserGroupID int = 0 
AS
	SELECT
		UserGroupID
		, UserGroup
		, 2 AS Sequence
	FROM csb.UserGroup
	WHERE @IncludeAll = 1 OR UserGroupID = @UserGroupID
	UNION
	SELECT
		0
		, ''
		, 1 AS Sequence
	WHERE @IncludeAll = 1 OR @UserGroupID = 0
	ORDER BY Sequence, UserGroup

GO
