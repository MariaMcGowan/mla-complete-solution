USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanSummary_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlanSummary_Get]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanSummary_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanSummary_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlanSummary_Get] AS' 
END
GO



ALTER proc [dbo].[PulletFarmPlanSummary_Get]  @ContractTypeID int = 1
as 

select FarmNumber, FlockNumber, 
PulletFacility, 
PulletQtyAt16Weeks, 
PlannedOrActual = 
case
	when pfp.Actual24WeekDate is null then 'P'
	else 'A'
end, 
HatchDate = coalesce(pfp.ActualHatchDate, pfp.PlannedHatchDate),
Week24 = coalesce(pfp.Actual24WeekDate, pfp.Planned24WeekDate), 
Week65 = coalesce(pfp.Actual65WeekDate, pfp.Planned65WeekDate), 
StartDate = 
	case
		when pfp.Actual24WeekDate is null then coalesce(pfp.PlannedStartDate, pfp.Planned24WeekDate)
		else coalesce(pfp.ActualStartDate, pfp.Actual24WeekDate)
	end,
EndDate = 
	case
		when pfp.Actual24WeekDate is null then coalesce(pfp.PlannedEndDate, pfp.Planned65WeekDate)
		else coalesce(pfp.ActualEndDate, pfp.Actual65WeekDate)
	end,
PulletFacility_RemoveDate, 
ProductionFarm_RemoveDate,
PulletFarmPlanID
from PulletFarmPlan pfp
inner join Farm f on pfp.FarmID = f.FarmID
left outer join PulletFacility pf on pfp.PulletFacilityID = pf.PulletFacilityID
where ContractTypeID = @ContractTypeID
order by coalesce(pfp.ActualHatchDate, pfp.PlannedHatchDate) desc



GO
