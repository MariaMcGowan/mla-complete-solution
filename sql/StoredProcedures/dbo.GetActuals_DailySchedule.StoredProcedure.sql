USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[GetActuals_DailySchedule]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetActuals_DailySchedule]
GO
/****** Object:  StoredProcedure [dbo].[GetActuals_DailySchedule]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetActuals_DailySchedule]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetActuals_DailySchedule] AS' 
END
GO



ALTER proc [dbo].[GetActuals_DailySchedule] @StartDate date, @EndDate date, @FieldNameForQty varchar(20)
as
	------------------------------------------------------------------------------------
	--	@FieldNameForQty must be a quanity field name in the PulletFarmPlanDetail 
	--	for example:
	--			ActualPulletQty
	--			ActualTotalEggs
	--			ActualFloorEggs
	--			ActualCommercialEggs
	--			ActualSettableEggs
	--			ActualSellableEggs
	------------------------------------------------------------------------------------

	declare @FarmID int
	declare @FarmColor varchar(10)
	declare @sql varchar(4000)
	declare @LoopCounter int = 0
	declare @FarmCol int = 0

	create table #Data
	(
		Date date, 
		TotalQty int,
		TotalContractVolume int,
		--TargetEggs int,
		-- Note - Qty stands for the actual total eggs
		FarmColumn01_Qty int, FarmColumn01_FarmID int, FarmColumn01_Visible bit DEFAULT 0, FarmColumn01_Color varchar(10), FarmColumn01_PulletFarmPlanDetailID int, FarmColumn01_CellStyle varchar(50),
		FarmColumn02_Qty int, FarmColumn02_FarmID int, FarmColumn02_Visible bit DEFAULT 0, FarmColumn02_Color varchar(10), FarmColumn02_PulletFarmPlanDetailID int, FarmColumn02_CellStyle varchar(50),
		FarmColumn03_Qty int, FarmColumn03_FarmID int, FarmColumn03_Visible bit DEFAULT 0, FarmColumn03_Color varchar(10), FarmColumn03_PulletFarmPlanDetailID int, FarmColumn03_CellStyle varchar(50),
		FarmColumn04_Qty int, FarmColumn04_FarmID int, FarmColumn04_Visible bit DEFAULT 0, FarmColumn04_Color varchar(10), FarmColumn04_PulletFarmPlanDetailID int, FarmColumn04_CellStyle varchar(50),
		FarmColumn05_Qty int, FarmColumn05_FarmID int, FarmColumn05_Visible bit DEFAULT 0, FarmColumn05_Color varchar(10), FarmColumn05_PulletFarmPlanDetailID int, FarmColumn05_CellStyle varchar(50),
		FarmColumn06_Qty int, FarmColumn06_FarmID int, FarmColumn06_Visible bit DEFAULT 0, FarmColumn06_Color varchar(10), FarmColumn06_PulletFarmPlanDetailID int, FarmColumn06_CellStyle varchar(50),
		FarmColumn07_Qty int, FarmColumn07_FarmID int, FarmColumn07_Visible bit DEFAULT 0, FarmColumn07_Color varchar(10), FarmColumn07_PulletFarmPlanDetailID int, FarmColumn07_CellStyle varchar(50),
		FarmColumn08_Qty int, FarmColumn08_FarmID int, FarmColumn08_Visible bit DEFAULT 0, FarmColumn08_Color varchar(10), FarmColumn08_PulletFarmPlanDetailID int, FarmColumn08_CellStyle varchar(50),
		FarmColumn09_Qty int, FarmColumn09_FarmID int, FarmColumn09_Visible bit DEFAULT 0, FarmColumn09_Color varchar(10), FarmColumn09_PulletFarmPlanDetailID int, FarmColumn09_CellStyle varchar(50),
		FarmColumn10_Qty int, FarmColumn10_FarmID int, FarmColumn10_Visible bit DEFAULT 0, FarmColumn10_Color varchar(10), FarmColumn10_PulletFarmPlanDetailID int, FarmColumn10_CellStyle varchar(50),
		FarmColumn11_Qty int, FarmColumn11_FarmID int, FarmColumn11_Visible bit DEFAULT 0, FarmColumn11_Color varchar(10), FarmColumn11_PulletFarmPlanDetailID int, FarmColumn11_CellStyle varchar(50),
		FarmColumn12_Qty int, FarmColumn12_FarmID int, FarmColumn12_Visible bit DEFAULT 0, FarmColumn12_Color varchar(10), FarmColumn12_PulletFarmPlanDetailID int, FarmColumn12_CellStyle varchar(50),
		FarmColumn13_Qty int, FarmColumn13_FarmID int, FarmColumn13_Visible bit DEFAULT 0, FarmColumn13_Color varchar(10), FarmColumn13_PulletFarmPlanDetailID int, FarmColumn13_CellStyle varchar(50),
		FarmColumn14_Qty int, FarmColumn14_FarmID int, FarmColumn14_Visible bit DEFAULT 0, FarmColumn14_Color varchar(10), FarmColumn14_PulletFarmPlanDetailID int, FarmColumn14_CellStyle varchar(50),
		FarmColumn15_Qty int, FarmColumn15_FarmID int, FarmColumn15_Visible bit DEFAULT 0, FarmColumn15_Color varchar(10), FarmColumn15_PulletFarmPlanDetailID int, FarmColumn15_CellStyle varchar(50),
		FarmColumn16_Qty int, FarmColumn16_FarmID int, FarmColumn16_Visible bit DEFAULT 0, FarmColumn16_Color varchar(10), FarmColumn16_PulletFarmPlanDetailID int, FarmColumn16_CellStyle varchar(50),
		FarmColumn17_Qty int, FarmColumn17_FarmID int, FarmColumn17_Visible bit DEFAULT 0, FarmColumn17_Color varchar(10), FarmColumn17_PulletFarmPlanDetailID int, FarmColumn17_CellStyle varchar(50),
		FarmColumn18_Qty int, FarmColumn18_FarmID int, FarmColumn18_Visible bit DEFAULT 0, FarmColumn18_Color varchar(10), FarmColumn18_PulletFarmPlanDetailID int, FarmColumn18_CellStyle varchar(50),
		FarmColumn19_Qty int, FarmColumn19_FarmID int, FarmColumn19_Visible bit DEFAULT 0, FarmColumn19_Color varchar(10), FarmColumn19_PulletFarmPlanDetailID int, FarmColumn19_CellStyle varchar(50),
		FarmColumn20_Qty int, FarmColumn20_FarmID int, FarmColumn20_Visible bit DEFAULT 0, FarmColumn20_Color varchar(10), FarmColumn20_PulletFarmPlanDetailID int, FarmColumn20_CellStyle varchar(50),
		FarmColumn21_Qty int, FarmColumn21_FarmID int, FarmColumn21_Visible bit DEFAULT 0, FarmColumn21_Color varchar(10), FarmColumn21_PulletFarmPlanDetailID int, FarmColumn21_CellStyle varchar(50),
		FarmColumn22_Qty int, FarmColumn22_FarmID int, FarmColumn22_Visible bit DEFAULT 0, FarmColumn22_Color varchar(10), FarmColumn22_PulletFarmPlanDetailID int, FarmColumn22_CellStyle varchar(50),
		FarmColumn23_Qty int, FarmColumn23_FarmID int, FarmColumn23_Visible bit DEFAULT 0, FarmColumn23_Color varchar(10), FarmColumn23_PulletFarmPlanDetailID int, FarmColumn23_CellStyle varchar(50),
		FarmColumn24_Qty int, FarmColumn24_FarmID int, FarmColumn24_Visible bit DEFAULT 0, FarmColumn24_Color varchar(10), FarmColumn24_PulletFarmPlanDetailID int, FarmColumn24_CellStyle varchar(50),
		FarmColumn25_Qty int, FarmColumn25_FarmID int, FarmColumn25_Visible bit DEFAULT 0, FarmColumn25_Color varchar(10), FarmColumn25_PulletFarmPlanDetailID int, FarmColumn25_CellStyle varchar(50),
		FarmColumn26_Qty int, FarmColumn26_FarmID int, FarmColumn26_Visible bit DEFAULT 0, FarmColumn26_Color varchar(10), FarmColumn26_PulletFarmPlanDetailID int, FarmColumn26_CellStyle varchar(50),
		FarmColumn27_Qty int, FarmColumn27_FarmID int, FarmColumn27_Visible bit DEFAULT 0, FarmColumn27_Color varchar(10), FarmColumn27_PulletFarmPlanDetailID int, FarmColumn27_CellStyle varchar(50),
		FarmColumn28_Qty int, FarmColumn28_FarmID int, FarmColumn28_Visible bit DEFAULT 0, FarmColumn28_Color varchar(10), FarmColumn28_PulletFarmPlanDetailID int, FarmColumn28_CellStyle varchar(50),
		FarmColumn29_Qty int, FarmColumn29_FarmID int, FarmColumn29_Visible bit DEFAULT 0, FarmColumn29_Color varchar(10), FarmColumn29_PulletFarmPlanDetailID int, FarmColumn29_CellStyle varchar(50),
		FarmColumn30_Qty int, FarmColumn30_FarmID int, FarmColumn30_Visible bit DEFAULT 0, FarmColumn30_Color varchar(10), FarmColumn30_PulletFarmPlanDetailID int, FarmColumn30_CellStyle varchar(50)
	)

	declare @FarmList table (FarmColumn int, FarmID int, FarmName varchar(100), FarmNumber varchar(6))
	insert into @FarmList
	select * 
	from dbo.GetHatcheryFarmList()

	-- Confirm that @StartDate is a Saturday
	if datepart(dw,@StartDate) <> 7
	begin
		-- Jump to the first saturday after the start date
		select @StartDate = dateadd(dd, 7 - datepart(dw,@StartDate),@StartDate)
		-- Jump to the first saturday before the start date
		select @StartDate = dateadd(wk,-1,@StartDate)
	end

	;With DateSequence( Date ) as
	(
		Select @StartDate as Date
			union all
		Select dateadd(day, 1, Date)
			from DateSequence
			where Date < @EndDate
	)

	insert into #Data (Date)
	select *
	from DateSequence
	OPTION (MAXRECURSION 32747)

	----------------------------------------------------------------------------
	-- At this point, we have a table, #Data, that contains the 
	-- individual dates for the specified date range.
	-- Now let's update the counts per farm for those individual dates
	----------------------------------------------------------------------------

	while @LoopCounter < 30
	begin
		select @LoopCounter = @LoopCounter + 1
		select @FarmCol = @LoopCounter - 1

		select @FarmID = null

		select @FarmID = FarmID from @FarmList where FarmColumn = @FarmCol
		select @FarmColor = isnull(PlanningColor, 'White')
		from Farm f
		left outer join PlanningColor pc on f.PlanningColorID = pc.PlanningColorID
		where FarmID = @FarmID

		if @FarmID is not null
		begin
			select @SQL = 
			'update e set 
			e.FarmColumn{NN}_Color = ''@FarmColor'',
			e.FarmColumn{NN}_Qty = d.' + @FieldNameForQty + ', 
			e.FarmColumn{NN}_PulletFarmPlanDetailID = d.PulletFarmPlanDetailID,
			e.FarmColumn{NN}_FarmID = @FarmID
			--e.SourceType = d.SourceType
			from #Data e
			inner join 
				(
					select 
						p.Date, 
						p.ActualPulletQty, 
						p.ActualTotalEggs, 
						p.ActualFloorEggs, 
						p.ActualCommercialEggs,
						p.ActualSettableEggs, 
						p.ActualSellableEggs,
						p.PulletFarmPlanDetailID
					from PulletFarmPlanDetail p
					inner join PulletFarmPlan_WeeklySchedule ws on p.PulletFarmPlan_WeeklyScheduleID = ws.PulletFarmPlan_WeeklyScheduleID
					inner join PulletFarmPlan pfp on ws.PulletFarmPlanID = pfp.PulletFarmPlanID
					inner join #Data d on p.Date = d.Date
					where pfp.FarmID = @FarmID
				) d on e.Date = d.Date'
				
			select @SQL = replace(@SQL, '@FarmID', convert(varchar(4), @FarmID))
			select @SQL = replace(@SQL, '@FarmColor', @FarmColor)
			select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
			execute (@SQL)


			-- Update Visible and FarmID
			select @SQL = 'update #Data set FarmColumn{NN}_Visible = 1, FarmColumn{NN}_FarmID = @FarmID'
			select @SQL = replace(@SQL, '@FarmID', convert(varchar(4), @FarmID))
			select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
			execute (@SQL)

			-- Update PulletFarmPlanID
			select @SQL = 'update #Data set FarmColumn{NN}_PulletFarmPlanDetailID = 0 where FarmColumn{NN}_PulletFarmPlanDetailID is null'
			select @SQL = replace(@SQL, '@FarmID', convert(varchar(4), @FarmID))
			select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
			execute (@SQL)

			-- Accumulate total qty
			select @SQL = 'update #Data set TotalQty = isnull(TotalQty,0) + isnull(FarmColumn{NN}_Qty,0)'
			select @SQL = replace(@SQL, '@FarmID', convert(varchar(4), @FarmID))
			select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
			execute (@SQL)

		end
	end

	update ps set ps.TotalContractVolume = cv.Volume
	from #Data ps
	inner join ContractVolume cv on ps.Date = cv.WeekEndingDate


	select 
	Date, 
	TotalQty = TotalQty / 1000,
	TotalContractVolume = TotalContractVolume / 1000,
	FarmColumn01_FarmID, FarmColumn01_Qty = convert(numeric(10,1), FarmColumn01_Qty / 1000.0), FarmColumn01_Visible, FarmColumn01_CellStyle, FarmColumn01_PulletFarmPlanDetailID, FarmColumn01_Color,
	FarmColumn02_FarmID, FarmColumn02_Qty = convert(numeric(10,1), FarmColumn02_Qty / 1000.0), FarmColumn02_Visible, FarmColumn02_CellStyle, FarmColumn02_PulletFarmPlanDetailID, FarmColumn02_Color,
	FarmColumn03_FarmID, FarmColumn03_Qty = convert(numeric(10,1), FarmColumn03_Qty / 1000.0), FarmColumn03_Visible, FarmColumn03_CellStyle, FarmColumn03_PulletFarmPlanDetailID, FarmColumn03_Color,
	FarmColumn04_FarmID, FarmColumn04_Qty = convert(numeric(10,1), FarmColumn04_Qty / 1000.0), FarmColumn04_Visible, FarmColumn04_CellStyle, FarmColumn04_PulletFarmPlanDetailID, FarmColumn04_Color,
	FarmColumn05_FarmID, FarmColumn05_Qty = convert(numeric(10,1), FarmColumn05_Qty / 1000.0), FarmColumn05_Visible, FarmColumn05_CellStyle, FarmColumn05_PulletFarmPlanDetailID, FarmColumn05_Color,
	FarmColumn06_FarmID, FarmColumn06_Qty = convert(numeric(10,1), FarmColumn06_Qty / 1000.0), FarmColumn06_Visible, FarmColumn06_CellStyle, FarmColumn06_PulletFarmPlanDetailID, FarmColumn06_Color,
	FarmColumn07_FarmID, FarmColumn07_Qty = convert(numeric(10,1), FarmColumn07_Qty / 1000.0), FarmColumn07_Visible, FarmColumn07_CellStyle, FarmColumn07_PulletFarmPlanDetailID, FarmColumn07_Color,
	FarmColumn08_FarmID, FarmColumn08_Qty = convert(numeric(10,1), FarmColumn08_Qty / 1000.0), FarmColumn08_Visible, FarmColumn08_CellStyle, FarmColumn08_PulletFarmPlanDetailID, FarmColumn08_Color,
	FarmColumn09_FarmID, FarmColumn09_Qty = convert(numeric(10,1), FarmColumn09_Qty / 1000.0), FarmColumn09_Visible, FarmColumn09_CellStyle, FarmColumn09_PulletFarmPlanDetailID, FarmColumn09_Color,
	FarmColumn10_FarmID, FarmColumn10_Qty = convert(numeric(10,1), FarmColumn10_Qty / 1000.0), FarmColumn10_Visible, FarmColumn10_CellStyle, FarmColumn10_PulletFarmPlanDetailID, FarmColumn10_Color,
	FarmColumn11_FarmID, FarmColumn11_Qty = convert(numeric(10,1), FarmColumn11_Qty / 1000.0), FarmColumn11_Visible, FarmColumn11_CellStyle, FarmColumn11_PulletFarmPlanDetailID, FarmColumn11_Color,
	FarmColumn12_FarmID, FarmColumn12_Qty = convert(numeric(10,1), FarmColumn12_Qty / 1000.0), FarmColumn12_Visible, FarmColumn12_CellStyle, FarmColumn12_PulletFarmPlanDetailID, FarmColumn12_Color,
	FarmColumn13_FarmID, FarmColumn13_Qty = convert(numeric(10,1), FarmColumn13_Qty / 1000.0), FarmColumn13_Visible, FarmColumn13_CellStyle, FarmColumn13_PulletFarmPlanDetailID, FarmColumn13_Color,
	FarmColumn14_FarmID, FarmColumn14_Qty = convert(numeric(10,1), FarmColumn14_Qty / 1000.0), FarmColumn14_Visible, FarmColumn14_CellStyle, FarmColumn14_PulletFarmPlanDetailID, FarmColumn14_Color,
	FarmColumn15_FarmID, FarmColumn15_Qty = convert(numeric(10,1), FarmColumn15_Qty / 1000.0), FarmColumn15_Visible, FarmColumn15_CellStyle, FarmColumn15_PulletFarmPlanDetailID, FarmColumn15_Color,
	FarmColumn16_FarmID, FarmColumn16_Qty = convert(numeric(10,1), FarmColumn16_Qty / 1000.0), FarmColumn16_Visible, FarmColumn16_CellStyle, FarmColumn16_PulletFarmPlanDetailID, FarmColumn16_Color,
	FarmColumn17_FarmID, FarmColumn17_Qty = convert(numeric(10,1), FarmColumn17_Qty / 1000.0), FarmColumn17_Visible, FarmColumn17_CellStyle, FarmColumn17_PulletFarmPlanDetailID, FarmColumn17_Color,
	FarmColumn18_FarmID, FarmColumn18_Qty = convert(numeric(10,1), FarmColumn18_Qty / 1000.0), FarmColumn18_Visible, FarmColumn18_CellStyle, FarmColumn18_PulletFarmPlanDetailID, FarmColumn18_Color,
	FarmColumn19_FarmID, FarmColumn19_Qty = convert(numeric(10,1), FarmColumn19_Qty / 1000.0), FarmColumn19_Visible, FarmColumn19_CellStyle, FarmColumn19_PulletFarmPlanDetailID, FarmColumn19_Color,
	FarmColumn20_FarmID, FarmColumn20_Qty = convert(numeric(10,1), FarmColumn20_Qty / 1000.0), FarmColumn20_Visible, FarmColumn20_CellStyle, FarmColumn20_PulletFarmPlanDetailID, FarmColumn20_Color,
	FarmColumn21_FarmID, FarmColumn21_Qty = convert(numeric(10,1), FarmColumn21_Qty / 1000.0), FarmColumn21_Visible, FarmColumn21_CellStyle, FarmColumn21_PulletFarmPlanDetailID, FarmColumn21_Color,
	FarmColumn22_FarmID, FarmColumn22_Qty = convert(numeric(10,1), FarmColumn22_Qty / 1000.0), FarmColumn22_Visible, FarmColumn22_CellStyle, FarmColumn22_PulletFarmPlanDetailID, FarmColumn22_Color,
	FarmColumn23_FarmID, FarmColumn23_Qty = convert(numeric(10,1), FarmColumn23_Qty / 1000.0), FarmColumn23_Visible, FarmColumn23_CellStyle, FarmColumn23_PulletFarmPlanDetailID, FarmColumn23_Color,
	FarmColumn24_FarmID, FarmColumn24_Qty = convert(numeric(10,1), FarmColumn24_Qty / 1000.0), FarmColumn24_Visible, FarmColumn24_CellStyle, FarmColumn24_PulletFarmPlanDetailID, FarmColumn24_Color,
	FarmColumn25_FarmID, FarmColumn25_Qty = convert(numeric(10,1), FarmColumn25_Qty / 1000.0), FarmColumn25_Visible, FarmColumn25_CellStyle, FarmColumn25_PulletFarmPlanDetailID, FarmColumn25_Color,
	FarmColumn26_FarmID, FarmColumn26_Qty = convert(numeric(10,1), FarmColumn26_Qty / 1000.0), FarmColumn26_Visible, FarmColumn26_CellStyle, FarmColumn26_PulletFarmPlanDetailID, FarmColumn26_Color,
	FarmColumn27_FarmID, FarmColumn27_Qty = convert(numeric(10,1), FarmColumn27_Qty / 1000.0), FarmColumn27_Visible, FarmColumn27_CellStyle, FarmColumn27_PulletFarmPlanDetailID, FarmColumn27_Color,
	FarmColumn28_FarmID, FarmColumn28_Qty = convert(numeric(10,1), FarmColumn28_Qty / 1000.0), FarmColumn28_Visible, FarmColumn28_CellStyle, FarmColumn28_PulletFarmPlanDetailID, FarmColumn28_Color,
	FarmColumn29_FarmID, FarmColumn29_Qty = convert(numeric(10,1), FarmColumn29_Qty / 1000.0), FarmColumn29_Visible, FarmColumn29_CellStyle, FarmColumn29_PulletFarmPlanDetailID, FarmColumn29_Color,
	FarmColumn30_FarmID, FarmColumn30_Qty = convert(numeric(10,1), FarmColumn30_Qty / 1000.0), FarmColumn30_Visible, FarmColumn30_CellStyle, FarmColumn30_PulletFarmPlanDetailID, FarmColumn30_Color	
from #Data
order by Date

drop table #Data




GO
