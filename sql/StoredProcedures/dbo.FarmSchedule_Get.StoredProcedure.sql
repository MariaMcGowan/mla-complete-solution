/****** Object:  StoredProcedure [dbo].[FarmSchedule_Get]    Script Date: 5/12/2020 5:13:28 PM ******/
DROP PROCEDURE [dbo].[FarmSchedule_Get]
GO

/****** Object:  StoredProcedure [dbo].[FarmSchedule_Get]    Script Date: 5/12/2020 5:13:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[FarmSchedule_Get]  
	@FlockCode varchar(10) = null,
	@FarmID int = null,
	@PulletFacilityID int = null,
	@PlanningStartDate date = null, 
	@PlanningEndDate date = null
		
As  

declare @FemaleLivabilityRatio numeric(8,6)
	, @WarningRemovalDayCount int
	, @MaleLivabilityDuringProduction numeric(5,2)
	, @MaleFemaleBirdRatio numeric(5,2)

select @MaleLivabilityDuringProduction = ConstantValue
from SystemConstant
where IsActive = 1 and ConstantName = 'Expected Male Livability During Production Ratio'

select @MaleFemaleBirdRatio = ConstantValue
from SystemConstant
where IsActive = 1 and ConstantName = 'Male to Female Bird Ratio'

select @FemaleLivabilityRatio = ConstantValue 
from SystemConstant 
where ConstantName like '%female%'
and ConstantName like '%livability%'

select @WarningRemovalDayCount = ConstantValue 
from SystemConstant 
where ConstantName like '%Production%'
and ConstantName like '%removal%'
and ConstantName like '%end%date%'


select @FarmID = nullif(nullif(@FarmID, ''),0),
	@PulletFacilityID = nullif(nullif(@PulletFacilityID, ''),0),
	@FlockCode = nullif(@FlockCode, '')

select @PlanningStartDate = isnull(nullif(@PlanningStartDate, ''), getdate())
select @PlanningEndDate = isnull(nullif(@PlanningEndDate, ''), dateadd(year,2,@PlanningStartDate))

declare @FarmScheduleData table (FarmOrder int, PulletFarmPlanID int, 
FarmID int, PulletFacilityID int, FemaleBreed varchar(20), MaleBreed varchar(20), 
PlannedFemalesAt16Weeks int, 
PlannedMaleQtyAt16Weeks int, PlannedMaleQtyToRemove int,
ActualHatchDate date, Actual65WeekDate date, ActualEndDate date, 
FlockNumber varchar(20), ProductionFarm_RemoveDate date, ProductionFarm_RemovalDateConfirmed bit,
PulletFacility_RemoveDate date,PulletFacility_RemovalDateConfirmed bit,
ProductionFarm_MoveDayCount int, 
ProductionFarm_WashDownDate date, 
ProductionFarm_WashDownDateConfirmed bit, 
ProductionFarm_LitterDate date, 
ProductionFarm_LitterDateConfirmed bit, 
ProductionFarm_FumigationDate date, 
ProductionFarm_FumigationDateConfirmed bit, 
ProductionFarm_WashDownContractor varchar(10), FarmColor varchar(20), InvalidDates bit, Planned65WeekDate date)


insert into @FarmScheduleData (
FarmOrder
, PulletFarmPlanID
, FarmID
, PulletFacilityID
, FemaleBreed
, MaleBreed
, PlannedFemalesAt16Weeks
, PlannedMaleQtyAt16Weeks
, PlannedMaleQtyToRemove
, ActualHatchDate
, Actual65WeekDate
, ActualEndDate
, FlockNumber
, ProductionFarm_RemoveDate
, ProductionFarm_RemovalDateConfirmed
, PulletFacility_RemoveDate
, PulletFacility_RemovalDateConfirmed
, ProductionFarm_MoveDayCount
, ProductionFarm_WashDownDate
, ProductionFarm_WashDownDateConfirmed
, ProductionFarm_LitterDate
, ProductionFarm_LitterDateConfirmed
, ProductionFarm_FumigationDate
, ProductionFarm_FumigationDateConfirmed
, ProductionFarm_WashDownContractor
, InvalidDates
, Planned65WeekDate
)
select 
FarmOrder = row_number() over (partition by FarmID order by ActualHatchDate)
, PulletFarmPlanID
, FarmID
, PulletFacilityID
, FemaleBreed, MaleBreed
, PlannedFemalesAt16Weeks = PulletQtyAt16Weeks
, coalesce(PlannedMaleQtyAt16Weeks, round(PulletQtyAt16Weeks * @MaleFemaleBirdRatio,0))
, PlannedMaleQtyToRemove
, ActualHatchDate
, Actual65WeekDate
, ActualEndDate = coalesce(ActualEndDate, Actual65WeekDate)
, FlockNumber
, ProductionFarm_RemoveDate
, ProductionFarm_RemovalDateConfirmed
, PulletFacility_RemoveDate
, PulletFacility_RemovalDateConfirmed
, ProductionFarm_MoveDayCount
, ProductionFarm_WashDownDate
, ProductionFarm_WashDownDateConfirmed
, ProductionFarm_LitterDate
, ProductionFarm_LitterDateConfirmed
, ProductionFarm_FumigationDate
, ProductionFarm_FumigationDateConfirmed
, ProductionFarm_WashDownContractor
, 0
, Planned65WeekDate
from dbo.PulletFarmPlan
where FarmID is not null 
and FarmID = isnull(@FarmID, FarmID)
and isnull(PulletFacilityID,0) = coalesce(@PulletFacilityID, PulletFacilityID, 0)
and FlockNumber = isnull(@FlockCode, FlockNumber)


update @FarmScheduleData set PlannedMaleQtyToRemove = round(PlannedMaleQtyAt16Weeks * @MaleLivabilityDuringProduction,0)
where PlannedMaleQtyToRemove is null

-- MCM 07/12/2019
-- Per meeting notes from 06/20/2019
-- Take out the red formatting for flock that was changed was changed after order confirmation

--declare @InvalidDates table (PulletFarmPlanID int index idx1 Clustered, FieldName varchar(100))
--insert into @InvalidDates (PulletFarmPlanID, FieldName)
--select sd.PulletFarmPlanID, d.FieldName
--from @FarmScheduleData sd
--cross apply dbo.TestModifiedAfterOrderConfirmDates(sd.PulletFarmPlanID) d

--update psd set psd.InvalidDates = 1
--from @FarmScheduleData psd
--where exists 
--(
--	select 1 
--	from @InvalidDates 
--	where PulletFarmPlanID = psd.PulletFarmPlanID
--	-- This is a production farm screen, therefore only care about invalid dates associated to production side of things
--	and FieldName not like 'Pullet%'
--)



update fsd set fsd.FarmColor = isnull(pc.PlanningColor,'White') + 'Background'
from @FarmScheduleData fsd
inner join Farm f on fsd.FarmID = f.FarmID
left outer join PlanningColor pc on f.PlanningColorID = pc.PlanningColorID


select 
--CurrentFarm.*, NextFarm.*
CurrentFarm.FarmOrder, NextFarm.FarmOrder,
Farm + ' - ' + cast(FarmNumber as varchar) as FarmName, CurrentFarm.FemaleBreed, CurrentFarm.MaleBreed,
Current_ActualHatchDate = CurrentFarm.ActualHatchDate, 
CurrentFarm.PlannedFemalesAt16Weeks, 
CurrentFarm.PlannedMaleQtyAt16Weeks, 
PlannedFemalesToRemove = round(CurrentFarm.PlannedFemalesAt16Weeks * @FemaleLivabilityRatio,0),
CurrentFarm.PlannedMaleQtyToRemove,
Planned14WeekDate = dateadd(day,98,CurrentFarm.ActualHatchDate),
CurrentFarm.Planned65WeekDate,
CurrentFarm.Actual65WeekDate, 
CurrentFarm.ActualEndDate,
CurrentFarm.ProductionFarm_RemoveDate, 
CurrentFarm.ProductionFarm_RemovalDateConfirmed,
CurrentFarm.ProductionFarm_MoveDayCount, 
CurrentFarm.ProductionFarm_WashDownDate, 
CurrentFarm.ProductionFarm_WashDownDateConfirmed, 
CurrentFarm.ProductionFarm_LitterDate, 
CurrentFarm.ProductionFarm_LitterDateConfirmed, 
CurrentFarm.ProductionFarm_FumigationDate, 
CurrentFarm.ProductionFarm_FumigationDateConfirmed, 
CurrentFarm.ProductionFarm_WashDownContractor, 
NextFarm.PulletFacility_RemoveDate,
NextFarm.PulletFacility_RemovalDateConfirmed,
DaysBetweenFlocks =
case
	when CurrentFarm.ProductionFarm_RemoveDate is null then null
	when NextFarm.PulletFacility_RemoveDate is null then null
	else datediff(day, CurrentFarm.ProductionFarm_RemoveDate, NextFarm.PulletFacility_RemoveDate) - isnull(CurrentFarm.ProductionFarm_MoveDayCount,1)
end, FarmNumber, 
FarmName = Farm + ' - ' + cast(FarmNumber as varchar),
CurrentFarm.FlockNumber,
CurrentFarm.PulletFarmPlanID, CurrentFarm.FarmColor, InputColor = 'AliceBlueBackground',
-- MCM 07/12/2019 
-- Per meeting notes from 06/20/2019
-- Add red formatting when 65 week date and the actual removal date is > 7 days
DynamicFormattingForRemovalDate = 
	case
		when ABS(DATEDIFF(DAY,CurrentFarm.Actual65WeekDate, CurrentFarm.ProductionFarm_RemoveDate))> @WarningRemovalDayCount then 'DateWarning'
		else ''
	end
, @WarningRemovalDayCount as WarningRemovalDate, DateDiffVal = DATEDIFF(DAY,CurrentFarm.Actual65WeekDate, CurrentFarm.ProductionFarm_RemoveDate),
CommentCount = isnull((select count(*) from PulletFarmPlanComment where PulletFarmPlanID = CurrentFarm.PulletFarmPlanID and ScreenName = 'FarmSchedule'),0)
from @FarmScheduleData CurrentFarm
left outer join @FarmScheduleData NextFarm on CurrentFarm.FarmOrder = NextFarm.FarmOrder - 1 and CurrentFarm.FarmID = NextFarm.FarmID
--inner join PulletFacility pf on CurrentFarm.PulletFacilityID = pf.PulletFacilityID
inner join Farm f on CurrentFarm.FarmID = f.FarmID
--where CurrentFarm.ActualHatchDate between @PlanningStartDate and @PlanningEndDate
where exists (select 1 from RollingWeeklySchedule where PulletFarmPlanID = CurrentFarm.PulletFarmPlanID and WeekEndingDate between @PlanningStartDate and @PlanningEndDate)
and CurrentFarm.FarmID = isnull(@FarmID, CurrentFarm.FarmID)
--and CurrentFarm.PulletFacilityID = isnull(@PulletFacilityID, CurrentFarm.PulletFacilityID)
order by coalesce(CurrentFarm.Actual65WeekDate, CurrentFarm.Planned65WeekDate), CurrentFarm.FlockNumber



GO


