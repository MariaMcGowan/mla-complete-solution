USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[User_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[User_GetList]
GO
/****** Object:  StoredProcedure [csb].[User_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[User_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[User_GetList] AS' 
END
GO

ALTER PROCEDURE [csb].[User_GetList]
	@IncludeAll bit = 0
	, @UserTableID int = 0 
AS
	SELECT
		u.FullName
		, u.UserTableID
		, u.UserID
		, 2 AS Sequence
	FROM csb.[User] u
	WHERE @IncludeAll = 1 OR u.UserTableID = @UserTableID
	UNION
	SELECT
		'All'
		, 0
		, 0
		, 1 AS Sequence
	WHERE @IncludeAll = 1 OR @UserTableID = 0
	ORDER BY Sequence, FullName

GO
