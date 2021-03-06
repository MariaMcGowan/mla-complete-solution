USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletSchedule_GetPulletFarmPlanID]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletSchedule_GetPulletFarmPlanID]
GO
/****** Object:  StoredProcedure [dbo].[PulletSchedule_GetPulletFarmPlanID]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletSchedule_GetPulletFarmPlanID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletSchedule_GetPulletFarmPlanID] AS' 
END
GO



ALTER proc [dbo].[PulletSchedule_GetPulletFarmPlanID]  
	@PulletFarmPlanID int
		
As  


select FlockNumber, PulletFacility, 
PlannedHatchDate, ActualHatchDate, 
ProductionFarm_RemoveDate, 
PulletFacility_MoveDayCount,
PulletMover,
PulletFacility_WashDownContractor,
PulletFacility_LitterDate,
PulletFacility_FumigationDate,
PulletFacility_WashDownDate,
DynamicFormatting = 
	case
		when abs(datediff(day,ActualHatchDate, PlannedHatchDate)) >= 10 then 'DateWarning'
		else ''
	end
from dbo.PulletFarmPlan pfp
inner join PulletFacility pf on pfp.PulletFacilityID = pf.PulletFacilityID
where PulletFarmPlanID = @PulletFarmPlanID



GO
