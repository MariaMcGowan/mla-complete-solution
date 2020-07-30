
/****** Object:  StoredProcedure [dbo].[PulletSchedule_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletSchedule_Get]
GO

create proc [dbo].[PulletSchedule_Get]  
	@FlockCode varchar(10) = null,
	@PulletFacilityID int = null,
	@FarmID int = null,
	@PlanningStartDate date = null, 
	@PlanningEndDate date = null,
	@PulletFarmPlanID int = null
		
As  
--declare
--	@FlockCode varchar(10) = null,
--	@PulletFacilityID int = null,
--	@FarmID int = null,
--	@PlanningStartDate date = null, 
--	@PlanningEndDate date = null,
--	@PulletFarmPlanID int = null

--select @PulletFacilityID = '', @PlanningStartDate = '', @PlanningEndDate='', @FlockCode = '', @FarmID = '42'

select @FarmID = nullif(nullif(@FarmID, ''),0),
	@PulletFacilityID = nullif(nullif(@PulletFacilityID, ''),0),
	@FlockCode = nullif(@FlockCode, '')

select @PlanningStartDate = isnull(nullif(@PlanningStartDate, ''), '01/01/1999')
select @PlanningEndDate = isnull(nullif(@PlanningEndDate, ''), '1/1/2999')

declare @WarningHatchDayCount int
	, @WarningRemovalDayCount int
	, @MaleLivabilityDuringProduction numeric(5,2)
	, @MaleFemaleBirdRatio numeric(5,2)

select @MaleLivabilityDuringProduction = ConstantValue
from SystemConstant
where IsActive = 1 and ConstantName = 'Expected Male Livability During Production Ratio'

select @MaleFemaleBirdRatio = ConstantValue
from SystemConstant
where IsActive = 1 and ConstantName = 'Male to Female Bird Ratio'


select @WarningHatchDayCount = ConstantValue
from SystemConstant
where 
ConstantName like '%max%'
and ConstantName like '%difference%'
and ConstantName like '%actual%'
and ConstantName like '%planned%'
and ConstantName like '%hatch%'


select @WarningRemovalDayCount = ConstantValue
from SystemConstant
where 
ConstantName like '%max%'
and ConstantName like '%difference%'
and ConstantName like '%16%week%'
and ConstantName like '%removal%'


declare @PulletScheduleData table (PulletOrder int, PulletFarmPlanID int, FarmID int, 
PlannedFemalesAt16Weeks int, 
PlannedMaleQtyAt16Weeks int, PlannedMaleQtyToRemove int,
PulletFacilityID int, ActualHatchDate date,
PlannedHatchDate date, Actual16WeekDate as (dateadd(week, 16, ActualHatchDate)), FlockNumber varchar(20), 
FemaleBreed varchar(20), MaleBreed varchar(20),PulletFacility_RemoveDate date, PulletFacility_RemovalDateConfirmed bit,
PulletFacility_MoveDayCount int, PulletMover varchar(10), 
PulletFacility_WashDownDate date, PulletFacility_WashDownDateConfirmed bit,
PulletFacility_LitterDate date, PulletFacility_LitterDateConfirmed bit,
PulletFacility_FumigationDate date, PulletFacility_FumigationDateConfirmed bit,
PulletFacility_WashDownContractor varchar(10), FarmColor varchar(20), ContractTypeID int)


insert into @PulletScheduleData (PulletOrder, 
PulletFarmPlanID,FarmID, 
PulletFacilityID, ActualHatchDate, PlannedHatchDate, FlockNumber, FemaleBreed, MaleBreed, 
PulletFacility_RemoveDate, PulletFacility_RemovalDateConfirmed, 
PulletFacility_MoveDayCount, PulletMover, 
PulletFacility_WashDownDate, PulletFacility_WashDownDateConfirmed,
PulletFacility_LitterDate, PulletFacility_LitterDateConfirmed,
PulletFacility_FumigationDate, PulletFacility_FumigationDateConfirmed,
PulletFacility_WashDownContractor, 
PlannedFemalesAt16Weeks, PlannedMaleQtyAt16Weeks, PlannedMaleQtyToRemove, ContractTypeID)
select PulletOrder = row_number() over (partition by PulletFacilityID order by ActualHatchDate),
PulletFarmPlanID, FarmID, 
PulletFacilityID, ActualHatchDate, PlannedHatchDate, FlockNumber, FemaleBreed, MaleBreed, 
PulletFacility_RemoveDate, PulletFacility_RemovalDateConfirmed, 
PulletFacility_MoveDayCount, PulletMover, 
PulletFacility_WashDownDate, PulletFacility_WashDownDateConfirmed,
PulletFacility_LitterDate, PulletFacility_LitterDateConfirmed,
PulletFacility_FumigationDate, PulletFacility_FumigationDateConfirmed,
PulletFacility_WashDownContractor, 
PlannedFemalesAt16Weeks = PulletQtyAt16Weeks, 
coalesce(PlannedMaleQtyAt16Weeks, round(PulletQtyAt16Weeks * @MaleFemaleBirdRatio,0)),
PlannedMaleQtyToRemove, 
ContractTypeID
from dbo.PulletFarmPlan
where isnull(FlockNumber, 'X') = isnull(@FlockCode, isnull(FlockNumber, 'X'))

update @PulletScheduleData set PlannedMaleQtyToRemove = round(PlannedMaleQtyAt16Weeks * @MaleLivabilityDuringProduction,0)
where PlannedMaleQtyToRemove is null

update psd set psd.FarmColor = isnull(pc.PlanningColor,'White') + 'Background'
from @PulletScheduleData psd
inner join Farm f on psd.FarmID = f.FarmID
left outer join PlanningColor pc on f.PlanningColorID = pc.PlanningColorID



select CurrentPullet.PulletOrder, NextPullet.PulletOrder,
pf.PulletFacility, CurrentPullet.FemaleBreed, CurrentPullet.MaleBreed,
Current_ActualHatchDate = CurrentPullet.ActualHatchDate, 
CurrentPullet.PlannedFemalesAt16Weeks, CurrentPullet.PlannedMaleQtyAt16Weeks, 
CurrentPullet.PlannedMaleQtyToRemove,
Planned14WeekDate = dateadd(day,98,CurrentPullet.ActualHatchDate),
CurrentPullet.Actual16WeekDate, 
CurrentPullet.PulletFacility_RemoveDate, CurrentPullet.PulletFacility_RemovalDateConfirmed, 
CurrentPullet.PulletFacility_MoveDayCount, 
CurrentPullet.PulletMover,
CurrentPullet.PulletFacility_WashDownDate, CurrentPullet.PulletFacility_WashDownDateConfirmed, 
CurrentPullet.PulletFacility_LitterDate, CurrentPullet.PulletFacility_LitterDateConfirmed,
CurrentPullet.PulletFacility_FumigationDate, CurrentPullet.PulletFacility_FumigationDateConfirmed, 
CurrentPullet.PulletFacility_WashDownContractor, 
Next_ActualHatchDate = NextPullet.ActualHatchDate, 
DaysBetweenFlocks =
case
	when CurrentPullet.PulletFacility_RemoveDate is null then null
	when NextPullet.ActualHatchDate is null then null
	else datediff(day, CurrentPullet.PulletFacility_RemoveDate, NextPullet.ActualHatchDate) - isnull(CurrentPullet.PulletFacility_MoveDayCount,1)
end, FarmNumber, 
FarmName = Farm + ' - ' + cast(FarmNumber as varchar(4)),
CurrentPullet.FlockNumber,
CurrentPullet.PulletFarmPlanID, CurrentPullet.FarmColor, InputColor = 'AliceBlueBackground',
DynamicFormattingForHatchDate = 
	case
		when abs(datediff(day,CurrentPullet.ActualHatchDate, CurrentPullet.PlannedHatchDate))> @WarningHatchDayCount then 'DateWarning'
		else ''
	end,
DynamicFormattingForRemovalDate = 
	case
		when abs(datediff(day,CurrentPullet.Actual16WeekDate, CurrentPullet.PulletFacility_RemoveDate))> @WarningRemovalDayCount then 'DateWarning'
		else ''
	end,
Current_PlannedHatchDate = CurrentPullet.PlannedHatchDate
, @WarningRemovalDayCount as WarningRemovalDate, DateDiffVal = DATEDIFF(DAY,CurrentPullet.Actual16WeekDate, CurrentPullet.PulletFacility_RemoveDate)
, CommentCount = isnull((select count(*) from PulletFarmPlanComment where PulletFarmPlanID = CurrentPullet.PulletFarmPlanID and ScreenName = 'PulletSchedule'),0)
from @PulletScheduleData CurrentPullet
left outer join @PulletScheduleData NextPullet on CurrentPullet.PulletOrder = NextPullet.PulletOrder - 1 and isnull(CurrentPullet.PulletFacilityID,0) = NextPullet.PulletFacilityID and NextPullet.PulletFacilityID is not null
left outer join PulletFacility pf on CurrentPullet.PulletFacilityID = pf.PulletFacilityID
left outer join Farm f on CurrentPullet.FarmID = f.FarmID
where coalesce(CurrentPullet.ActualHatchDate, CurrentPullet.PlannedHatchDate) between @PlanningStartDate and @PlanningEndDate
and isnull(CurrentPullet.PulletFacilityID,0) = coalesce(@PulletFacilityID, CurrentPullet.PulletFacilityID, 0)
and coalesce(CurrentPullet.FarmID,0) = coalesce(@FarmID, CurrentPullet.FarmID,0) order by CurrentPullet.ActualHatchDate, CurrentPullet.FlockNumber


GO
