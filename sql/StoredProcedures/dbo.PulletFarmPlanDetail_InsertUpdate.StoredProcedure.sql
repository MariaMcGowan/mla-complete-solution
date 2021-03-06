
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanDetail_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlanDetail_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanDetail_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanDetail_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlanDetail_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[PulletFarmPlanDetail_InsertUpdate] 
	@PulletFarmPlanID int,
	@PulletQtyChanged bit = 0,
	@ConservativeFactorChanged bit = 0

as

--declare @PulletFarmPlanID int = 2049

declare @FarmID int, 
	@PulletQtyAt16Weeks int, 
	@FlockStartDate date,
	@FlockEndDate date,
	@HatchDate date,
	@ConservativeFactor numeric(8,6), 
	@ContractTypeID int,
	@PlannedOrActual varchar(1),
	@StartWeekNumber int,
	@EndWeekNumber int, 
	@DefaultDateFirst int, 
	@RerunCalculations bit = 0


select @DefaultDateFirst = @@datefirst

if @PulletQtyChanged = 1
	select @RerunCalculations = 1

if @ConservativeFactorChanged = 1
	select @RerunCalculations = 1

		
if @DefaultDateFirst <> 7
	set datefirst 7

--declare @PulletFarmPlan_WeeklySchedule table (PulletFarmPlan_WeeklyScheduleID int, WeekNumber int)

select @StartWeekNumber = isnull(ConstantValue, 16) 
from SystemConstant
where ConstantName like '%Flock%Start%Week%'
	
select @EndWeekNumber = isnull(ConstantValue,80)
from SystemConstant
where ConstantName like '%Flock%End%Week%'


select 
	@FarmID = pfp.FarmID
	, @ContractTypeID = ContractTypeID
	, @PulletQtyAt16Weeks = PulletQtyAt16Weeks
	, @HatchDate = coalesce(ActualHatchDate, PlannedHatchDate)
	, @FlockStartDate = coalesce(ActualStartDate, Actual24WeekDate, PlannedStartDate, Planned24WeekDate)
	, @FlockEndDate = coalesce(ActualEndDate, Actual65WeekDate, PlannedEndDate, Planned65WeekDate)
	, @ConservativeFactor = coalesce(pfp.ConservativeFactor, f.ConservativeFactor)
	, @PlannedOrActual = case when Actual24WeekDate is null then 'P' else 'A' end
from PulletFarmPlan pfp
inner join Farm f on pfp.FarmID = f.FarmID
where PulletFarmPlanID = @PulletFarmPlanID


declare @FlockSchedule table 
(
	Date date
	, DayNumber int
	, WeekDayNumber int
	, WeekNumber int
	, WeekEndingDate date
)


declare @Weekly table 
(
	WeekNumber int
	, PulletQty int
)

insert into @FlockSchedule (Date, DayNumber, WeekDayNumber, WeekNumber)
select *
from dbo.GetFlockSchedule(@StartWeekNumber, @EndWeekNumber, @HatchDate)

insert into @Weekly (WeekNumber, PulletQty)
select WeekNumber, dbo.GetPlannedPulletQty (@FarmID, WeekNumber, @PulletQtyAt16Weeks)
from @FlockSchedule
group by WeekNumber


---- Let's make sure that the weekly schedule is right
--insert into PulletFarmPlan_WeeklySchedule (PulletFarmPlanID, WeekNumber)
--select @PulletFarmPlanID, WeekNumber
--from @FlockSchedule fs
--where not exists (select 1 from PulletFarmPlan_WeeklySchedule where PulletFarmPlanID = @PulletFarmPlanID and WeekNumber = fs.WeekNumber)
--group by WeekNumber

---- did any rows get added?
--if @@ROWCOUNT > 0
--	select @RerunCalculations = 1

--update ws set ws.WeekEndingDate = fs.WeekEndingDate
--from @FlockSchedule fs
--inner join PulletFarmPlan_WeeklySchedule ws on fs.WeekNumber = ws.WeekNumber
--where ws.PulletFarmPlanID = @PulletFarmPlanID


-- Nows lets check the details
-- Do we have details?
insert into PulletFarmPlanDetail (PulletFarmPlanID, Date, DayNumber, WeekNumber, DayOfWeekNumber)
select 
	@PulletFarmPlanID
	, fs.Date
	, fs.DayNumber
	, fs.WeekNumber
	, fs.WeekDayNumber
from @FlockSchedule fs
--inner join PulletFarmPlan_WeeklySchedule ws on ws.WeekNumber = fs.WeekNumber
where not exists
(
	select 1 
	from PulletFarmPlanDetail 
	where PulletFarmPlanID = @PulletFarmPlanID
	and DayNumber = fs.DayNumber
)

-- did any rows get added?
if @@ROWCOUNT > 0
	select @RerunCalculations = 1

-- ok, we have them, make sure that they are correct!
update pfpd set 
	pfpd.Date = fs.Date
	, pfpd.WeekNumber = fs.WeekNumber
	, pfpd.DayOfWeekNumber = fs.WeekDayNumber
from PulletFarmPlanDetail pfpd
inner join @FlockSchedule fs on pfpd.DayNumber = fs.DayNumber
where PulletFarmPlanID = @PulletFarmPlanID


-- Now that the dates are updated based on week number and day number, did the pullet qty change?
-- If it did, the calculations need to be redone!
-- If the pullet qty did not change, then the calculations are correct!

if @RerunCalculations = 1
begin
	-- Now it is just updates!
	--declare @Calculations table (PulletFarmPlan_WeeklyScheduleID int, WeekEndingDate date, WeekNumber int, CalcTotalEggsPerDay int,
	--CalcFloorEggsPerDay int, CalcCommercialEggsPerDay int, CalcSettableEggsPerDay int, CalcSellableEggsPerDay int, 
	--CalcEggWeightClassificationID int)

	declare @Calculations table (WeekNumber int, CalcTotalEggsPerDay int, CalcFloorEggsPerDay int, CalcCommercialEggsPerDay int, CalcSettableEggsPerDay int, CalcSellableEggsPerDay int, 
	CalcEggWeightClassificationID int, PulletQty int)

	insert into @Calculations (WeekNumber, CalcTotalEggsPerDay, CalcFloorEggsPerDay,CalcCommercialEggsPerDay, CalcSettableEggsPerDay, CalcSellableEggsPerDay, CalcEggWeightClassificationID, PulletQty)
	select 
	WeekNumber
	, Calcs.CalcTotalEggsPerDay
	, Calcs.CalcFloorEggsPerDay
	, Calcs.CalcCommercialEggsPerDay
	, Calcs.CalcSettableEggsPerDay
	, Calcs.CalcSellableEggsPerDay
	, CalcEggWeightClassificationID = Calcs.EggWeightClassificationID
	, w.PulletQty
	from @Weekly w
	cross apply dbo.GetPulletFarmCalculations (@FarmID, WeekNumber, null, @PulletQtyAt16Weeks, @ConservativeFactor) as Calcs
	OPTION (MAXRECURSION 32747)

	update pfpd set 
		pfpd.CalcPulletQty = c.PulletQty
		, pfpd.CalcTotalEggs = c.CalcTotalEggsPerDay
		, pfpd.CalcTotalFloorEggs = c.CalcFloorEggsPerDay
		, pfpd.CalcCommercialEggs = c.CalcCommercialEggsPerDay
		, pfpd.CalcSettableEggs = c.CalcSettableEggsPerDay
		, pfpd.CalcSellableEggs = c.CalcSellableEggsPerDay
		, pfpd.CalcEggWeightClassificationID = c.CalcEggWeightClassificationID
	from PulletFarmPlanDetail pfpd
	inner join @Calculations c on pfpd.WeekNumber = c.WeekNumber
	where pfpd.PulletFarmPlanID = @PulletFarmPlanID
end


---- Now, go back and update the weekly numbers (for reporting)
--update ws set ws.DayCount = (select count(*) from PulletFarmPlanDetail where PulletFarmPlanID = @PulletFarmPlanID and WeekNumber = ws.WeekNumber)
--from PulletFarmPlan_WeeklySchedule ws
--where PulletFarmPlanID = @PulletFarmPlanID



GO
