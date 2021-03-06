USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlan_Form_UpdateActuals_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlan_Form_UpdateActuals_Get]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlan_Form_UpdateActuals_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan_Form_UpdateActuals_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlan_Form_UpdateActuals_Get] AS' 
END
GO



ALTER proc [dbo].[PulletFarmPlan_Form_UpdateActuals_Get]  
	@PulletFarmPlanID int
As  

	select PulletFarmPlanID
	, FarmNumber
	, pfp.ConservativeFactor
	, PulletQtyAt16Weeks
	, Planned24WeekDate
	, Actual24WeekDate
	, PlannedStartDate = isnull(PlannedStartDate, Planned24WeekDate)
	, ActualStartDate = isnull(ActualStartDate, Actual24WeekDate)
	, PlannedEndDate = isnull(PlannedEndDate, Planned65WeekDate), Planned65WeekDate
	, ActualEndDate = isnull(ActualEndDate, Actual65WeekDate), Actual65WeekDate
	, Planned65WeekDate
	, Actual65WeekDate
	from PulletFarmPlan pfp
	inner join Farm f on pfp.FarmID = f.FarmID
	where PulletFarmPlanID = @PulletFarmPlanID




GO
