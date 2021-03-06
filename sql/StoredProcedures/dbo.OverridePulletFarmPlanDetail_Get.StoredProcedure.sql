USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OverridePulletFarmPlanDetail_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OverridePulletFarmPlanDetail_Get]
GO
/****** Object:  StoredProcedure [dbo].[OverridePulletFarmPlanDetail_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OverridePulletFarmPlanDetail_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OverridePulletFarmPlanDetail_Get] AS' 
END
GO



ALTER proc [dbo].[OverridePulletFarmPlanDetail_Get] 
	@StartDate date = null, @EndDate date = null, @FarmID int = null, @ContractTypeID int = null
as

select @StartDate = isnull(nullif(@StartDate, ''), convert(date,getdate()))
select @EndDate = isnull(nullif(@EndDate, ''),dateadd(day,7,@StartDate)),
	@FarmID = isnull(nullif(@FarmID, ''),0),
	@ContractTypeID = isnull(nullif(@ContractTypeID,''),0)


declare @EggsPerCase int = 360

select 
	UniqueRowID = row_number() over (order by Date),
	Date,
	PulletFarmPlanDetailID,
	SettableEggs = coalesce(nullif(OverwrittenSettableEggs,0), CalcSettableEggs),
	SettableEggs_Cases = round(coalesce(nullif(OverwrittenSettableEggs,0), CalcSettableEggs) / (@EggsPerCase * 1.0),1),
	CurrentStatus = 
		case
			when pfpd.ReservedForContract = 1 then 'Reserved'
			when pfpd.ReservedForContract = 0 then 'Not Reserved'
		end,
	ReserveReleaseID = convert(int, null)
from PulletFarmPlan pfp
--inner join PulletFarmPlan_WeeklySchedule ws on pfp.PulletFarmPlanID = ws.PulletFarmPlanID
--inner join PulletFarmPlanDetail pfpd on ws.PulletFarmPlan_WeeklyScheduleID = pfpd.PulletFarmPlan_WeeklyScheduleID
inner join PulletFarmPlanDetail pfpd on pfp.PulletFarmPlanID = pfpd.PulletFarmPlanID
inner join Farm f on pfp.FarmID = f.FarmID
where f.FarmID = @FarmID and Date between @StartDate and @EndDate 
and Date >= coalesce(ActualStartDate, PlannedStartDate)
and Date <= coalesce(ActualEndDate, PlannedEndDate) 


GO
