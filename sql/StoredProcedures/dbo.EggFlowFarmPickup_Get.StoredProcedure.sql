USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggFlowFarmPickup_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggFlowFarmPickup_Get]
GO
/****** Object:  StoredProcedure [dbo].[EggFlowFarmPickup_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggFlowFarmPickup_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggFlowFarmPickup_Get] AS' 
END
GO



ALTER proc [dbo].[EggFlowFarmPickup_Get] @Date date
as

select f.FarmID, f.FarmNumber, pfpd.*
from PulletFarmPlanDetail pfpd
inner join PulletFarmPlan_WeeklySchedule ws on pfpd.PulletFarmPlan_WeeklyScheduleID = ws.PulletFarmPlan_WeeklyScheduleID
inner join PulletFarmPlan pfp on ws.PulletFarmPlanID = pfp.PulletFarmPlanID
inner join Farm f on pfp.FarmID = f.FarmID
where Date = @Date
order by FarmNumber



GO
