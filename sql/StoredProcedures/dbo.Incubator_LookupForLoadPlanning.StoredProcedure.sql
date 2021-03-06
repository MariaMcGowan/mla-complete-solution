USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Incubator_LookupForLoadPlanning]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Incubator_LookupForLoadPlanning]
GO
/****** Object:  StoredProcedure [dbo].[Incubator_LookupForLoadPlanning]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Incubator_LookupForLoadPlanning]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Incubator_LookupForLoadPlanning] AS' 
END
GO


ALTER proc [dbo].[Incubator_LookupForLoadPlanning]
@LoadPlanningID int
AS

select Incubator,IncubatorID, SortOrder
from dbo.Incubator
where IsActive = 1
and IncubatorID not in (select IncubatorID from OrderIncubator where OrderIncubatorID in
	(select OrderIncubatorID1 from LoadPlanning where LoadPlanningID = @LoadPlanningID
	union all select OrderIncubatorID2 from LoadPlanning where LoadPlanningID = @LoadPlanningID
	union all select OrderIncubatorID3 from LoadPlanning where LoadPlanningID = @LoadPlanningID
	union all select OrderIncubatorID4 from LoadPlanning where LoadPlanningID = @LoadPlanningID
	union all select OrderIncubatorID5 from LoadPlanning where LoadPlanningID = @LoadPlanningID
	union all select OrderIncubatorID6 from LoadPlanning where LoadPlanningID = @LoadPlanningID
	union all select OrderIncubatorID7 from LoadPlanning where LoadPlanningID = @LoadPlanningID
	union all select OrderIncubatorID8 from LoadPlanning where LoadPlanningID = @LoadPlanningID
	)
)
order by SortOrder



GO
