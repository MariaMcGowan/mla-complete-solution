USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Incubator_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Incubator_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[Incubator_Lookup]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Incubator_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Incubator_Lookup] AS' 
END
GO


ALTER proc [dbo].[Incubator_Lookup]
	@IncludeBlank bit = 1
	,@IncludeAll bit = 0
As

select Incubator,IncubatorID, SortOrder
from dbo.Incubator
where IsActive = 1

union all
select '','',0
where @IncludeBlank = 1

union all
select 'All','',0
where @IncludeAll = 1
order by 1



GO
