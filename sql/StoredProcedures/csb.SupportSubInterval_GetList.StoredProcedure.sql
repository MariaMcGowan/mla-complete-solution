USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[SupportSubInterval_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[SupportSubInterval_GetList]
GO
/****** Object:  StoredProcedure [csb].[SupportSubInterval_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[SupportSubInterval_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[SupportSubInterval_GetList] AS' 
END
GO

ALTER procedure [csb].[SupportSubInterval_GetList]
	@IncludeDefault bit = 0
as
	select ssi.Name, ssi.SupportSubIntervalID, ssi.SignificantLength
		from csb.SupportSubInterval ssi
	union
	select 'Default', -1, 1000
		where @IncludeDefault = 1
	order by SignificantLength desc

GO
