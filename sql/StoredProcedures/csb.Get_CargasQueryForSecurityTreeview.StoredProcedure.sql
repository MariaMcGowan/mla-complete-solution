USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[Get_CargasQueryForSecurityTreeview]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[Get_CargasQueryForSecurityTreeview]
GO
/****** Object:  StoredProcedure [csb].[Get_CargasQueryForSecurityTreeview]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[Get_CargasQueryForSecurityTreeview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[Get_CargasQueryForSecurityTreeview] AS' 
END
GO

--This proc gets created as part of Forms Authentication install
--CREATE PROCEDURE csb.UserTable_GetList
--    @IncludeAll bit = 0
--    , @UserTableID int = 0
--AS
--    SELECT
--	   UserTableID
--	   , UserID
--	   , EmailAddress
--	   , UserGroupID
--	   , ContactName
--	   , Inactive
--    FROM csb.userTable
--    WHERE @IncludeAll = 1 OR UserTableID = @UserTableID
--    UNION ALL
--    SELECT
--	   ''
--	   , ''
--	   , ''
--	   , ''
--	   , ''
--	   , CONVERT(BIT, 0)
--    WHERE @IncludeAll = 0 AND @UserTableID = 0
--GO

ALTER PROC [csb].[Get_CargasQueryForSecurityTreeview]
AS
	SELECT DISTINCT
		rowID = 'CargasQuery' --+ convert(varchar(50), CargasQueryFavoriteIdentifier)
		, parentID = 'CargasQuery'
		, nodeValue = '' --convert(varchar(50), CargasQueryFavoriteIdentifier)
		, displayValue = '' --Name
		, linkValue = '' --convert(varchar(50), CargasQueryFavoriteIdentifier) + '&p=CargasQuery'  --type=printPreview, name=''
		, screenValue = 'ResourceSecurity'
		, Level = 2
		, orderby = '' --Name
	--FROM csiCargasQueryFavorite
	WHERE 1 = 0
GO
