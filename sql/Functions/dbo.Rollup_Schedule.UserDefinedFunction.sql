USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[Rollup_Schedule]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[Rollup_Schedule]
GO
/****** Object:  UserDefinedFunction [dbo].[Rollup_Schedule]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Rollup_Schedule]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[Rollup_Schedule]
(
	-- Add the parameters for the function here
	@ContractID int
)
RETURNS 
@ContractSchedule TABLE 
(
	-- Add the column definitions for the TABLE variable here
	ContractID int, 
	StartDate date, 
	EndDate date,
	Volume bigint
)
AS
BEGIN

	-- Fill the table variable with the rows for your result set
	declare @MinDate date
	declare @Volume int
	declare @StartDate date
	declare @EndDate date
	declare @OutOfRangeEndDate date
	declare @OutOfRangeEndDate_Sat date
	declare @CountGroupsLeft int

	declare @WorkingTable TABLE (WeekEndingDate date, Volume int)

	select @StartDate = min(WeekEndingDate), @EndDate = max(WeekEndingDate) 
	from ContractVolume
	where ContractID = @ContractID

	;With DateSequence( Date ) as
	(
		Select @StartDate as Date
			union all
		Select dateadd(wk, 1, Date)
			from DateSequence
			where Date < @EndDate
	)



	insert into @WorkingTable (WeekEndingDate, Volume)
	select Date,0
	from DateSequence
	OPTION (MAXRECURSION 32747)

	update w set w.Volume = cv.Volume
	from @WorkingTable w
	inner join ContractVolume cv on w.WeekEndingDate = cv.WeekEndingDate
	where ContractID = @ContractID


	while exists (select 1 from @WorkingTable)
	begin
		select @MinDate = min(WeekEndingDate) from @WorkingTable
		select @Volume = Volume from @WorkingTable where WeekEndingDate = @MinDate

		select top 1 @OutOfRangeEndDate = WeekEndingDate from @WorkingTable where WeekEndingDate > @MinDate and Volume <> @Volume order by WeekEndingDate 

		-- Make sure that the Out Of Range End Date is a Saturday!
		select @OutOfRangeEndDate_Sat = 
		case
			when datepart(dw,@OutOfRangeEndDate) = 7 then @OutOfRangeEndDate
			when datepart(dw,@OutOfRangeEndDate) = 1 then dateadd(dd,-1,@OutOfRangeEndDate)
			when datepart(dw,@OutOfRangeEndDate) = 2 then dateadd(dd,-2,@OutOfRangeEndDate)
			when datepart(dw,@OutOfRangeEndDate) = 3 then dateadd(dd,-3,@OutOfRangeEndDate)
			when datepart(dw,@OutOfRangeEndDate) = 4 then dateadd(dd,-4,@OutOfRangeEndDate)
			when datepart(dw,@OutOfRangeEndDate) = 5 then dateadd(dd,-5,@OutOfRangeEndDate)
			when datepart(dw,@OutOfRangeEndDate) = 6 then dateadd(dd,-6,@OutOfRangeEndDate)
		end

		-- Make sure that the start date is a Sunday!
		select @StartDate =
				dateadd(dd,-7, 
							case
								when datepart(dw,@MinDate) = 1 then @MinDate
								when datepart(dw,@MinDate) = 2 then dateadd(dd,6,@MinDate)
								when datepart(dw,@MinDate) = 3 then dateadd(dd,5,@MinDate)
								when datepart(dw,@MinDate) = 4 then dateadd(dd,4,@MinDate)
								when datepart(dw,@MinDate) = 5 then dateadd(dd,3,@MinDate)
								when datepart(dw,@MinDate) = 6 then dateadd(dd,2,@MinDate)
								when datepart(dw,@MinDate) = 7 then dateadd(dd,1,@MinDate)
							end)


		select @EndDate = dateadd(dd, -7, @OutOfRangeEndDate_Sat)

		--select
		--	datepart(dw, @MinDate) as DatePart_MinDate,
		--	@MinDate as MinDate, 
		--	datepart(dw,@OutOfRangeEndDate) as DatePart_OutOfRangeDate,
		--	@OutOfRangeEndDate as OutOfRangeDate, 
		--	@OutOfRangeEndDate_Sat as OutOfRangeDate_Sat, 
		--	@StartDate as StartDate, 
		--	@EndDate as EndDate,
		--	@Volume as Volume

		insert into @ContractSchedule(ContractID, StartDate, EndDate, Volume)
		select @ContractID, 
			@StartDate, 
			@EndDate,
			@Volume

		delete from @WorkingTable where WeekEndingDate < @OutOfRangeEndDate

		select @CountGroupsLeft = count(distinct Volume) from @WorkingTable

		if @CountGroupsLeft = 1
		begin
			-- the start date is actually 1 + last end date!
			select @StartDate = dateadd(dd,1, @EndDate)
			
			-- redefine end date
			select @EndDate = max(WeekEndingDate) from @WorkingTable
			select @Volume = Volume from @WorkingTable where WeekEndingDate = @EndDate

			-- Make sure that the End Date is a Saturday!
			select @EndDate = 
			case
				when datepart(dw,@EndDate) = 7 then @EndDate
				when datepart(dw,@EndDate) = 1 then dateadd(dd,-1,@EndDate)
				when datepart(dw,@EndDate) = 2 then dateadd(dd,-2,@EndDate)
				when datepart(dw,@EndDate) = 3 then dateadd(dd,-3,@EndDate)
				when datepart(dw,@EndDate) = 4 then dateadd(dd,-4,@EndDate)
				when datepart(dw,@EndDate) = 5 then dateadd(dd,-5,@EndDate)
				when datepart(dw,@EndDate) = 6 then dateadd(dd,-6,@EndDate)
			end

			--select ''Last One'' as Info, @OutOfRangeEndDate as OutOfRangeDate, 
			--@OutOfRangeEndDate_Sat as OutOfRangeDate_Sat, 
			--@StartDate as StartDate, 
			--@EndDate as EndDate,
			--@Volume as Volume

			insert into @ContractSchedule(ContractID, StartDate, EndDate, Volume)
			select @ContractID, @StartDate, @EndDate, @Volume

			delete from @WorkingTable
		end	
	end

Return

end' 
END

GO
