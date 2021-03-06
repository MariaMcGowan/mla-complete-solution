USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[SupportInterval_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[SupportInterval_GetList]
GO
/****** Object:  StoredProcedure [csb].[SupportInterval_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[SupportInterval_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[SupportInterval_GetList] AS' 
END
GO

ALTER PROCEDURE [csb].[SupportInterval_GetList]
AS
	SELECT
		si.Name
		, si.SupportIntervalID
	FROM csb.SupportInterval si
	ORDER BY si.MinuteCount

GO
