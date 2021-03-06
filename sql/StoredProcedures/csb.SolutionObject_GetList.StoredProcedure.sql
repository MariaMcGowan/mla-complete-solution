USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[SolutionObject_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[SolutionObject_GetList]
GO
/****** Object:  StoredProcedure [csb].[SolutionObject_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[SolutionObject_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[SolutionObject_GetList] AS' 
END
GO

ALTER procedure [csb].[SolutionObject_GetList]
	@SolutionObjectTypeCode varchar(2),
	@SchemaName varchar(50),
	@ObjectNameFilter varchar(4000)
as

select o.SchemaName, o.ObjectName, o.TypeName, o.CreateDateTime, o.ModifyDateTime,
		o.Rows, o.TotalPagesUsed, o.DataPagesUsed, o.IndexPagesUsed
	from csb.SolutionObject o
	where o.SolutionObjectTypeCode like @SolutionObjectTypeCode
		and o.SchemaName like @SchemaName
		and o.ObjectName like '%' + @ObjectNameFilter + '%'
	order by SchemaDisplaySequence, ObjectTypeDisplaySequence

GO
