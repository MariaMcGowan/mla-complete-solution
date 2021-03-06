USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetFlockSchedule]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetFlockSchedule]
GO
/****** Object:  UserDefinedFunction [dbo].[GetFlockSchedule]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFlockSchedule]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[GetFlockSchedule] (
	@StartingWeekNumber int
	, @EndingWeekNumber int
	, @HatchDate date
	)
RETURNS 
@ReturnSchedule TABLE 
(
	Date date
	, DayNumber int
	, WeekDayNumber int
	, WeekNumber int
)
AS
begin
	declare
		@DayStart int 
		, @DayEnd int 
		, @StartDate date

	select @DayStart = (@StartingWeekNumber * 7) + 1
		, @DayEnd = ((@EndingWeekNumber + 1) * 7)-1
		-- @HatchDate = Week 0, Day 1
		, @StartDate = dateadd(week,@StartingWeekNumber,@HatchDate)

	;With DailyDateSequence (Date, DayNumber, WeekDayNumber, WeekNumber) as
	(
		Select @StartDate as Date, @DayStart as DayNumber, datepart(dw, @StartDate), @StartingWeekNumber

		union all

		Select dateadd(dd, 1, Date), DayNumber + 1, datepart(dw,dateadd(dd, 1, Date)),
		WeekNumber = 
			case
				when DayNumber % 7 = 0 then WeekNumber + 1
				else WeekNumber
			end
		
		from DailyDateSequence
		where DayNumber <= @DayEnd
	)
	
	insert into @ReturnSchedule (Date, DayNumber, WeekDayNumber, WeekNumber)
	select Date, DayNumber, WeekDayNumber, WeekNumber
	from DailyDateSequence
	OPTION (MAXRECURSION 32747)

	return
end' 
END

GO
