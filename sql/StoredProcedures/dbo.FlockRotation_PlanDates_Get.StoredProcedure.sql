USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_PlanDates_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockRotation_PlanDates_Get]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_PlanDates_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockRotation_PlanDates_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockRotation_PlanDates_Get] AS' 
END
GO



ALTER proc [dbo].[FlockRotation_PlanDates_Get] @PulletFarmPlanID int = null, @UserFlockPlanChangesID int = null
as

select @PulletFarmPlanID = nullif(@PulletFarmPlanID, ''), 
	@UserFlockPlanChangesID = nullif(@UserFlockPlanChangesID, '')


if @PulletFarmPlanID is null
begin
	select @PulletFarmPlanID = PulletFarmPlanID
	from UserFlockPlanChanges
	where UserFlockPlanChangesID = @UserFlockPlanChangesID
end

declare @InvalidDates table (FieldName varchar(50))
insert into @InvalidDates
select * from dbo.TestModifiedAfterOrderConfirmDates(@PulletFarmPlanID)

select PulletFarmPlanID, FlockNumber, PulletFacility, pfp.PulletFacilityID,
f.FarmNumber, 
pfp.FlockNumber, 
PlannedHatchDate, 
PlannedHatchDateFormat = 
	case
		when OverrideModifiedAfterOrderConfirm = 0 and exists (select 1 from @InvalidDates where FieldName = 'Planned24WeekDate') then 'redFont'
		else 'blackFont'
	end,
ActualHatchDate, 
Planned16WeekDate,
Actual16WeekDate, 
Planned24WeekDate,
Actual24WeekDate,
Planned65WeekDate,
Actual65WeekDate,
PlannedStartDate,
ActualStartDate,
PulletFacility_RemoveDate,
PulletFacility_RemoveDate_Format = 
	case
		when exists (select 1 from @InvalidDates where FieldName = 'PulletFacility_RemoveDate') then 'redFont'
		else 'blackFont'
	end,
PulletFacility_FumigationDate,
PulletFacility_FumigationDate_Format = 
	case
		when exists (select 1 from @InvalidDates where FieldName = 'PulletFacility_FumigationDate') then 'redFont'
		else 'blackFont'
	end,
PulletFacility_LitterDate,
PulletFacility_LitterDate_Format = 
	case
		when exists (select 1 from @InvalidDates where FieldName = 'PulletFacility_LitterDate') then 'redFont'
		else 'blackFont'
	end,
PulletFacility_WashDownDate,
PulletFacility_WashDownDate_Format = 
	case
		when exists (select 1 from @InvalidDates where FieldName = 'PulletFacility_WashDownDate') then 'redFont'
		else 'blackFont'
	end,

ProductionFarm_RemoveDate,
ProductionFarm_RemoveDate_Format = 
	case
		when exists (select 1 from @InvalidDates where FieldName = 'ProductionFarm_RemoveDate') then 'redFont'
		else 'blackFont'
	end,
ProductionFarm_FumigationDate,
ProductionFarm_FumigationDate_Format = 
	case
		when exists (select 1 from @InvalidDates where FieldName = 'ProductionFarm_FumigationDate') then 'redFont'
		else 'blackFont'
	end,
ProductionFarm_LitterDate,
ProductionFarm_LitterDate_Format = 
	case
		when exists (select 1 from @InvalidDates where FieldName = 'ProductionFarm_LitterDate') then 'redFont'
		else 'blackFont'
	end,
ProductionFarm_WashDownDate,
ProductionFarm_WashDownDate_Format = 
	case
		when exists (select 1 from @InvalidDates where FieldName = 'ProductionFarm_WashDownDate') then 'redFont'
		else 'blackFont'
	end,
OverrideModifiedAfterOrderConfirm
from PulletFarmPlan pfp
left outer join PulletFacility pf on pfp.PulletFacilityID = pf.PulletFacilityID
inner join Farm f on pfp.FarmID = f.FarmID
where PulletFarmPlanID = @PulletFarmPlanID


GO
