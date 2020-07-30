USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[SolutionObjectType_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[SolutionObjectType_GetList]
GO
/****** Object:  StoredProcedure [csb].[SolutionObjectType_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[SolutionObjectType_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[SolutionObjectType_GetList] AS' 
END
GO

ALTER procedure [csb].[SolutionObjectType_GetList]
	@IncludeAll bit = 0
as

select o.TypeName + ' (' + convert(varchar, count(*)) + ')' as Name, 
		o.SolutionObjectTypeCode, 2 as DisplaySequence
	from csb.SolutionObject o
	group by o.TypeName, o.SolutionObjectTypeCode
union
select 'All', '%', 1
	where @IncludeAll = 1
order by DisplaySequence, Name

GO
