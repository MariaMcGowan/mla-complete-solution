USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDateRange]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetDateRange]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDateRange]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDateRange]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[GetDateRange] (@StartDate date, @EndDate date)
RETURNS 
@DateRange TABLE 
(
	-- Add the column definitions for the TABLE variable here
	Date Date
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

	insert into @DateRange (Date)
	SELECT Date
	FROM DateSequence
	OPTION (MAXRECURSION 32747)

	RETURN 

END

' 
END

GO
