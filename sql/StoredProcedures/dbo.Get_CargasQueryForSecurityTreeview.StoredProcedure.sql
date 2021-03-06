USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Get_CargasQueryForSecurityTreeview]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Get_CargasQueryForSecurityTreeview]
GO
/****** Object:  StoredProcedure [dbo].[Get_CargasQueryForSecurityTreeview]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_CargasQueryForSecurityTreeview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Get_CargasQueryForSecurityTreeview] AS' 
END
GO


/* ----------------------- END CORE TABLES/PROCEDURES ----------------------- */

/* ----------------------- BEGIN SECURITY TABLES/PROCEDURES ----------------------- */
ALTER PROC [dbo].[Get_CargasQueryForSecurityTreeview]
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
