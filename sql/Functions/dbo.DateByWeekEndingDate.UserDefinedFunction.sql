USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[DateByWeekEndingDate]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[DateByWeekEndingDate]
GO
/****** Object:  UserDefinedFunction [dbo].[DateByWeekEndingDate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DateByWeekEndingDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create FUNCTION [dbo].[DateByWeekEndingDate] (@StartDate date, @EndDate date)
RETURNS 
@DateByWeekEndingDate TABLE 
(
	-- Add the column definitions for the TABLE variable here
	Date Date, 
	WeekEndingDate date
)
AS
BEGIN
	;With DateSequence( Date ) as
	(
		Select @StartDate as Date
			union all
		Select dateadd(day, 1, Date)
			from DateSequence
			where Date < @EndDate
	)

	insert into @DateByWeekEndingDate (WeekEndingDate, Date)
	SELECT DATEADD(DAY, + 5 - DATEDIFF(DAY, 0, Date) % 7, Date) AS [WeekEndingDate],Date
	FROM DateSequence
	OPTION (MAXRECURSION 32747)

	RETURN 

END
' 
END

GO
