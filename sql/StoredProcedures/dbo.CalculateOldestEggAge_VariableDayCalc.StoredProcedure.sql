USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CalculateOldestEggAge_VariableDayCalc]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CalculateOldestEggAge_VariableDayCalc]
GO
/****** Object:  StoredProcedure [dbo].[CalculateOldestEggAge_VariableDayCalc]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CalculateOldestEggAge_VariableDayCalc]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CalculateOldestEggAge_VariableDayCalc] AS' 
END
GO


ALTER proc [dbo].[CalculateOldestEggAge_VariableDayCalc]
	@MaxDaysToGoBack int,
	@EggAgeParams EggAgeParams READONLY
as 
begin
	set nocount on

	declare @EggAge TABLE 
	(
		RowNumber int,
		SetDate date,
		CasesSet numeric(6,2) default 0, 
		CasesInCooler numeric(10,1),
		OldestEggAge int, 
		CasesOfOldestEggAge numeric(10,1)
	)

	
	declare @Date date
		, @MaxDate date
		, @GoBackXDays int
		, @CalcGoBackDays int
		, @CasesToDate date
		, @CasesToDate_text varchar(10)
		, @CoolerDate date
		, @CoolerDate_text varchar(10)
		, @CasesFromDate date
		, @CasesFromDate_text varchar(10)
		, @CasesInCooler_XDaysAgo numeric(10,1)
		, @CasesSet_SumXDays numeric(10,1)
		, @OldestEggAge int

	insert into @EggAge (RowNumber, SetDate, CasesSet, CasesInCooler)
	select RowNumber, SetDate, CasesSet, CasesInCooler
	from @EggAgeParams

	update @EggAge set CasesSet = 0 where CasesSet is null
	--update @EggAge set CasesOfOldestEggAge = 0 where CasesOfOldestEggAge is null
	Update @EggAge set OldestEggAge = 0

	select @Date = min(SetDate), @MaxDate = max(SetDate) 
	from @EggAge

	while @Date <= @MaxDate
	begin
		-- the @GoBackXDays should be a max of 10, but if the cooler was zero in the past 10 days, 
		-- the @GoBackXDays should be the number of days before the current day that the cooler was zero!
		select @GoBackXDays = @MaxDaysToGoBack

		select @CalcGoBackDays  = 0
		while @CalcGoBackDays < @MaxDaysToGoBack
		begin
			select @CalcGoBackDays = @CalcGoBackDays + 1
			if exists (select 1 from @EggAge where setDate = dateadd(day, -1 * @CalcGoBackDays, @Date) and isnull(CasesInCooler,0) <= 0)
			begin
				select @GoBackXDays = @CalcGoBackDays
				select @CalcGoBackDays = @MaxDaysToGoBack + 1
			end
		end

		print 'For ' + convert(varchar(10), @Date, 101) + ' going back ' + convert(varchar(2), @GoBackXDays) + ' days'

		select @CasesToDate = dateadd(day, -1, @Date)
		select @CasesToDate_text = convert(varchar(10), @CasesToDate, 101)

		while @GoBackXDays > 0
		begin
			select @CoolerDate = dateadd(day, -1 * @GoBackXDays, @Date)
			select @CoolerDate_text = convert(varchar(10), @CoolerDate,101)

			select @CasesFromDate = dateadd(day, 1, @CoolerDate)
			select @CasesFromDate_text = convert(varchar(10), @CasesFromDate, 101)
			
			select @CasesInCooler_XDaysAgo = isnull(CasesInCooler,0)
			from @EggAge
			where SetDate = @CoolerDate

			select @CasesSet_SumXDays = isnull(sum(CasesSet),0)
			from @EggAge
			where SetDate between @CasesFromDate and @CasesToDate

			print 'Day ' + convert(varchar(10), @GoBackXDays)
			print '   Cases in cooler on ' + @CoolerDate_text  + ' -> ' + convert(varchar(10), @CasesInCooler_XDaysAgo)
			print '   Cases set from ' + @CasesFromDate_text + ' and ' + @CasesToDate_text  + ' -> ' + convert(varchar(10), @CasesSet_SumXDays)


			if @CasesInCooler_XDaysAgo > @CasesSet_SumXDays
			begin
				select @OldestEggAge = @GoBackXDays
				select @GoBackXDays = 0
			end
			else
			begin
				select @GoBackXDays = @GoBackXDays - 1			
				select @OldestEggAge = @GoBackXDays
			end

			if @GoBackXDays = 0 
			begin
				--update TestData set OldestEggAge = @OldestEggAge, CasesOfOldestEggAge = @CasesInCooler_XDaysAgo - @CasesSet_SumXDays
				--where SetDate = @Date

				update @EggAge set OldestEggAge = @OldestEggAge
				where SetDate = @Date

				--update @EggAge set CasesOfOldestEggAge =
				--case
				--	when @CasesInCooler_XDaysAgo - @CasesSet_SumXDays > 0 then @CasesInCooler_XDaysAgo - @CasesSet_SumXDays
				--	else 0
				--end
				--where SetDate = dateadd(day, -1, @Date)
			end
		end

		select @Date = dateadd(day,1,@Date)

	end

	select RowNumber, OldestEggAge, CasesOfOldestEggAge
	from @EggAge
	order by RowNumber
end


GO
