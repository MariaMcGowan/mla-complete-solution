USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetWeeksBeforeNextFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetWeeksBeforeNextFlock]
GO
/****** Object:  UserDefinedFunction [dbo].[GetWeeksBeforeNextFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetWeeksBeforeNextFlock]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create FUNCTION [dbo].[GetWeeksBeforeNextFlock]
(
	-- Add the parameters for the function here
	@StartDate date,
	@EndDate date,
	@FarmID int
)
RETURNS 
@Values TABLE 
(
	-- Add the column definitions for the TABLE variable here
	WeekEndingDate date,
	Weeks int
)
AS
BEGIN
	-- Update the blank week number
		;With DateSequence( Date ) as
		(
			Select @StartDate as Date
				union all
			Select dateadd(wk, 1, Date)
				from DateSequence
				where Date < dateadd(week,65,@EndDate)
		),
		BlankDates (FarmID, PulletFarmPlanID, NextPulletFarmPlanID, BlankStartDate, BlankEndDate) as 
		(
			select @FarmID, a.PulletFarmPlanID, b.PulletFarmPlanID, dateadd(day,1,a.EndDate) as BlankStartDate,
			dateadd(day,-1, isnull(b.StartDate, ''12/31/9999'')) as BlankEndDate
			from 
			(
				select 
					PulletFarmPlanID, 
					StartDate = 
						case
							when ActualHatchDate is null then Planned24WeekDate
							else Actual24WeekDate
						end,
					EndDate = 
						case
							when ActualHatchDate is null then coalesce(PlannedEndDate, Planned65WeekDate)
							else coalesce(ActualEndDate, Actual65WeekDate)
						end,
					ROW_NUMBER() over (order by coalesce(Actual24WeekDate, Planned24WeekDate)) as PulletFarmPlanOrder
				from PulletFarmPlan
				where FarmID = @FarmID
			) a
			left outer join 
			(
				select 
					PulletFarmPlanID, 
					StartDate = 
						case
							when ActualHatchDate is null then Planned24WeekDate
							else Actual24WeekDate
						end,
					EndDate = 
						case
							when ActualHatchDate is null then coalesce(PlannedEndDate, Planned65WeekDate)
							else coalesce(ActualEndDate, Actual65WeekDate)
						end,
					ROW_NUMBER() over (order by coalesce(Actual24WeekDate, Planned24WeekDate)) as PulletFarmPlanOrder
				from PulletFarmPlan
				where FarmID = @FarmID
			) b
			on a.PulletFarmPlanOrder = b.PulletFarmPlanOrder - 1 and b.PulletFarmPlanOrder > 1
		)

		insert into @Values(WeekEndingDate, Weeks)
		select Date, WeeksBeforeNextFlock = row_number () over (partition by PulletFarmPlanID order by date desc)
		from DateSequence ds
		inner join BlankDates bd on ds.Date between bd.BlankStartDate and bd.BlankEndDate
		order by date
		OPTION (MAXRECURSION 32747)
	return 
END

' 
END

GO
