USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[csiGetUserAndBranch]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[csiGetUserAndBranch]
GO
/****** Object:  StoredProcedure [dbo].[csiGetUserAndBranch]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csiGetUserAndBranch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csiGetUserAndBranch] AS' 
END
GO



ALTER PROC [dbo].[csiGetUserAndBranch]
	@UserName varchar(150)
AS
	DECLARE @DATA TABLE (
		UserName varchar(255)
		, CanChangeBranch bit
	)
	INSERT INTO @DATA
	SELECT
		ISNULL((SELECT (CASE ContactName 
							WHEN '' THEN SUBSTRING(UserID, CHARINDEX('\', UserID)+1, LEN(UserID))
							ELSE ContactName 
						   END) AS UserName
				FROM csb.UserTable u with (nolock)
				WHERE UserID = @UserName ), @UserName)
		, 0


	SELECT TOP 1 
		ISNULL((SELECT UserName FROM @DATA), @UserName) AS UserName
		, ISNULL((SELECT CanChangeBranch FROM @DATA), 0) AS CanChangeBranch



GO
