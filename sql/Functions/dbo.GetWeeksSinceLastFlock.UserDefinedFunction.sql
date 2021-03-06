USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetWeeksSinceLastFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetWeeksSinceLastFlock]
GO
/****** Object:  UserDefinedFunction [dbo].[GetWeeksSinceLastFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetWeeksSinceLastFlock]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create FUNCTION [dbo].[GetWeeksSinceLastFlock]
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

	-- Reset @StartDate
	select top 1 @StartDate = 
					case
						when ActualHatchDate is null then Planned24WeekDate
						else Actual24WeekDate
					end
	from PulletFarmPlan
	where FarmID = @FarmID

	;With DateSequence( Date ) as
	(
		Select @StartDate as Date
			union all
		Select dateadd(wk, 1, Date)
			from DateSequence
			--where Date < @EndDate
			where Date < dateadd(week,65,@EndDate)
	),
	BlankDates (a_PulletFarmPlanID, FirstDaySinceLastFlock, LastDaySinceLastFlock) as 
	(
		select a.PulletFarmPlanID, Dateadd(day,1,b.EndDate) as FirstDaySinceLastFlock,
		dateadd(day,-1, a.StartDate) as LastDaySinceLastFlock
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
				ROW_NUMBER() over (order by coalesce(Actual24WeekDate, Planned24WeekDate) desc) as PulletFarmPlanOrder
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
				ROW_NUMBER() over (order by coalesce(Actual24WeekDate, Planned24WeekDate) desc) as PulletFarmPlanOrder
			from PulletFarmPlan
			where FarmID = @FarmID
		) b
		on a.PulletFarmPlanOrder + 1  = b.PulletFarmPlanOrder 
		union all
		-- Add record to capture the info after the last flock
		select top 1 
		a_PulletFarmPlanID = -1, 
		FirstDaySinceLastFlock = 
			dateadd(day,-1,
					case
						when ActualHatchDate is null then coalesce(PlannedEndDate, Planned65WeekDate)
						else coalesce(ActualEndDate, Actual65WeekDate)
					end),
		LastDaySinceLastFlock = ''01/01/9999''
		from PulletFarmPlan
		where FarmID = @FarmID
		order by Planned24WeekDate desc
	)

	insert into @Values (WeekEndingDate, Weeks)
	select Date, WeeksSinceLastFlock = row_number () over (partition by a_PulletFarmPlanID order by date asc) 
	from DateSequence ds
	inner join BlankDates bd on ds.Date between bd.FirstDaySinceLastFlock and bd.LastDaySinceLastFlock
	where Date between @StartDate and @EndDate
	order by date
	OPTION (MAXRECURSION 32747)


	return 
END

' 
END

GO
