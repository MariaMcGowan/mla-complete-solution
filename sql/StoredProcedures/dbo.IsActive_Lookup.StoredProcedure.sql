USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IsActive_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IsActive_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[IsActive_Lookup]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsActive_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IsActive_Lookup] AS' 
END
GO



ALTER proc [dbo].[IsActive_Lookup]
	@IncludeBlank bit = 0
	,@IncludeAll bit = 0
As

select 'Active' as IsActiveText, 1 as IsActive
union all
select 'Inactive' as IsActiveText, 0 as IsActive
union all
select '',-1
where @IncludeBlank = 1

union all
select 'All',-1
where @IncludeAll = 1



GO
