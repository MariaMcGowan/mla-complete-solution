USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[Detail_Schedule]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[Detail_Schedule]
GO
/****** Object:  UserDefinedFunction [dbo].[Detail_Schedule]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Detail_Schedule]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create FUNCTION [dbo].[Detail_Schedule]
(
	-- Add the parameters for the function here
	@Weekly bit, @StartDate  date, @EndDate date, @Volume int
)
RETURNS 
@DetailContractSchedule TABLE 
(
	-- Add the column definitions for the TABLE variable here
	EndDate date, 
	Volume bigint
)
AS
BEGIN
	
--	declare @DetailContractSchedule TABLE 
--(
--	-- Add the column definitions for the TABLE variable here
--	EndDate date, 
--	Volume bigint
--)

--declare @Weekly bit, @StartDate  date, @EndDate date, @Volume int
--select @Weekly = 1, @StartDate = ''07/01/2018'', @EndDate = ''08/04/2018'', @Volume = 1600

	declare @CalcEndDate date 
	declare @DayCount int
	declare @WorkStartDate date
	declare @WorkEndDate date



	select @WorkStartDate = @StartDate

	if @Weekly = 1
	begin
		select @DayCount = 7

		-- Is the Start Date a Sunday?
		-- If it isn''t, it should be!
		if DateName(dw, @StartDate) <> ''Sunday''
		begin
		select @WorkStartDate = 
			case
				when datepart(dw,@StartDate) = 2 then dateadd(dd, -1, @StartDate)
				when datepart(dw,@StartDate) = 3 then dateadd(dd, -2, @StartDate)
				when datepart(dw,@StartDate) = 4 then dateadd(dd, -3, @StartDate)
				when datepart(dw,@StartDate) = 5 then dateadd(dd, -4, @StartDate)
				when datepart(dw,@StartDate) = 6 then dateadd(dd, -5, @StartDate)
				when datepart(dw,@StartDate) = 7 then dateadd(dd, -6, @StartDate)
			end
		end
	end
	else
	begin
		select @DayCount = 1
	end

	--select @WorkStartDate as WorkStartDate

	select @WorkEndDate = dateadd(dd,@DayCount-1,@WorkStartDate)

	while @WorkEndDate <= @EndDate
	begin
		insert into @DetailContractSchedule (EndDate, Volume)
		select @WorkEndDate, @Volume

		select @WorkEndDate = dateadd(dd,@DayCount,@WorkEndDate)
	end

	--insert into @DetailContractSchedule (EndDate, Volume)
	--select @WorkEndDate, @Volume

	--select * from @DetailContractSchedule
	
	RETURN 

END
' 
END

GO
