USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletDates_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletDates_Get]
GO
/****** Object:  StoredProcedure [dbo].[PulletDates_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletDates_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletDates_Get] AS' 
END
GO



ALTER proc [dbo].[PulletDates_Get] @PulletFarmPlanID int 
as

select PulletFarmPlanID, FlockNumber, PulletFacility, 
PlannedHatchDate, ActualHatchDate, 
PulletFacility_RemoveDate, 
PulletFacility_FumigationDate,
PulletFacility_LitterDate,
PulletFacility_WashDownDate,
ProductionFarm_RemoveDate,
ProductionFarm_FumigationDate,
ProductionFarm_LitterDate,
ProductionFarm_WashDownDate
from PulletFarmPlan pfp
inner join PulletFacility pf on pfp.PulletFacilityID = pf.PulletFacilityID
inner join Farm f on pfp.FarmID = f.FarmID
where PulletFarmPlanID = @PulletFarmPlanID


GO
