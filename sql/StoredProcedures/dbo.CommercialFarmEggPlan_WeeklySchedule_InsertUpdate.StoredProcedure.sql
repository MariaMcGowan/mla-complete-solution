USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialFarmEggPlan_WeeklySchedule_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialFarmEggPlan_WeeklySchedule_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[CommercialFarmEggPlan_WeeklySchedule_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialFarmEggPlan_WeeklySchedule_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialFarmEggPlan_WeeklySchedule_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[CommercialFarmEggPlan_WeeklySchedule_InsertUpdate] @CommercialFarmEggPlanID int 
as

--declare @CommercialFarmEggPlanID int = 1


declare @PulletFarmPlanID int,
	@PulletQtyAt16Weeks int,
	@FarmID int,
	@HatchDate date,
	@StartDate date,
	@EndDate date,
	@WeekNumber int = 16

select @PulletFarmPlanID = PulletFarmPlanID 
from CommercialFarmEggPlan
where CommercialFarmEggPlanID = @CommercialFarmEggPlanID


select @PulletQtyAt16Weeks = PulletQtyAt16Weeks, @FarmID = pfp.FarmID, 
@HatchDate =
	case
		when pff.ActualHatchDate is null then pfp.PlannedHatchDate
		when pfp.ModifiedAfterOrderConfirm = 1 then pfp.PlannedHatchDate	-- even though we have order confirmed info, it is outdated!
		else coalesce(pfp.ActualHatchDate, pfp.PlannedHatchDate)
	end
from PulletFarmPlan pfp
inner join dbo.PulletFacilityFlock pff on pfp.PulletFarmPlanID = pff.PulletFarmPlanID
where pfp.PulletFarmPlanID = @PulletFarmPlanID

-- is there any information for the commercial farm egg plan id in 
-- CommercialFarmEggPlan_WeeklySchedule table
-- if so, delete it and readd it!
delete from CommercialFarmEggPlan_WeeklySchedule
where CommercialFarmEggPlanID = @CommercialFarmEggPlanID


-- Confirm that @StartDate is a Saturday
select @StartDate = dateadd(week,15,@HatchDate)

if datepart(dw,@StartDate) <> 7
begin
	-- Jump to the first saturday after the start date
	select @StartDate = dateadd(dd, 7 - datepart(dw,@StartDate),@StartDate)
	---- Jump to the first saturday before the start date
	--select @Planned24WeekDate = dateadd(wk,-1,@Planned24WeekDate)
end

select @EndDate = dateadd(week,60,@StartDate)
;With DateSequence( Date, WeekNumber ) as
(
	Select @StartDate as Date, @WeekNumber as WeekNumber
		union all
	Select dateadd(wk, 1, Date), WeekNumber + 1
		from DateSequence
		where Date < @EndDate
)


insert into CommercialFarmEggPlan_WeeklySchedule (CommercialFarmEggPlanID, WeekNumber, PlannedCalcCommercialEggsPerDay, PlannedCalcSettableEggsPerDay, 
PlannedCalcTotalCommercialEggsPerDay, IncludeSettableEggs, EggWeightClassificationID, PlannedWeekEndingDate)
select @CommercialFarmEggPlanID, ds.WeekNumber, c.CalcCommercialEggsPerDay, c.CalcSettableEggsPerDay, 
case
	when c.EggWeightClassificationID <= 2 then isnull(c.CalcCommercialEggsPerDay,0) + isnull(c.CalcSettableEggsPerDay,0)
	else isnull(c.CalcCommercialEggsPerDay,0)
end, 
case
	when c.EggWeightClassificationID <= 2 then 1
	else 0
end,
c.EggWeightClassificationID, Date
from DateSequence ds
inner join dbo.GetCommercialEggCalculations (@FarmID, @PulletQtyAt16Weeks) c
on ds.WeekNumber = c.WeekNumber



GO
