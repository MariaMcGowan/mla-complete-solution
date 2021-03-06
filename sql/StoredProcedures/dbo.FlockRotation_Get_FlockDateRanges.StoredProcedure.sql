USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_Get_FlockDateRanges]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockRotation_Get_FlockDateRanges]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_Get_FlockDateRanges]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockRotation_Get_FlockDateRanges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockRotation_Get_FlockDateRanges] AS' 
END
GO



ALTER  proc [dbo].[FlockRotation_Get_FlockDateRanges]

As   

select PUlletFarmPlanID,
FarmID, 
case
	when Actual24WeekDate is not null and Actual65WeekDate is not null then Actual24WeekDate
	else Planned24WeekDate
end as SavedStartDate,
case
	when Actual24WeekDate is not null and Actual65WeekDate is not null then coalesce(ActualEndDate, Actual65WeekDate)
	else coalesce(PlannedEndDate, Planned65WeekDate)
end as SavedEndDate
from PulletFarmPlan




GO
