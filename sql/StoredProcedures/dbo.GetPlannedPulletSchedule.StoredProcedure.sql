/****** Object:  StoredProcedure [dbo].[GetPlannedPulletSchedule]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetPlannedPulletSchedule]
GO
/****** Object:  StoredProcedure [dbo].[GetPlannedPulletSchedule]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPlannedPulletSchedule]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPlannedPulletSchedule] AS' 
END
GO



ALTER proc [dbo].[GetPlannedPulletSchedule]	@UserID varchar(255), @StartDate date, @EndDate date, @ContractTypeID int
as

set nocount on

	declare @FarmID int
	declare @FarmColor varchar(10)
	declare @sql varchar(4000)
	declare @LoopCounter int = 0
	declare @FarmCol int = 0
	declare @EmbryosPerBirdPerDay numeric(8,6)
	declare @MaxFarmCount int

	select @EmbryosPerBirdPerDay = ConstantValue
	from SystemConstant
	where ConstantName = 'Embryos Per Bird Per Day Ratio'

	select @MaxFarmCount = ConstantValue
	from SystemConstant
	where ConstantName = 'Max count of production farms to display'

	select @MaxFarmCount = isnull(@MaxFarmCount, 30)


	create table #Data
	(
		WeekEndingDate date, 
		TotalEggsForWeek int,
		TotalSellableEggsForWeek int,
		TotalContractVolumeForWeek int,
		TotalPulletQty int,
		BirdsOnline int,
		BirdsPlusMinus int,
		BirdsPlusMinusBackgroundColor varchar(20),
		AvgSellableEmbryosPerBirdPerWeek numeric(20,10),
		-- Note - the Qty below stands for the Pullet Qty At 16 Weeks
		FarmColumn01_Qty int, FarmColumn01_FarmID int, FarmColumn01_Visible bit DEFAULT 0, FarmColumn01_Color varchar(10), FarmColumn01_PulletFarmPlanID int, FarmColumn01_WorkPulletFarmPlanID int default 0, FarmColumn01_CellStyle varchar(50),
		FarmColumn02_Qty int, FarmColumn02_FarmID int, FarmColumn02_Visible bit DEFAULT 0, FarmColumn02_Color varchar(10), FarmColumn02_PulletFarmPlanID int, FarmColumn02_WorkPulletFarmPlanID int default 0, FarmColumn02_CellStyle varchar(50),
		FarmColumn03_Qty int, FarmColumn03_FarmID int, FarmColumn03_Visible bit DEFAULT 0, FarmColumn03_Color varchar(10), FarmColumn03_PulletFarmPlanID int, FarmColumn03_WorkPulletFarmPlanID int default 0, FarmColumn03_CellStyle varchar(50),
		FarmColumn04_Qty int, FarmColumn04_FarmID int, FarmColumn04_Visible bit DEFAULT 0, FarmColumn04_Color varchar(10), FarmColumn04_PulletFarmPlanID int, FarmColumn04_WorkPulletFarmPlanID int default 0, FarmColumn04_CellStyle varchar(50),
		FarmColumn05_Qty int, FarmColumn05_FarmID int, FarmColumn05_Visible bit DEFAULT 0, FarmColumn05_Color varchar(10), FarmColumn05_PulletFarmPlanID int, FarmColumn05_WorkPulletFarmPlanID int default 0, FarmColumn05_CellStyle varchar(50),
		FarmColumn06_Qty int, FarmColumn06_FarmID int, FarmColumn06_Visible bit DEFAULT 0, FarmColumn06_Color varchar(10), FarmColumn06_PulletFarmPlanID int, FarmColumn06_WorkPulletFarmPlanID int default 0, FarmColumn06_CellStyle varchar(50),
		FarmColumn07_Qty int, FarmColumn07_FarmID int, FarmColumn07_Visible bit DEFAULT 0, FarmColumn07_Color varchar(10), FarmColumn07_PulletFarmPlanID int, FarmColumn07_WorkPulletFarmPlanID int default 0, FarmColumn07_CellStyle varchar(50),
		FarmColumn08_Qty int, FarmColumn08_FarmID int, FarmColumn08_Visible bit DEFAULT 0, FarmColumn08_Color varchar(10), FarmColumn08_PulletFarmPlanID int, FarmColumn08_WorkPulletFarmPlanID int default 0, FarmColumn08_CellStyle varchar(50),
		FarmColumn09_Qty int, FarmColumn09_FarmID int, FarmColumn09_Visible bit DEFAULT 0, FarmColumn09_Color varchar(10), FarmColumn09_PulletFarmPlanID int, FarmColumn09_WorkPulletFarmPlanID int default 0, FarmColumn09_CellStyle varchar(50),
		FarmColumn10_Qty int, FarmColumn10_FarmID int, FarmColumn10_Visible bit DEFAULT 0, FarmColumn10_Color varchar(10), FarmColumn10_PulletFarmPlanID int, FarmColumn10_WorkPulletFarmPlanID int default 0, FarmColumn10_CellStyle varchar(50),
		FarmColumn11_Qty int, FarmColumn11_FarmID int, FarmColumn11_Visible bit DEFAULT 0, FarmColumn11_Color varchar(10), FarmColumn11_PulletFarmPlanID int, FarmColumn11_WorkPulletFarmPlanID int default 0, FarmColumn11_CellStyle varchar(50),
		FarmColumn12_Qty int, FarmColumn12_FarmID int, FarmColumn12_Visible bit DEFAULT 0, FarmColumn12_Color varchar(10), FarmColumn12_PulletFarmPlanID int, FarmColumn12_WorkPulletFarmPlanID int default 0, FarmColumn12_CellStyle varchar(50),
		FarmColumn13_Qty int, FarmColumn13_FarmID int, FarmColumn13_Visible bit DEFAULT 0, FarmColumn13_Color varchar(10), FarmColumn13_PulletFarmPlanID int, FarmColumn13_WorkPulletFarmPlanID int default 0, FarmColumn13_CellStyle varchar(50),
		FarmColumn14_Qty int, FarmColumn14_FarmID int, FarmColumn14_Visible bit DEFAULT 0, FarmColumn14_Color varchar(10), FarmColumn14_PulletFarmPlanID int, FarmColumn14_WorkPulletFarmPlanID int default 0, FarmColumn14_CellStyle varchar(50),
		FarmColumn15_Qty int, FarmColumn15_FarmID int, FarmColumn15_Visible bit DEFAULT 0, FarmColumn15_Color varchar(10), FarmColumn15_PulletFarmPlanID int, FarmColumn15_WorkPulletFarmPlanID int default 0, FarmColumn15_CellStyle varchar(50),
		FarmColumn16_Qty int, FarmColumn16_FarmID int, FarmColumn16_Visible bit DEFAULT 0, FarmColumn16_Color varchar(10), FarmColumn16_PulletFarmPlanID int, FarmColumn16_WorkPulletFarmPlanID int default 0, FarmColumn16_CellStyle varchar(50),
		FarmColumn17_Qty int, FarmColumn17_FarmID int, FarmColumn17_Visible bit DEFAULT 0, FarmColumn17_Color varchar(10), FarmColumn17_PulletFarmPlanID int, FarmColumn17_WorkPulletFarmPlanID int default 0, FarmColumn17_CellStyle varchar(50),
		FarmColumn18_Qty int, FarmColumn18_FarmID int, FarmColumn18_Visible bit DEFAULT 0, FarmColumn18_Color varchar(10), FarmColumn18_PulletFarmPlanID int, FarmColumn18_WorkPulletFarmPlanID int default 0, FarmColumn18_CellStyle varchar(50),
		FarmColumn19_Qty int, FarmColumn19_FarmID int, FarmColumn19_Visible bit DEFAULT 0, FarmColumn19_Color varchar(10), FarmColumn19_PulletFarmPlanID int, FarmColumn19_WorkPulletFarmPlanID int default 0, FarmColumn19_CellStyle varchar(50),
		FarmColumn20_Qty int, FarmColumn20_FarmID int, FarmColumn20_Visible bit DEFAULT 0, FarmColumn20_Color varchar(10), FarmColumn20_PulletFarmPlanID int, FarmColumn20_WorkPulletFarmPlanID int default 0, FarmColumn20_CellStyle varchar(50),
		FarmColumn21_Qty int, FarmColumn21_FarmID int, FarmColumn21_Visible bit DEFAULT 0, FarmColumn21_Color varchar(10), FarmColumn21_PulletFarmPlanID int, FarmColumn21_WorkPulletFarmPlanID int default 0, FarmColumn21_CellStyle varchar(50),
		FarmColumn22_Qty int, FarmColumn22_FarmID int, FarmColumn22_Visible bit DEFAULT 0, FarmColumn22_Color varchar(10), FarmColumn22_PulletFarmPlanID int, FarmColumn22_WorkPulletFarmPlanID int default 0, FarmColumn22_CellStyle varchar(50),
		FarmColumn23_Qty int, FarmColumn23_FarmID int, FarmColumn23_Visible bit DEFAULT 0, FarmColumn23_Color varchar(10), FarmColumn23_PulletFarmPlanID int, FarmColumn23_WorkPulletFarmPlanID int default 0, FarmColumn23_CellStyle varchar(50),
		FarmColumn24_Qty int, FarmColumn24_FarmID int, FarmColumn24_Visible bit DEFAULT 0, FarmColumn24_Color varchar(10), FarmColumn24_PulletFarmPlanID int, FarmColumn24_WorkPulletFarmPlanID int default 0, FarmColumn24_CellStyle varchar(50),
		FarmColumn25_Qty int, FarmColumn25_FarmID int, FarmColumn25_Visible bit DEFAULT 0, FarmColumn25_Color varchar(10), FarmColumn25_PulletFarmPlanID int, FarmColumn25_WorkPulletFarmPlanID int default 0, FarmColumn25_CellStyle varchar(50),
		FarmColumn26_Qty int, FarmColumn26_FarmID int, FarmColumn26_Visible bit DEFAULT 0, FarmColumn26_Color varchar(10), FarmColumn26_PulletFarmPlanID int, FarmColumn26_WorkPulletFarmPlanID int default 0, FarmColumn26_CellStyle varchar(50),
		FarmColumn27_Qty int, FarmColumn27_FarmID int, FarmColumn27_Visible bit DEFAULT 0, FarmColumn27_Color varchar(10), FarmColumn27_PulletFarmPlanID int, FarmColumn27_WorkPulletFarmPlanID int default 0, FarmColumn27_CellStyle varchar(50),
		FarmColumn28_Qty int, FarmColumn28_FarmID int, FarmColumn28_Visible bit DEFAULT 0, FarmColumn28_Color varchar(10), FarmColumn28_PulletFarmPlanID int, FarmColumn28_WorkPulletFarmPlanID int default 0, FarmColumn28_CellStyle varchar(50),
		FarmColumn29_Qty int, FarmColumn29_FarmID int, FarmColumn29_Visible bit DEFAULT 0, FarmColumn29_Color varchar(10), FarmColumn29_PulletFarmPlanID int, FarmColumn29_WorkPulletFarmPlanID int default 0, FarmColumn29_CellStyle varchar(50),
		FarmColumn30_Qty int, FarmColumn30_FarmID int, FarmColumn30_Visible bit DEFAULT 0, FarmColumn30_Color varchar(10), FarmColumn30_PulletFarmPlanID int, FarmColumn30_WorkPulletFarmPlanID int default 0, FarmColumn30_CellStyle varchar(50),
		FarmColumn31_Qty int, FarmColumn31_FarmID int, FarmColumn31_Visible bit DEFAULT 0, FarmColumn31_Color varchar(10), FarmColumn31_PulletFarmPlanID int, FarmColumn31_WorkPulletFarmPlanID int default 0, FarmColumn31_CellStyle varchar(50),
		FarmColumn32_Qty int, FarmColumn32_FarmID int, FarmColumn32_Visible bit DEFAULT 0, FarmColumn32_Color varchar(10), FarmColumn32_PulletFarmPlanID int, FarmColumn32_WorkPulletFarmPlanID int default 0, FarmColumn32_CellStyle varchar(50),
		FarmColumn33_Qty int, FarmColumn33_FarmID int, FarmColumn33_Visible bit DEFAULT 0, FarmColumn33_Color varchar(10), FarmColumn33_PulletFarmPlanID int, FarmColumn33_WorkPulletFarmPlanID int default 0, FarmColumn33_CellStyle varchar(50),
		FarmColumn34_Qty int, FarmColumn34_FarmID int, FarmColumn34_Visible bit DEFAULT 0, FarmColumn34_Color varchar(10), FarmColumn34_PulletFarmPlanID int, FarmColumn34_WorkPulletFarmPlanID int default 0, FarmColumn34_CellStyle varchar(50),
		FarmColumn35_Qty int, FarmColumn35_FarmID int, FarmColumn35_Visible bit DEFAULT 0, FarmColumn35_Color varchar(10), FarmColumn35_PulletFarmPlanID int, FarmColumn35_WorkPulletFarmPlanID int default 0, FarmColumn35_CellStyle varchar(50),
		FarmColumn36_Qty int, FarmColumn36_FarmID int, FarmColumn36_Visible bit DEFAULT 0, FarmColumn36_Color varchar(10), FarmColumn36_PulletFarmPlanID int, FarmColumn36_WorkPulletFarmPlanID int default 0, FarmColumn36_CellStyle varchar(50),
		FarmColumn37_Qty int, FarmColumn37_FarmID int, FarmColumn37_Visible bit DEFAULT 0, FarmColumn37_Color varchar(10), FarmColumn37_PulletFarmPlanID int, FarmColumn37_WorkPulletFarmPlanID int default 0, FarmColumn37_CellStyle varchar(50),
		FarmColumn38_Qty int, FarmColumn38_FarmID int, FarmColumn38_Visible bit DEFAULT 0, FarmColumn38_Color varchar(10), FarmColumn38_PulletFarmPlanID int, FarmColumn38_WorkPulletFarmPlanID int default 0, FarmColumn38_CellStyle varchar(50),
		FarmColumn39_Qty int, FarmColumn39_FarmID int, FarmColumn39_Visible bit DEFAULT 0, FarmColumn39_Color varchar(10), FarmColumn39_PulletFarmPlanID int, FarmColumn39_WorkPulletFarmPlanID int default 0, FarmColumn39_CellStyle varchar(50),
		FarmColumn40_Qty int, FarmColumn40_FarmID int, FarmColumn40_Visible bit DEFAULT 0, FarmColumn40_Color varchar(10), FarmColumn40_PulletFarmPlanID int, FarmColumn40_WorkPulletFarmPlanID int default 0, FarmColumn40_CellStyle varchar(50),
		FarmColumn41_Qty int, FarmColumn41_FarmID int, FarmColumn41_Visible bit DEFAULT 0, FarmColumn41_Color varchar(10), FarmColumn41_PulletFarmPlanID int, FarmColumn41_WorkPulletFarmPlanID int default 0, FarmColumn41_CellStyle varchar(50),
		FarmColumn42_Qty int, FarmColumn42_FarmID int, FarmColumn42_Visible bit DEFAULT 0, FarmColumn42_Color varchar(10), FarmColumn42_PulletFarmPlanID int, FarmColumn42_WorkPulletFarmPlanID int default 0, FarmColumn42_CellStyle varchar(50),
		FarmColumn43_Qty int, FarmColumn43_FarmID int, FarmColumn43_Visible bit DEFAULT 0, FarmColumn43_Color varchar(10), FarmColumn43_PulletFarmPlanID int, FarmColumn43_WorkPulletFarmPlanID int default 0, FarmColumn43_CellStyle varchar(50),
		FarmColumn44_Qty int, FarmColumn44_FarmID int, FarmColumn44_Visible bit DEFAULT 0, FarmColumn44_Color varchar(10), FarmColumn44_PulletFarmPlanID int, FarmColumn44_WorkPulletFarmPlanID int default 0, FarmColumn44_CellStyle varchar(50),
		FarmColumn45_Qty int, FarmColumn45_FarmID int, FarmColumn45_Visible bit DEFAULT 0, FarmColumn45_Color varchar(10), FarmColumn45_PulletFarmPlanID int, FarmColumn45_WorkPulletFarmPlanID int default 0, FarmColumn45_CellStyle varchar(50),
		FarmColumn46_Qty int, FarmColumn46_FarmID int, FarmColumn46_Visible bit DEFAULT 0, FarmColumn46_Color varchar(10), FarmColumn46_PulletFarmPlanID int, FarmColumn46_WorkPulletFarmPlanID int default 0, FarmColumn46_CellStyle varchar(50),
		FarmColumn47_Qty int, FarmColumn47_FarmID int, FarmColumn47_Visible bit DEFAULT 0, FarmColumn47_Color varchar(10), FarmColumn47_PulletFarmPlanID int, FarmColumn47_WorkPulletFarmPlanID int default 0, FarmColumn47_CellStyle varchar(50),
		FarmColumn48_Qty int, FarmColumn48_FarmID int, FarmColumn48_Visible bit DEFAULT 0, FarmColumn48_Color varchar(10), FarmColumn48_PulletFarmPlanID int, FarmColumn48_WorkPulletFarmPlanID int default 0, FarmColumn48_CellStyle varchar(50),
		FarmColumn49_Qty int, FarmColumn49_FarmID int, FarmColumn49_Visible bit DEFAULT 0, FarmColumn49_Color varchar(10), FarmColumn49_PulletFarmPlanID int, FarmColumn49_WorkPulletFarmPlanID int default 0, FarmColumn49_CellStyle varchar(50),
		FarmColumn50_Qty int, FarmColumn50_FarmID int, FarmColumn50_Visible bit DEFAULT 0, FarmColumn50_Color varchar(10), FarmColumn50_PulletFarmPlanID int, FarmColumn50_WorkPulletFarmPlanID int default 0, FarmColumn50_CellStyle varchar(50)
	)

	declare @FarmList table (FarmColumn int, FarmID int, FarmName varchar(100), FarmNumber varchar(6))
	insert into @FarmList
	select * 
	from dbo.GetPlanningFarmList(@UserID)

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
		Select dateadd(wk, 1, Date)
			from DateSequence
			where Date < @EndDate
	)

	insert into #Data (WeekEndingDate)
	select *
	from DateSequence
	OPTION (MAXRECURSION 32747)

	----------------------------------------------------------------------------
	-- At this point, we have a table, #Data, that contains the 
	-- week ending dates for the specified date range.
	-- We created a view called RollingWeeklySchedule
	-- which will return the actual information, if order confirms have occurred, 
	-- otherwise it returns the planned data
	-- It also returns a field, UseSourceType, which indicates if either 
	-- the planning or the actual fields are to be used, based on the information 
	-- that is populated in the PulletFarmPlan_WeeklySchedule table
	----------------------------------------------------------------------------


	while @LoopCounter < @MaxFarmCount
	begin
		select @LoopCounter = @LoopCounter + 1
		select @FarmCol = @LoopCounter - 1

		select @FarmID = null

		select @FarmID = FarmID from @FarmList where FarmColumn = @FarmCol
		select @FarmColor = isnull(pc.PlanningColor, 'White')
		from Farm f
		left outer join PlanningColor pc on f.PlanningColorID = pc.PlanningColorID
		where FarmID = @FarmID

		if @FarmID is not null
		begin
			select @SQL = 
			'update e set 
			e.FarmColumn{NN}_Color = ''@FarmColor'',
			--e.FarmColumn{NN}_Qty = CalcPulletQty, 
			e.FarmColumn{NN}_Qty = CalcPulletQty_NotProrated, 
			e.FarmColumn{NN}_CellStyle = 
				case
					when d.WeekEndingDate <= getdate() then ''PastPlan''
					when d.SourceType = ''Planned'' then ''LongTermPlan''
					when d.ModifiedAfterOrderConfirm = 1 and isnull(d.OverrideModifiedAfterOrderConfirm,0) = 0 then ''OrderConfirmPlan FlockPlanWarning''
					else ''OrderConfirmPlan''				
				end,
			e.FarmColumn{NN}_PulletFarmPlanID = PulletFarmPlanID,
			e.FarmColumn{NN}_WorkPulletFarmPlanID = PulletFarmPlanID,
			e.FarmColumn{NN}_FarmID = @FarmID
			from #Data e
			inner join 
				(
					select 
						SourceType = UseSourceType,
						WeekEndingDate,
						SellableEggs = CalcSellableEggs_FromStandards,
						p.PulletQtyAt16Weeks,
						p.PulletFarmPlanID,
						p.ModifiedAfterOrderConfirm,
						p.CalcPulletQty,
						p.CalcPulletQty_NotProrated,
						p.OverrideModifiedAfterOrderConfirm
					from RollingWeeklySchedule p
					where FarmID = @FarmID and p.ContractTypeID = @ContractTypeID
					and CalcSellableEggs_FromStandards > 0
				) d on e.WeekEndingDate = d.WeekEndingDate'
				
			select @SQL = replace(@SQL, '@FarmID', convert(varchar(4), @FarmID))
			select @SQL = replace(@SQL, '@FarmColor', @FarmColor)
			select @SQL = replace(@SQL, '@ContractTypeID', convert(varchar(4), @ContractTypeID))
			select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
			execute (@SQL)


			-- Update Visible and FarmID
			select @SQL = 'update #Data set FarmColumn{NN}_Visible = 1, FarmColumn{NN}_FarmID = @FarmID'
			select @SQL = replace(@SQL, '@FarmID', convert(varchar(4), @FarmID))
			select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
			execute (@SQL)

		end
	end

	update ps set ps.TotalSellableEggsForWeek = ws.CalcSellableEggs, ps.TotalPulletQty = ws.TotalPulletQty
	from #Data ps
	inner join 
	(
		select WeekEndingDate, sum(CalcSellableEggs_FromStandards) as CalcSellableEggs, sum(CalcPulletQty) as TotalPulletQty
		from RollingWeeklySchedule pfp
		where exists (select 1 from #Data where WeekEndingDate = pfp.WeekEndingDate)
		and pfp.ContractTypeID = @ContractTypeID
		--and WeekEndingDate <= FlockEndDate
		--and WeekEndingDate >= FlockStartDate
		group by WeekEndingDate
	) ws on ps.WeekEndingDate = ws.WeekEndingDate


	update ps set ps.TotalContractVolumeForWeek = cv.Volume
	from #Data ps
	inner join ContractVolume cv on ps.WeekEndingDate = cv.WeekEndingDate
	inner join Contract c on cv.ContractID = c.ContractID and c.ContractTypeID = @ContractTypeID

	update #Data set BirdsOnline = TotalPulletQty

	update #Data set AvgSellableEmbryosPerBirdPerWeek = convert(numeric(20,10), TotalSellableEggsForWeek) / convert(numeric(20,10), TotalPulletQty) * 1.00000
	where TotalPulletQty <> 0

	update d set d.AvgSellableEmbryosPerBirdPerWeek = a.AvgSellableEmbryosPerBirdPerWeek
	from #Data d
	inner join 
	(
		select WeekEndingDate, AvgSellableEmbryosPerBirdPerWeek = convert(numeric(20,10), avg(AvgSellableEmbryosPerBirdPerWeek))
		from #Data
		where TotalPulletQty <> 0
		group by WeekEndingDate
	) a on d.WeekEndingDate = a.WeekEndingDate
	where d.TotalPulletQty = 0

	--???
	-- Not sure if I should be using this for the default when there is not data...
	--update #Data set AvgSellableEmbryosPerBirdPerWeek = @EmbryosPerBirdPerDay * 7 * 1.00000
	--where TotalPulletQty = 0



	update #Data set BirdsPlusMinus = convert(numeric(20,10), (TotalSellableEggsForWeek - TotalContractVolumeForWeek)) / convert(numeric(20,10), AvgSellableEmbryosPerBirdPerWeek)
	where AvgSellableEmbryosPerBirdPerWeek <> 0

	update #Data set BirdsPlusMinusBackgroundColor=
			case
				when BirdsPlusMinus < 0 then 'red'
				else 'yellow'
			end

	select 
	ContractTypeID = @ContractTypeID,
	WeekEndingDate, 
	TotalSellableEggsForWeek = round(TotalSellableEggsForWeek / 1000.0, 0),
	TotalContractVolumeForWeek = round(TotalContractVolumeForWeek / 1000.0, 0),
	BirdsOnline = round(BirdsOnline / 1000, 0),
	TotalPulletQty,
	--BirdsNeeded = convert(int,round((TotalContractVolumeForWeek / 7 / .735)/ 1000,0)) ,
	AvgSellableEmbryosPerBirdPerWeek,
	ExcessEmbryos = round(TotalSellableEggsForWeek / 1000.0, 0) - round(TotalContractVolumeForWeek / 1000.0, 0),
	BirdsPlusMinus = BirdsPlusMinus / 1000,
	BirdsPlusMinusBackgroundColor,
	FarmColumn01_FarmID, FarmColumn01_Qty = convert(numeric(10,1), FarmColumn01_Qty / 1000.0), FarmColumn01_Visible, FarmColumn01_CellStyle, FarmColumn01_WorkPulletFarmPlanID, FarmColumn01_PulletFarmPlanID, FarmColumn01_Color,
	FarmColumn02_FarmID, FarmColumn02_Qty = convert(numeric(10,1), FarmColumn02_Qty / 1000.0), FarmColumn02_Visible, FarmColumn02_CellStyle, FarmColumn02_WorkPulletFarmPlanID, FarmColumn02_PulletFarmPlanID, FarmColumn02_Color,
	FarmColumn03_FarmID, FarmColumn03_Qty = convert(numeric(10,1), FarmColumn03_Qty / 1000.0), FarmColumn03_Visible, FarmColumn03_CellStyle, FarmColumn03_WorkPulletFarmPlanID, FarmColumn03_PulletFarmPlanID, FarmColumn03_Color,
	FarmColumn04_FarmID, FarmColumn04_Qty = convert(numeric(10,1), FarmColumn04_Qty / 1000.0), FarmColumn04_Visible, FarmColumn04_CellStyle, FarmColumn04_WorkPulletFarmPlanID, FarmColumn04_PulletFarmPlanID, FarmColumn04_Color,
	FarmColumn05_FarmID, FarmColumn05_Qty = convert(numeric(10,1), FarmColumn05_Qty / 1000.0), FarmColumn05_Visible, FarmColumn05_CellStyle, FarmColumn05_WorkPulletFarmPlanID, FarmColumn05_PulletFarmPlanID, FarmColumn05_Color,
	FarmColumn06_FarmID, FarmColumn06_Qty = convert(numeric(10,1), FarmColumn06_Qty / 1000.0), FarmColumn06_Visible, FarmColumn06_CellStyle, FarmColumn06_WorkPulletFarmPlanID, FarmColumn06_PulletFarmPlanID, FarmColumn06_Color,
	FarmColumn07_FarmID, FarmColumn07_Qty = convert(numeric(10,1), FarmColumn07_Qty / 1000.0), FarmColumn07_Visible, FarmColumn07_CellStyle, FarmColumn07_WorkPulletFarmPlanID, FarmColumn07_PulletFarmPlanID, FarmColumn07_Color,
	FarmColumn08_FarmID, FarmColumn08_Qty = convert(numeric(10,1), FarmColumn08_Qty / 1000.0), FarmColumn08_Visible, FarmColumn08_CellStyle, FarmColumn08_WorkPulletFarmPlanID, FarmColumn08_PulletFarmPlanID, FarmColumn08_Color,
	FarmColumn09_FarmID, FarmColumn09_Qty = convert(numeric(10,1), FarmColumn09_Qty / 1000.0), FarmColumn09_Visible, FarmColumn09_CellStyle, FarmColumn09_WorkPulletFarmPlanID, FarmColumn09_PulletFarmPlanID, FarmColumn09_Color,
	FarmColumn10_FarmID, FarmColumn10_Qty = convert(numeric(10,1), FarmColumn10_Qty / 1000.0), FarmColumn10_Visible, FarmColumn10_CellStyle, FarmColumn10_WorkPulletFarmPlanID, FarmColumn10_PulletFarmPlanID, FarmColumn10_Color,
	FarmColumn11_FarmID, FarmColumn11_Qty = convert(numeric(10,1), FarmColumn11_Qty / 1000.0), FarmColumn11_Visible, FarmColumn11_CellStyle, FarmColumn11_WorkPulletFarmPlanID, FarmColumn11_PulletFarmPlanID, FarmColumn11_Color,
	FarmColumn12_FarmID, FarmColumn12_Qty = convert(numeric(10,1), FarmColumn12_Qty / 1000.0), FarmColumn12_Visible, FarmColumn12_CellStyle, FarmColumn12_WorkPulletFarmPlanID, FarmColumn12_PulletFarmPlanID, FarmColumn12_Color,
	FarmColumn13_FarmID, FarmColumn13_Qty = convert(numeric(10,1), FarmColumn13_Qty / 1000.0), FarmColumn13_Visible, FarmColumn13_CellStyle, FarmColumn13_WorkPulletFarmPlanID, FarmColumn13_PulletFarmPlanID, FarmColumn13_Color,
	FarmColumn14_FarmID, FarmColumn14_Qty = convert(numeric(10,1), FarmColumn14_Qty / 1000.0), FarmColumn14_Visible, FarmColumn14_CellStyle, FarmColumn14_WorkPulletFarmPlanID, FarmColumn14_PulletFarmPlanID, FarmColumn14_Color,
	FarmColumn15_FarmID, FarmColumn15_Qty = convert(numeric(10,1), FarmColumn15_Qty / 1000.0), FarmColumn15_Visible, FarmColumn15_CellStyle, FarmColumn15_WorkPulletFarmPlanID, FarmColumn15_PulletFarmPlanID, FarmColumn15_Color,
	FarmColumn16_FarmID, FarmColumn16_Qty = convert(numeric(10,1), FarmColumn16_Qty / 1000.0), FarmColumn16_Visible, FarmColumn16_CellStyle, FarmColumn16_WorkPulletFarmPlanID, FarmColumn16_PulletFarmPlanID, FarmColumn16_Color,
	FarmColumn17_FarmID, FarmColumn17_Qty = convert(numeric(10,1), FarmColumn17_Qty / 1000.0), FarmColumn17_Visible, FarmColumn17_CellStyle, FarmColumn17_WorkPulletFarmPlanID, FarmColumn17_PulletFarmPlanID, FarmColumn17_Color,
	FarmColumn18_FarmID, FarmColumn18_Qty = convert(numeric(10,1), FarmColumn18_Qty / 1000.0), FarmColumn18_Visible, FarmColumn18_CellStyle, FarmColumn18_WorkPulletFarmPlanID, FarmColumn18_PulletFarmPlanID, FarmColumn18_Color,
	FarmColumn19_FarmID, FarmColumn19_Qty = convert(numeric(10,1), FarmColumn19_Qty / 1000.0), FarmColumn19_Visible, FarmColumn19_CellStyle, FarmColumn19_WorkPulletFarmPlanID, FarmColumn19_PulletFarmPlanID, FarmColumn19_Color,
	FarmColumn20_FarmID, FarmColumn20_Qty = convert(numeric(10,1), FarmColumn20_Qty / 1000.0), FarmColumn20_Visible, FarmColumn20_CellStyle, FarmColumn20_WorkPulletFarmPlanID, FarmColumn20_PulletFarmPlanID, FarmColumn20_Color,
	FarmColumn21_FarmID, FarmColumn21_Qty = convert(numeric(10,1), FarmColumn21_Qty / 1000.0), FarmColumn21_Visible, FarmColumn21_CellStyle, FarmColumn21_WorkPulletFarmPlanID, FarmColumn21_PulletFarmPlanID, FarmColumn21_Color,
	FarmColumn22_FarmID, FarmColumn22_Qty = convert(numeric(10,1), FarmColumn22_Qty / 1000.0), FarmColumn22_Visible, FarmColumn22_CellStyle, FarmColumn22_WorkPulletFarmPlanID, FarmColumn22_PulletFarmPlanID, FarmColumn22_Color,
	FarmColumn23_FarmID, FarmColumn23_Qty = convert(numeric(10,1), FarmColumn23_Qty / 1000.0), FarmColumn23_Visible, FarmColumn23_CellStyle, FarmColumn23_WorkPulletFarmPlanID, FarmColumn23_PulletFarmPlanID, FarmColumn23_Color,
	FarmColumn24_FarmID, FarmColumn24_Qty = convert(numeric(10,1), FarmColumn24_Qty / 1000.0), FarmColumn24_Visible, FarmColumn24_CellStyle, FarmColumn24_WorkPulletFarmPlanID, FarmColumn24_PulletFarmPlanID, FarmColumn24_Color,
	FarmColumn25_FarmID, FarmColumn25_Qty = convert(numeric(10,1), FarmColumn25_Qty / 1000.0), FarmColumn25_Visible, FarmColumn25_CellStyle, FarmColumn25_WorkPulletFarmPlanID, FarmColumn25_PulletFarmPlanID, FarmColumn25_Color,
	FarmColumn26_FarmID, FarmColumn26_Qty = convert(numeric(10,1), FarmColumn26_Qty / 1000.0), FarmColumn26_Visible, FarmColumn26_CellStyle, FarmColumn26_WorkPulletFarmPlanID, FarmColumn26_PulletFarmPlanID, FarmColumn26_Color,
	FarmColumn27_FarmID, FarmColumn27_Qty = convert(numeric(10,1), FarmColumn27_Qty / 1000.0), FarmColumn27_Visible, FarmColumn27_CellStyle, FarmColumn27_WorkPulletFarmPlanID, FarmColumn27_PulletFarmPlanID, FarmColumn27_Color,
	FarmColumn28_FarmID, FarmColumn28_Qty = convert(numeric(10,1), FarmColumn28_Qty / 1000.0), FarmColumn28_Visible, FarmColumn28_CellStyle, FarmColumn28_WorkPulletFarmPlanID, FarmColumn28_PulletFarmPlanID, FarmColumn28_Color,
	FarmColumn29_FarmID, FarmColumn29_Qty = convert(numeric(10,1), FarmColumn29_Qty / 1000.0), FarmColumn29_Visible, FarmColumn29_CellStyle, FarmColumn29_WorkPulletFarmPlanID, FarmColumn29_PulletFarmPlanID, FarmColumn29_Color,
	FarmColumn30_FarmID, FarmColumn30_Qty = convert(numeric(10,1), FarmColumn30_Qty / 1000.0), FarmColumn30_Visible, FarmColumn30_CellStyle, FarmColumn30_WorkPulletFarmPlanID, FarmColumn30_PulletFarmPlanID, FarmColumn30_Color,
	FarmColumn31_FarmID, FarmColumn31_Qty = convert(numeric(10,1), FarmColumn31_Qty / 1000.0), FarmColumn31_Visible, FarmColumn31_CellStyle, FarmColumn31_WorkPulletFarmPlanID, FarmColumn31_PulletFarmPlanID, FarmColumn31_Color,
	FarmColumn32_FarmID, FarmColumn32_Qty = convert(numeric(10,1), FarmColumn32_Qty / 1000.0), FarmColumn32_Visible, FarmColumn32_CellStyle, FarmColumn32_WorkPulletFarmPlanID, FarmColumn32_PulletFarmPlanID, FarmColumn32_Color,
	FarmColumn33_FarmID, FarmColumn33_Qty = convert(numeric(10,1), FarmColumn33_Qty / 1000.0), FarmColumn33_Visible, FarmColumn33_CellStyle, FarmColumn33_WorkPulletFarmPlanID, FarmColumn33_PulletFarmPlanID, FarmColumn33_Color,
	FarmColumn34_FarmID, FarmColumn34_Qty = convert(numeric(10,1), FarmColumn34_Qty / 1000.0), FarmColumn34_Visible, FarmColumn34_CellStyle, FarmColumn34_WorkPulletFarmPlanID, FarmColumn34_PulletFarmPlanID, FarmColumn34_Color,
	FarmColumn35_FarmID, FarmColumn35_Qty = convert(numeric(10,1), FarmColumn35_Qty / 1000.0), FarmColumn35_Visible, FarmColumn35_CellStyle, FarmColumn35_WorkPulletFarmPlanID, FarmColumn35_PulletFarmPlanID, FarmColumn35_Color,
	FarmColumn36_FarmID, FarmColumn36_Qty = convert(numeric(10,1), FarmColumn36_Qty / 1000.0), FarmColumn36_Visible, FarmColumn36_CellStyle, FarmColumn36_WorkPulletFarmPlanID, FarmColumn36_PulletFarmPlanID, FarmColumn36_Color,
	FarmColumn37_FarmID, FarmColumn37_Qty = convert(numeric(10,1), FarmColumn37_Qty / 1000.0), FarmColumn37_Visible, FarmColumn37_CellStyle, FarmColumn37_WorkPulletFarmPlanID, FarmColumn37_PulletFarmPlanID, FarmColumn37_Color,
	FarmColumn38_FarmID, FarmColumn38_Qty = convert(numeric(10,1), FarmColumn38_Qty / 1000.0), FarmColumn38_Visible, FarmColumn38_CellStyle, FarmColumn38_WorkPulletFarmPlanID, FarmColumn38_PulletFarmPlanID, FarmColumn38_Color,
	FarmColumn39_FarmID, FarmColumn39_Qty = convert(numeric(10,1), FarmColumn39_Qty / 1000.0), FarmColumn39_Visible, FarmColumn39_CellStyle, FarmColumn39_WorkPulletFarmPlanID, FarmColumn39_PulletFarmPlanID, FarmColumn39_Color,
	FarmColumn40_FarmID, FarmColumn40_Qty = convert(numeric(10,1), FarmColumn40_Qty / 1000.0), FarmColumn40_Visible, FarmColumn40_CellStyle, FarmColumn40_WorkPulletFarmPlanID, FarmColumn40_PulletFarmPlanID, FarmColumn40_Color,
	FarmColumn41_FarmID, FarmColumn41_Qty = convert(numeric(10,1), FarmColumn41_Qty / 1000.0), FarmColumn41_Visible, FarmColumn41_CellStyle, FarmColumn41_WorkPulletFarmPlanID, FarmColumn41_PulletFarmPlanID, FarmColumn41_Color,
	FarmColumn42_FarmID, FarmColumn42_Qty = convert(numeric(10,1), FarmColumn42_Qty / 1000.0), FarmColumn42_Visible, FarmColumn42_CellStyle, FarmColumn42_WorkPulletFarmPlanID, FarmColumn42_PulletFarmPlanID, FarmColumn42_Color,
	FarmColumn43_FarmID, FarmColumn43_Qty = convert(numeric(10,1), FarmColumn43_Qty / 1000.0), FarmColumn43_Visible, FarmColumn43_CellStyle, FarmColumn43_WorkPulletFarmPlanID, FarmColumn43_PulletFarmPlanID, FarmColumn43_Color,
	FarmColumn44_FarmID, FarmColumn44_Qty = convert(numeric(10,1), FarmColumn44_Qty / 1000.0), FarmColumn44_Visible, FarmColumn44_CellStyle, FarmColumn44_WorkPulletFarmPlanID, FarmColumn44_PulletFarmPlanID, FarmColumn44_Color,
	FarmColumn45_FarmID, FarmColumn45_Qty = convert(numeric(10,1), FarmColumn45_Qty / 1000.0), FarmColumn45_Visible, FarmColumn45_CellStyle, FarmColumn45_WorkPulletFarmPlanID, FarmColumn45_PulletFarmPlanID, FarmColumn45_Color,
	FarmColumn46_FarmID, FarmColumn46_Qty = convert(numeric(10,1), FarmColumn46_Qty / 1000.0), FarmColumn46_Visible, FarmColumn46_CellStyle, FarmColumn46_WorkPulletFarmPlanID, FarmColumn46_PulletFarmPlanID, FarmColumn46_Color,
	FarmColumn47_FarmID, FarmColumn47_Qty = convert(numeric(10,1), FarmColumn47_Qty / 1000.0), FarmColumn47_Visible, FarmColumn47_CellStyle, FarmColumn47_WorkPulletFarmPlanID, FarmColumn47_PulletFarmPlanID, FarmColumn47_Color,
	FarmColumn48_FarmID, FarmColumn48_Qty = convert(numeric(10,1), FarmColumn48_Qty / 1000.0), FarmColumn48_Visible, FarmColumn48_CellStyle, FarmColumn48_WorkPulletFarmPlanID, FarmColumn48_PulletFarmPlanID, FarmColumn48_Color,
	FarmColumn49_FarmID, FarmColumn49_Qty = convert(numeric(10,1), FarmColumn49_Qty / 1000.0), FarmColumn49_Visible, FarmColumn49_CellStyle, FarmColumn49_WorkPulletFarmPlanID, FarmColumn49_PulletFarmPlanID, FarmColumn49_Color,
	FarmColumn50_FarmID, FarmColumn50_Qty = convert(numeric(10,1), FarmColumn50_Qty / 1000.0), FarmColumn50_Visible, FarmColumn50_CellStyle, FarmColumn50_WorkPulletFarmPlanID, FarmColumn50_PulletFarmPlanID, FarmColumn50_Color
from #Data
order by WeekEndingDate

drop table #Data




GO
