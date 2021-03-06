USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[SolutionSchema_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[SolutionSchema_GetList]
GO
/****** Object:  StoredProcedure [csb].[SolutionSchema_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[SolutionSchema_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[SolutionSchema_GetList] AS' 
END
GO

ALTER procedure [csb].[SolutionSchema_GetList]
	@IncludeAll bit = 0
as

select ss.Description, ss.SchemaName, 2 as SelectSequence, ss.DisplaySequence
	from csb.SolutionSchema ss
union
select 'All', '%', 1, 1
	where @IncludeAll = 1
order by SelectSequence, DisplaySequence

GO
