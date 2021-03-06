USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OldAge_Calculations]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OldAge_Calculations]
GO
/****** Object:  StoredProcedure [dbo].[OldAge_Calculations]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OldAge_Calculations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OldAge_Calculations] AS' 
END
GO
ALTER proc [dbo].[OldAge_Calculations] (@SetDate date, @GoBackXDays int, @WorkID int)
as
begin
	declare 
		  @EvaluateDayCount int = @GoBackXDays
		, @Exit bit = 0
		, @CasesInCooler numeric(12,4)
		, @CasesSet numeric(12,4)
		, @RowNumber int

	--select @RowNumber = RowNumber
	--from WorkData
	--where WorkID = @WorkID
	--	and StandardTemplateData = 1
	--	and setDate = @SetDate	
	--order by RowNumber

	print convert(varchar(10), @SetDate, 101) + ' max go back ' + convert(varchar(2), @GoBackXDays) + ' days'

	if @GoBackXDays = 1
	begin
		select @EvaluateDayCount = 0
	end

	while @EvaluateDayCount >= 1 and @Exit = 0
	begin
		-- Have to compensate for the odd math when the day count gets down to 1
		select top 1 @CasesInCooler = isnull(CasesInCooler,0)
		from WorkData
		where WorkID = @WorkID 
			--and StandardTemplateData = 1
			and SetDate = dateadd(day, -1 * @EvaluateDayCount, @SetDate)
		order by DeliveryDate desc


		if @EvaluateDayCount > 1
		begin
			select @CasesSet = sum(isnull(CasesSet, 0))
			from WorkData
			where WorkID = @WorkID 
				--and StandardTemplateData = 1
				and SetDate between dateadd(day, -1 * (@EvaluateDayCount - 1),@SetDate) and dateadd(day, -1, @SetDate)
		end
		else
		begin
			select @CasesSet = sum(isnull(CasesSet, 0))
			from WorkData
			where WorkID = @WorkID 
				and SetDate =  dateadd(day, -1, @SetDate)
		end

		if isnull(@CasesInCooler,0) > isnull(@CasesSet,0)
		begin
			print 'BINGO ' + convert(varchar(10),@EvaluateDayCount)
			print 'Cases in cooler on ' + convert(varchar(10),  dateadd(day, -1 * @EvaluateDayCount, @SetDate), 101) + ' = ' + convert(varchar(100), @CasesInCooler)
			print 'Cases set from ' +  convert(varchar(10), dateadd(day, -1 * (@EvaluateDayCount - 1),@SetDate), 101) + ' through ' + convert(varchar(10), dateadd(day, -1, @SetDate), 101) + ' = ' + convert(varchar(100), @CasesSet)
			select @Exit = 1
		end
		else
		begin
			print 'Checking ' + convert(varchar(10),@EvaluateDayCount)
			print 'Cases in cooler on ' + convert(varchar(10),  dateadd(day, -1 * @EvaluateDayCount, @SetDate), 101) + ' = ' + convert(varchar(100), @CasesInCooler)
			print 'Cases set from ' +  convert(varchar(10), dateadd(day, -1 * (@EvaluateDayCount - 1),@SetDate), 101) + ' through ' + convert(varchar(10), dateadd(day, -1, @SetDate), 101)+ ' = ' + convert(varchar(10), @CasesSet)
			select @EvaluateDayCount = @EvaluateDayCount - 1
		end
	end

	if @EvaluateDayCount = 0
	begin
		print 'Hit the lower limit'

		select @CasesInCooler = CalcSettableEggs_Cases
			, @CasesSet = 0
		from WorkData
		where WorkID = @WorkID and SetDate = @SetDate
		print 'Cases in cooler on ' + convert(varchar(10),  @SetDate, 101) + ' = ' + convert(varchar(100), @CasesInCooler)
	end

	update WorkData 
		set OldestEggAge = @EvaluateDayCount
			, CasesOldestEggAge = 
				case
					when @CasesInCooler - @CasesSet < 0 then 0
					else @CasesInCooler - @CasesSet
				end
	where WorkID = @WorkID
		and StandardTemplateData = 1
		and setDate = @SetDate	


end

GO
