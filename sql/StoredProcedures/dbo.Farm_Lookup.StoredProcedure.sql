USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Farm_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Farm_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[Farm_Lookup]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Farm_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Farm_Lookup] AS' 
END
GO



ALTER proc [dbo].[Farm_Lookup]
	@IncludeBlank bit = 0
	,@IncludeAll bit = 0
	,@FarmID int = null
As

select FarmName, FarmID
from 
(
	select Farm + ' - ' + cast(FarmNumber as varchar) as FarmName,FarmID,SortOrder
	from dbo.Farm
	where IsActive = 1 and FarmID = isnull(@FarmID, FarmID)
	union all
	select '','',0
	where @IncludeBlank = 1

	union all
	select 'All','',0
	where @IncludeAll = 1
)a
Order by SortOrder



GO
