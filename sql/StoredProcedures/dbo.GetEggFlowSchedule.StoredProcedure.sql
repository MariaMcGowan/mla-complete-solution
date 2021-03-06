DROP PROCEDURE IF EXISTS [dbo].[GetEggFlowSchedule]
GO

create proc [dbo].[GetEggFlowSchedule] @UserID varchar(255), @StartDate date, @EndDate date, @ContractTypeID int, @ShowFarms bit
--, @Edittable bit = 0
as

set nocount on

--declare @UserID varchar(255), @StartDate date, @EndDate date, @ContractTypeID int, @ShowFarms bit
--select @UserID = 'CARGAS\Maria McGowan', @StartDate = '02/11/2019', @EndDate = '08/11/2019', @ContractTypeID = '1', @ShowFarms = '1'

	declare @FarmID int
		, @FarmNumber varchar(6)
		, @FarmName varchar(100)
		, @FarmColor varchar(10)
		, @sql varchar(4000)
		, @LoopCounter int = 0
		--, @InnerLoopCounter int
		, @Date date
		, @MaxDate date
		--, @Yesterday date
		--, @SkipRestOfLoop bit = 0
		, @GoBackXDays int
		, @SetDate date
		, @CalcGoBackDays int
		, @MaxDaysToGoBack int = 10
		--, @CasesInCooler_Today int
		, @CasesInCooler_XDaysAgo int
		, @CasesSet_SumXDays int
		, @OldestEggAge int
		, @CasesFromDate date
		, @CasesToDate date
		, @CasesFromDate_text varchar(10)
		, @CasesToDate_text varchar(10)
		, @CoolerDate date
		, @CoolerDate_text varchar(10)
		, @FarmCol int = 0
		, @BuildingCol int = 0
		, @DestinationBuildingID int = 0
		, @BlankLoopID int = 0
		, @BlankStartDate date
		, @BlankEndDate date
		, @CoolerEndDate date
		, @LastCoolerLoadDate date
	--declare @EstimatedYield numeric(7,4)

	declare @EggsPerCase int = 360
	declare @TargetPercent numeric(4,2) = .02

	if @TargetPercent > 1
		select @TargetPercent = @TargetPercent / 100

	create table #Data
	(
		RowNumber int,
		StandardTemplateData bit default 1,
		Editable bit default 0,
		SetDate date,
		SetDate_Day varchar(2), 
		DeliveryDate date,
		LotNumbers varchar(200),
		CalcSettableEggs int,
		CalcSettableEggs_FromStandard int,
		CalcSellableEggs int,
		CalcSellableEggs_FromStandard int,
		OrderedEggs int,
		TargetEggs int, 
		EstimatedYield numeric(10,2),
		CalculatedYield numeric(10,2), 
		CasesSet numeric(10,2) default 0, 
		-- Note - Qty stands for the calculated embryo quantity
		EggsInMinusEggsOut int,
		ActualSetQty int default 0,
		CasesInCooler numeric(10,1),
		--CasesInCooler_IgnoreZeroOut numeric(10,1),
		EggLoss numeric(10,1),
		GainsLosses int, 
		GoBackXDays int,
		OldestEggAge numeric(10,1),
		CasesOfOldestEggAge numeric(10,1),
		FarmColumn01_Qty int, FarmColumn01_FarmID int, FarmColumn01_FarmNumber varchar(6), FarmColumn01_FarmName varchar(100), FarmColumn01_Week int, FarmColumn01_WeekNumber varchar(20), FarmColumn01_Visible bit DEFAULT 0, FarmColumn01_Color varchar(10), FarmColumn01_PulletFarmPlanDetailID int, FarmColumn01_ReservedForContract bit default 1, FarmColumn01_CellStyle varchar(50),  
		FarmColumn02_Qty int, FarmColumn02_FarmID int, FarmColumn02_FarmNumber varchar(6), FarmColumn02_FarmName varchar(100), FarmColumn02_Week int, FarmColumn02_WeekNumber varchar(20), FarmColumn02_Visible bit DEFAULT 0, FarmColumn02_Color varchar(10), FarmColumn02_PulletFarmPlanDetailID int, FarmColumn02_ReservedForContract bit default 1, FarmColumn02_CellStyle varchar(50),  
		FarmColumn03_Qty int, FarmColumn03_FarmID int, FarmColumn03_FarmNumber varchar(6), FarmColumn03_FarmName varchar(100), FarmColumn03_Week int, FarmColumn03_WeekNumber varchar(20), FarmColumn03_Visible bit DEFAULT 0, FarmColumn03_Color varchar(10), FarmColumn03_PulletFarmPlanDetailID int, FarmColumn03_ReservedForContract bit default 1, FarmColumn03_CellStyle varchar(50),  
		FarmColumn04_Qty int, FarmColumn04_FarmID int, FarmColumn04_FarmNumber varchar(6), FarmColumn04_FarmName varchar(100), FarmColumn04_Week int, FarmColumn04_WeekNumber varchar(20), FarmColumn04_Visible bit DEFAULT 0, FarmColumn04_Color varchar(10), FarmColumn04_PulletFarmPlanDetailID int, FarmColumn04_ReservedForContract bit default 1, FarmColumn04_CellStyle varchar(50),  
		FarmColumn05_Qty int, FarmColumn05_FarmID int, FarmColumn05_FarmNumber varchar(6), FarmColumn05_FarmName varchar(100), FarmColumn05_Week int, FarmColumn05_WeekNumber varchar(20), FarmColumn05_Visible bit DEFAULT 0, FarmColumn05_Color varchar(10), FarmColumn05_PulletFarmPlanDetailID int, FarmColumn05_ReservedForContract bit default 1, FarmColumn05_CellStyle varchar(50),  
		FarmColumn06_Qty int, FarmColumn06_FarmID int, FarmColumn06_FarmNumber varchar(6), FarmColumn06_FarmName varchar(100), FarmColumn06_Week int, FarmColumn06_WeekNumber varchar(20), FarmColumn06_Visible bit DEFAULT 0, FarmColumn06_Color varchar(10), FarmColumn06_PulletFarmPlanDetailID int, FarmColumn06_ReservedForContract bit default 1, FarmColumn06_CellStyle varchar(50),  
		FarmColumn07_Qty int, FarmColumn07_FarmID int, FarmColumn07_FarmNumber varchar(6), FarmColumn07_FarmName varchar(100), FarmColumn07_Week int, FarmColumn07_WeekNumber varchar(20), FarmColumn07_Visible bit DEFAULT 0, FarmColumn07_Color varchar(10), FarmColumn07_PulletFarmPlanDetailID int, FarmColumn07_ReservedForContract bit default 1, FarmColumn07_CellStyle varchar(50),  
		FarmColumn08_Qty int, FarmColumn08_FarmID int, FarmColumn08_FarmNumber varchar(6), FarmColumn08_FarmName varchar(100), FarmColumn08_Week int, FarmColumn08_WeekNumber varchar(20), FarmColumn08_Visible bit DEFAULT 0, FarmColumn08_Color varchar(10), FarmColumn08_PulletFarmPlanDetailID int, FarmColumn08_ReservedForContract bit default 1, FarmColumn08_CellStyle varchar(50),  
		FarmColumn09_Qty int, FarmColumn09_FarmID int, FarmColumn09_FarmNumber varchar(6), FarmColumn09_FarmName varchar(100), FarmColumn09_Week int, FarmColumn09_WeekNumber varchar(20), FarmColumn09_Visible bit DEFAULT 0, FarmColumn09_Color varchar(10), FarmColumn09_PulletFarmPlanDetailID int, FarmColumn09_ReservedForContract bit default 1, FarmColumn09_CellStyle varchar(50),  
		FarmColumn10_Qty int, FarmColumn10_FarmID int, FarmColumn10_FarmNumber varchar(6), FarmColumn10_FarmName varchar(100), FarmColumn10_Week int, FarmColumn10_WeekNumber varchar(20), FarmColumn10_Visible bit DEFAULT 0, FarmColumn10_Color varchar(10), FarmColumn10_PulletFarmPlanDetailID int, FarmColumn10_ReservedForContract bit default 1, FarmColumn10_CellStyle varchar(50),  
		FarmColumn11_Qty int, FarmColumn11_FarmID int, FarmColumn11_FarmNumber varchar(6), FarmColumn11_FarmName varchar(100), FarmColumn11_Week int, FarmColumn11_WeekNumber varchar(20), FarmColumn11_Visible bit DEFAULT 0, FarmColumn11_Color varchar(10), FarmColumn11_PulletFarmPlanDetailID int, FarmColumn11_ReservedForContract bit default 1, FarmColumn11_CellStyle varchar(50),  
		FarmColumn12_Qty int, FarmColumn12_FarmID int, FarmColumn12_FarmNumber varchar(6), FarmColumn12_FarmName varchar(100), FarmColumn12_Week int, FarmColumn12_WeekNumber varchar(20), FarmColumn12_Visible bit DEFAULT 0, FarmColumn12_Color varchar(10), FarmColumn12_PulletFarmPlanDetailID int, FarmColumn12_ReservedForContract bit default 1, FarmColumn12_CellStyle varchar(50),  
		FarmColumn13_Qty int, FarmColumn13_FarmID int, FarmColumn13_FarmNumber varchar(6), FarmColumn13_FarmName varchar(100), FarmColumn13_Week int, FarmColumn13_WeekNumber varchar(20), FarmColumn13_Visible bit DEFAULT 0, FarmColumn13_Color varchar(10), FarmColumn13_PulletFarmPlanDetailID int, FarmColumn13_ReservedForContract bit default 1, FarmColumn13_CellStyle varchar(50),  
		FarmColumn14_Qty int, FarmColumn14_FarmID int, FarmColumn14_FarmNumber varchar(6), FarmColumn14_FarmName varchar(100), FarmColumn14_Week int, FarmColumn14_WeekNumber varchar(20), FarmColumn14_Visible bit DEFAULT 0, FarmColumn14_Color varchar(10), FarmColumn14_PulletFarmPlanDetailID int, FarmColumn14_ReservedForContract bit default 1, FarmColumn14_CellStyle varchar(50),  
		FarmColumn15_Qty int, FarmColumn15_FarmID int, FarmColumn15_FarmNumber varchar(6), FarmColumn15_FarmName varchar(100), FarmColumn15_Week int, FarmColumn15_WeekNumber varchar(20), FarmColumn15_Visible bit DEFAULT 0, FarmColumn15_Color varchar(10), FarmColumn15_PulletFarmPlanDetailID int, FarmColumn15_ReservedForContract bit default 1, FarmColumn15_CellStyle varchar(50),  
		FarmColumn16_Qty int, FarmColumn16_FarmID int, FarmColumn16_FarmNumber varchar(6), FarmColumn16_FarmName varchar(100), FarmColumn16_Week int, FarmColumn16_WeekNumber varchar(20), FarmColumn16_Visible bit DEFAULT 0, FarmColumn16_Color varchar(10), FarmColumn16_PulletFarmPlanDetailID int, FarmColumn16_ReservedForContract bit default 1, FarmColumn16_CellStyle varchar(50),  
		FarmColumn17_Qty int, FarmColumn17_FarmID int, FarmColumn17_FarmNumber varchar(6), FarmColumn17_FarmName varchar(100), FarmColumn17_Week int, FarmColumn17_WeekNumber varchar(20), FarmColumn17_Visible bit DEFAULT 0, FarmColumn17_Color varchar(10), FarmColumn17_PulletFarmPlanDetailID int, FarmColumn17_ReservedForContract bit default 1, FarmColumn17_CellStyle varchar(50),  
		FarmColumn18_Qty int, FarmColumn18_FarmID int, FarmColumn18_FarmNumber varchar(6), FarmColumn18_FarmName varchar(100), FarmColumn18_Week int, FarmColumn18_WeekNumber varchar(20), FarmColumn18_Visible bit DEFAULT 0, FarmColumn18_Color varchar(10), FarmColumn18_PulletFarmPlanDetailID int, FarmColumn18_ReservedForContract bit default 1, FarmColumn18_CellStyle varchar(50),  
		FarmColumn19_Qty int, FarmColumn19_FarmID int, FarmColumn19_FarmNumber varchar(6), FarmColumn19_FarmName varchar(100), FarmColumn19_Week int, FarmColumn19_WeekNumber varchar(20), FarmColumn19_Visible bit DEFAULT 0, FarmColumn19_Color varchar(10), FarmColumn19_PulletFarmPlanDetailID int, FarmColumn19_ReservedForContract bit default 1, FarmColumn19_CellStyle varchar(50),  
		FarmColumn20_Qty int, FarmColumn20_FarmID int, FarmColumn20_FarmNumber varchar(6), FarmColumn20_FarmName varchar(100), FarmColumn20_Week int, FarmColumn20_WeekNumber varchar(20), FarmColumn20_Visible bit DEFAULT 0, FarmColumn20_Color varchar(10), FarmColumn20_PulletFarmPlanDetailID int, FarmColumn20_ReservedForContract bit default 1, FarmColumn20_CellStyle varchar(50),  
		FarmColumn21_Qty int, FarmColumn21_FarmID int, FarmColumn21_FarmNumber varchar(6), FarmColumn21_FarmName varchar(100), FarmColumn21_Week int, FarmColumn21_WeekNumber varchar(20), FarmColumn21_Visible bit DEFAULT 0, FarmColumn21_Color varchar(10), FarmColumn21_PulletFarmPlanDetailID int, FarmColumn21_ReservedForContract bit default 1, FarmColumn21_CellStyle varchar(50),  
		FarmColumn22_Qty int, FarmColumn22_FarmID int, FarmColumn22_FarmNumber varchar(6), FarmColumn22_FarmName varchar(100), FarmColumn22_Week int, FarmColumn22_WeekNumber varchar(20), FarmColumn22_Visible bit DEFAULT 0, FarmColumn22_Color varchar(10), FarmColumn22_PulletFarmPlanDetailID int, FarmColumn22_ReservedForContract bit default 1, FarmColumn22_CellStyle varchar(50),  
		FarmColumn23_Qty int, FarmColumn23_FarmID int, FarmColumn23_FarmNumber varchar(6), FarmColumn23_FarmName varchar(100), FarmColumn23_Week int, FarmColumn23_WeekNumber varchar(20), FarmColumn23_Visible bit DEFAULT 0, FarmColumn23_Color varchar(10), FarmColumn23_PulletFarmPlanDetailID int, FarmColumn23_ReservedForContract bit default 1, FarmColumn23_CellStyle varchar(50),  
		FarmColumn24_Qty int, FarmColumn24_FarmID int, FarmColumn24_FarmNumber varchar(6), FarmColumn24_FarmName varchar(100), FarmColumn24_Week int, FarmColumn24_WeekNumber varchar(20), FarmColumn24_Visible bit DEFAULT 0, FarmColumn24_Color varchar(10), FarmColumn24_PulletFarmPlanDetailID int, FarmColumn24_ReservedForContract bit default 1, FarmColumn24_CellStyle varchar(50),  
		FarmColumn25_Qty int, FarmColumn25_FarmID int, FarmColumn25_FarmNumber varchar(6), FarmColumn25_FarmName varchar(100), FarmColumn25_Week int, FarmColumn25_WeekNumber varchar(20), FarmColumn25_Visible bit DEFAULT 0, FarmColumn25_Color varchar(10), FarmColumn25_PulletFarmPlanDetailID int, FarmColumn25_ReservedForContract bit default 1, FarmColumn25_CellStyle varchar(50),  
		FarmColumn26_Qty int, FarmColumn26_FarmID int, FarmColumn26_FarmNumber varchar(6), FarmColumn26_FarmName varchar(100), FarmColumn26_Week int, FarmColumn26_WeekNumber varchar(20), FarmColumn26_Visible bit DEFAULT 0, FarmColumn26_Color varchar(10), FarmColumn26_PulletFarmPlanDetailID int, FarmColumn26_ReservedForContract bit default 1, FarmColumn26_CellStyle varchar(50),  
		FarmColumn27_Qty int, FarmColumn27_FarmID int, FarmColumn27_FarmNumber varchar(6), FarmColumn27_FarmName varchar(100), FarmColumn27_Week int, FarmColumn27_WeekNumber varchar(20), FarmColumn27_Visible bit DEFAULT 0, FarmColumn27_Color varchar(10), FarmColumn27_PulletFarmPlanDetailID int, FarmColumn27_ReservedForContract bit default 1, FarmColumn27_CellStyle varchar(50),  
		FarmColumn28_Qty int, FarmColumn28_FarmID int, FarmColumn28_FarmNumber varchar(6), FarmColumn28_FarmName varchar(100), FarmColumn28_Week int, FarmColumn28_WeekNumber varchar(20), FarmColumn28_Visible bit DEFAULT 0, FarmColumn28_Color varchar(10), FarmColumn28_PulletFarmPlanDetailID int, FarmColumn28_ReservedForContract bit default 1, FarmColumn28_CellStyle varchar(50),  
		FarmColumn29_Qty int, FarmColumn29_FarmID int, FarmColumn29_FarmNumber varchar(6), FarmColumn29_FarmName varchar(100), FarmColumn29_Week int, FarmColumn29_WeekNumber varchar(20), FarmColumn29_Visible bit DEFAULT 0, FarmColumn29_Color varchar(10), FarmColumn29_PulletFarmPlanDetailID int, FarmColumn29_ReservedForContract bit default 1, FarmColumn29_CellStyle varchar(50),  
		FarmColumn30_Qty int, FarmColumn30_FarmID int, FarmColumn30_FarmNumber varchar(6), FarmColumn30_FarmName varchar(100), FarmColumn30_Week int, FarmColumn30_WeekNumber varchar(20), FarmColumn30_Visible bit DEFAULT 0, FarmColumn30_Color varchar(10), FarmColumn30_PulletFarmPlanDetailID int, FarmColumn30_ReservedForContract bit default 1, FarmColumn30_CellStyle varchar(50),
		
		FarmColumn31_Qty int, FarmColumn31_FarmID int, FarmColumn31_FarmNumber varchar(6), FarmColumn31_FarmName varchar(100), FarmColumn31_Week int, FarmColumn31_WeekNumber varchar(20), FarmColumn31_Visible bit DEFAULT 0, FarmColumn31_Color varchar(10), FarmColumn31_PulletFarmPlanDetailID int, FarmColumn31_ReservedForContract bit default 1, FarmColumn31_CellStyle varchar(50),  
		FarmColumn32_Qty int, FarmColumn32_FarmID int, FarmColumn32_FarmNumber varchar(6), FarmColumn32_FarmName varchar(100), FarmColumn32_Week int, FarmColumn32_WeekNumber varchar(20), FarmColumn32_Visible bit DEFAULT 0, FarmColumn32_Color varchar(10), FarmColumn32_PulletFarmPlanDetailID int, FarmColumn32_ReservedForContract bit default 1, FarmColumn32_CellStyle varchar(50),  
		FarmColumn33_Qty int, FarmColumn33_FarmID int, FarmColumn33_FarmNumber varchar(6), FarmColumn33_FarmName varchar(100), FarmColumn33_Week int, FarmColumn33_WeekNumber varchar(20), FarmColumn33_Visible bit DEFAULT 0, FarmColumn33_Color varchar(10), FarmColumn33_PulletFarmPlanDetailID int, FarmColumn33_ReservedForContract bit default 1, FarmColumn33_CellStyle varchar(50),  
		FarmColumn34_Qty int, FarmColumn34_FarmID int, FarmColumn34_FarmNumber varchar(6), FarmColumn34_FarmName varchar(100), FarmColumn34_Week int, FarmColumn34_WeekNumber varchar(20), FarmColumn34_Visible bit DEFAULT 0, FarmColumn34_Color varchar(10), FarmColumn34_PulletFarmPlanDetailID int, FarmColumn34_ReservedForContract bit default 1, FarmColumn34_CellStyle varchar(50),  
		FarmColumn35_Qty int, FarmColumn35_FarmID int, FarmColumn35_FarmNumber varchar(6), FarmColumn35_FarmName varchar(100), FarmColumn35_Week int, FarmColumn35_WeekNumber varchar(20), FarmColumn35_Visible bit DEFAULT 0, FarmColumn35_Color varchar(10), FarmColumn35_PulletFarmPlanDetailID int, FarmColumn35_ReservedForContract bit default 1, FarmColumn35_CellStyle varchar(50),  
		FarmColumn36_Qty int, FarmColumn36_FarmID int, FarmColumn36_FarmNumber varchar(6), FarmColumn36_FarmName varchar(100), FarmColumn36_Week int, FarmColumn36_WeekNumber varchar(20), FarmColumn36_Visible bit DEFAULT 0, FarmColumn36_Color varchar(10), FarmColumn36_PulletFarmPlanDetailID int, FarmColumn36_ReservedForContract bit default 1, FarmColumn36_CellStyle varchar(50),  
		FarmColumn37_Qty int, FarmColumn37_FarmID int, FarmColumn37_FarmNumber varchar(6), FarmColumn37_FarmName varchar(100), FarmColumn37_Week int, FarmColumn37_WeekNumber varchar(20), FarmColumn37_Visible bit DEFAULT 0, FarmColumn37_Color varchar(10), FarmColumn37_PulletFarmPlanDetailID int, FarmColumn37_ReservedForContract bit default 1, FarmColumn37_CellStyle varchar(50),  
		FarmColumn38_Qty int, FarmColumn38_FarmID int, FarmColumn38_FarmNumber varchar(6), FarmColumn38_FarmName varchar(100), FarmColumn38_Week int, FarmColumn38_WeekNumber varchar(20), FarmColumn38_Visible bit DEFAULT 0, FarmColumn38_Color varchar(10), FarmColumn38_PulletFarmPlanDetailID int, FarmColumn38_ReservedForContract bit default 1, FarmColumn38_CellStyle varchar(50),  
		FarmColumn39_Qty int, FarmColumn39_FarmID int, FarmColumn39_FarmNumber varchar(6), FarmColumn39_FarmName varchar(100), FarmColumn39_Week int, FarmColumn39_WeekNumber varchar(20), FarmColumn39_Visible bit DEFAULT 0, FarmColumn39_Color varchar(10), FarmColumn39_PulletFarmPlanDetailID int, FarmColumn39_ReservedForContract bit default 1, FarmColumn39_CellStyle varchar(50),  
		FarmColumn40_Qty int, FarmColumn40_FarmID int, FarmColumn40_FarmNumber varchar(6), FarmColumn40_FarmName varchar(100), FarmColumn40_Week int, FarmColumn40_WeekNumber varchar(20), FarmColumn40_Visible bit DEFAULT 0, FarmColumn40_Color varchar(10), FarmColumn40_PulletFarmPlanDetailID int, FarmColumn40_ReservedForContract bit default 1, FarmColumn40_CellStyle varchar(50),  
		FarmColumn41_Qty int, FarmColumn41_FarmID int, FarmColumn41_FarmNumber varchar(6), FarmColumn41_FarmName varchar(100), FarmColumn41_Week int, FarmColumn41_WeekNumber varchar(20), FarmColumn41_Visible bit DEFAULT 0, FarmColumn41_Color varchar(10), FarmColumn41_PulletFarmPlanDetailID int, FarmColumn41_ReservedForContract bit default 1, FarmColumn41_CellStyle varchar(50),  
		FarmColumn42_Qty int, FarmColumn42_FarmID int, FarmColumn42_FarmNumber varchar(6), FarmColumn42_FarmName varchar(100), FarmColumn42_Week int, FarmColumn42_WeekNumber varchar(20), FarmColumn42_Visible bit DEFAULT 0, FarmColumn42_Color varchar(10), FarmColumn42_PulletFarmPlanDetailID int, FarmColumn42_ReservedForContract bit default 1, FarmColumn42_CellStyle varchar(50),  
		FarmColumn43_Qty int, FarmColumn43_FarmID int, FarmColumn43_FarmNumber varchar(6), FarmColumn43_FarmName varchar(100), FarmColumn43_Week int, FarmColumn43_WeekNumber varchar(20), FarmColumn43_Visible bit DEFAULT 0, FarmColumn43_Color varchar(10), FarmColumn43_PulletFarmPlanDetailID int, FarmColumn43_ReservedForContract bit default 1, FarmColumn43_CellStyle varchar(50),  
		FarmColumn44_Qty int, FarmColumn44_FarmID int, FarmColumn44_FarmNumber varchar(6), FarmColumn44_FarmName varchar(100), FarmColumn44_Week int, FarmColumn44_WeekNumber varchar(20), FarmColumn44_Visible bit DEFAULT 0, FarmColumn44_Color varchar(10), FarmColumn44_PulletFarmPlanDetailID int, FarmColumn44_ReservedForContract bit default 1, FarmColumn44_CellStyle varchar(50),  
		FarmColumn45_Qty int, FarmColumn45_FarmID int, FarmColumn45_FarmNumber varchar(6), FarmColumn45_FarmName varchar(100), FarmColumn45_Week int, FarmColumn45_WeekNumber varchar(20), FarmColumn45_Visible bit DEFAULT 0, FarmColumn45_Color varchar(10), FarmColumn45_PulletFarmPlanDetailID int, FarmColumn45_ReservedForContract bit default 1, FarmColumn45_CellStyle varchar(50),  
		FarmColumn46_Qty int, FarmColumn46_FarmID int, FarmColumn46_FarmNumber varchar(6), FarmColumn46_FarmName varchar(100), FarmColumn46_Week int, FarmColumn46_WeekNumber varchar(20), FarmColumn46_Visible bit DEFAULT 0, FarmColumn46_Color varchar(10), FarmColumn46_PulletFarmPlanDetailID int, FarmColumn46_ReservedForContract bit default 1, FarmColumn46_CellStyle varchar(50),  
		FarmColumn47_Qty int, FarmColumn47_FarmID int, FarmColumn47_FarmNumber varchar(6), FarmColumn47_FarmName varchar(100), FarmColumn47_Week int, FarmColumn47_WeekNumber varchar(20), FarmColumn47_Visible bit DEFAULT 0, FarmColumn47_Color varchar(10), FarmColumn47_PulletFarmPlanDetailID int, FarmColumn47_ReservedForContract bit default 1, FarmColumn47_CellStyle varchar(50),  
		FarmColumn48_Qty int, FarmColumn48_FarmID int, FarmColumn48_FarmNumber varchar(6), FarmColumn48_FarmName varchar(100), FarmColumn48_Week int, FarmColumn48_WeekNumber varchar(20), FarmColumn48_Visible bit DEFAULT 0, FarmColumn48_Color varchar(10), FarmColumn48_PulletFarmPlanDetailID int, FarmColumn48_ReservedForContract bit default 1, FarmColumn48_CellStyle varchar(50),  
		FarmColumn49_Qty int, FarmColumn49_FarmID int, FarmColumn49_FarmNumber varchar(6), FarmColumn49_FarmName varchar(100), FarmColumn49_Week int, FarmColumn49_WeekNumber varchar(20), FarmColumn49_Visible bit DEFAULT 0, FarmColumn49_Color varchar(10), FarmColumn49_PulletFarmPlanDetailID int, FarmColumn49_ReservedForContract bit default 1, FarmColumn49_CellStyle varchar(50),  
		FarmColumn50_Qty int, FarmColumn50_FarmID int, FarmColumn50_FarmNumber varchar(6), FarmColumn50_FarmName varchar(100), FarmColumn50_Week int, FarmColumn50_WeekNumber varchar(20), FarmColumn50_Visible bit DEFAULT 0, FarmColumn50_Color varchar(10), FarmColumn50_PulletFarmPlanDetailID int, FarmColumn50_ReservedForContract bit default 1, FarmColumn50_CellStyle varchar(50),  

		BuildingColumn01_Qty int, BuildingColumn01_DestinationBuildingID int, BuildingColumn01_Visible bit DEFAULT 0,
		BuildingColumn02_Qty int, BuildingColumn02_DestinationBuildingID int, BuildingColumn02_Visible bit DEFAULT 0,
		BuildingColumn03_Qty int, BuildingColumn03_DestinationBuildingID int, BuildingColumn03_Visible bit DEFAULT 0,
		BuildingColumn04_Qty int, BuildingColumn04_DestinationBuildingID int, BuildingColumn04_Visible bit DEFAULT 0,
		BuildingColumn05_Qty int, BuildingColumn05_DestinationBuildingID int, BuildingColumn05_Visible bit DEFAULT 0,
		BuildingColumn06_Qty int, BuildingColumn06_DestinationBuildingID int, BuildingColumn06_Visible bit DEFAULT 0,
		BuildingColumn07_Qty int, BuildingColumn07_DestinationBuildingID int, BuildingColumn07_Visible bit DEFAULT 0,
		BuildingColumn08_Qty int, BuildingColumn08_DestinationBuildingID int, BuildingColumn08_Visible bit DEFAULT 0,
		FarmPickupQty numeric(10,1),
		NegativeCoolerChangeQty numeric(10,1)
	)

	declare @FarmList table (FarmColumn int, FarmID int, FarmName varchar(100), FarmNumber varchar(6))
	insert into @FarmList
	exec HatcheryRecords_Get_FarmList

	create table #BuildingList (DestinationBuildingColumn int identity(0,1), DestinationBuildingID int, DestinationBuilding varchar(50), DefaultContractTypeID int)
	insert into #BuildingList (DestinationBuildingID, DestinationBuilding, DefaultContractTypeID)
	exec HatcheryRecords_Get_BuildingList @DefaultContractTypeID = @ContractTypeID
	

	create table #OrdersByBuilding (DestinationBuildingID int, SetDate date, DeliveryDate date, PlannedQty int, ProjectedOrder bit default 0)
	--declare #OrdersByBuilding table (DestinationBuildingID int, SetDate date, DeliveryDate date, PlannedQty int)
	declare @LotNumbers table (SetDate date, DeliveryDate date, LotNumbers varchar(100))
	declare @EggsInCooler table (Date date, EggsInCooler int, CasesInCooler numeric(10,1))

	select @CoolerEndDate =  dateadd(day,-1,convert(date,getdate()))
	insert into @EggsInCooler (Date, EggsInCooler, CasesInCooler)
	select Date, EggCount,  EggCount / (@EggsPerCase * 1.0)
	from dbo.CoolerInventoryByDate(dateadd(week,-2,@StartDate),@CoolerEndDate)

	-- Pull in order data
	insert into #OrdersByBuilding (DestinationBuildingID, SetDate, DeliveryDate, PlannedQty, ProjectedOrder)
	select DestinationBuildingID, SetDate, DeliveryDate, sum(o.PlannedQty),ProjectedOrder
	from RollingPlannedOrders o
	where ContractTypeID = @ContractTypeID and isnull(o.CustomIncubation,0) = 0
	and SetDate between @StartDate and @EndDate
	group by DestinationBuildingID, SetDate, DeliveryDate, ProjectedOrder

	insert into #OrdersByBuilding (DestinationBuildingID, SetDate, DeliveryDate, PlannedQty, ProjectedOrder)
	select 9999, SetDate, DeliveryDate, sum(o.PlannedQty), ProjectedOrder
	from RollingPlannedOrders o
	where ContractTypeID = @ContractTypeID and isnull(o.CustomIncubation,0) = 1
	and SetDate between @StartDate and @EndDate
	group by DestinationBuildingID, SetDate, DeliveryDate, ProjectedOrder

	-- Pull in LotNumbers
	insert into @LotNumbers (SetDate, DeliveryDate, LotNumbers)
	select SetDate, DeliveryDate, LotNumbers = 
		STUFF((
				Select  N', ' + LotNbr 
				from RollingPlannedOrders 
				where SetDate = o.SetDate and DeliveryDate = o.DeliveryDate 
				group by LotNbr
				order by LotNbr
				FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N'')
	from RollingPlannedOrders o
	where SetDate between @StartDate and @EndDate
	group by SetDate, DeliveryDate
	order by SetDate, DeliveryDate

	
	;With DateSequence( Date ) as
	(
		Select dateadd(day, -10, @StartDate) as Date
			union all
		Select dateadd(day, 1, Date)
			from DateSequence
			where Date < @EndDate
	)

	insert into #Data (SetDate, SetDate_Day, DeliveryDate)
	select Date, 	
	SetDate_Day = 
	case
		when left(datename(dw,Date),2) = 'Th' then 'Th'
		when left(datename(dw,Date),2) = 'Su' then 'Su'
		else left(datename(dw,Date),1)
	end,
	dateadd(day,12, Date)
	from DateSequence
	OPTION (MAXRECURSION 32747)

	-- Let's pull in the FarmPickupQty
	-- This is column is not farm specific
	update d set d.FarmPickupQty = h.FarmPickupQty --/ (@EggsPerCase * 1.0)	-- Convert to cases, note - we will convert to cases later (after the other calculations based on eaches)
	from #Data d
	inner join HatcheryRecord h on d.SetDate = h.Date and h.ContractTypeID = @ContractTypeID

	-- Are there any SetDate / DeliveryDate combinations that are contain orders that are not in the #Data table?
	-- If so, add them in!
	insert into #Data (SetDate, DeliveryDate, StandardTemplateData)
	select SetDate, DeliveryDate, 0
	from RollingPlannedOrders o
	where SetDate between @StartDate and @EndDate
	and DeliveryDate is not null
	and not exists (select 1 from #Data where SetDate = o.SetDate and DeliveryDate = o.DeliveryDate)
	group by SetDate, DeliveryDate

	-- Set the row numbers
	update d set d.RowNumber = r.RowNumber
	from #Data d
	inner join 
	(
		select SetDate, DeliveryDate, RowNumber = Row_Number() over (order by SetDate, DeliveryDate) 
		from #Data
	) r on d.SetDate = r.SetDate and d.DeliveryDate = r.DeliveryDate

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

	if @ShowFarms = 1
	begin
		while @LoopCounter < 50
		begin
			select @LoopCounter = @LoopCounter + 1
			select @FarmCol = @LoopCounter - 1

			select @FarmID = null

			select @FarmID = FarmID from @FarmList where FarmColumn = @FarmCol
			select @FarmColor = isnull(pc.PlanningColor, 'White'), @FarmName = Farm, @FarmNumber = FarmNumber 
			from Farm f
			left outer join PlanningColor pc on f.PlanningColorID = pc.PlanningColorID
			where FarmID = @FarmID

			if @FarmID is not null
			begin
				select @LastCoolerLoadDate= isnull(max(convert(date, QtyChangeActualDate)), '01/01/2000')
				from EggTransaction et
				inner join Clutch c on et.ClutchID = c.CLutchID
				inner join Flock fl on c.FlockID = fl.FlockID
				where QtyChangeReasonID = 2 and FarmID = @FarmID


				-- First pull in actuals from the cooler load
				select @SQL = 
				'update e set 
				e.FarmColumn{NN}_Qty = d.TotalReceivedEggs		
				from #Data e
				inner join 
				(
					select FarmID, convert(date, QtyChangeActualDate) as ReceivedDate, sum(QtyChange) as TotalReceivedEggs
					from EggTransaction et
					inner join Clutch c on et.ClutchID = c.CLutchID
					inner join Flock fl on c.FlockID = fl.FlockID
					where QtyChangeReasonID = 2
					and convert(date, QtyChangeActualDate) >= @StartDate
					and FarmID = @FarmID
					group by FarmID, convert(date, QtyChangeActualDate)
				) d on e.SetDate = d.ReceivedDate
				where StandardTemplateData = 1'
				
				select @SQL = replace(@SQL, '@FarmID', convert(varchar(4), @FarmID))
				select @SQL = replace(@SQL, '@ContractTypeID', convert(varchar(4), @ContractTypeID))
				select @SQL = replace(@SQL, '@FarmColor', @FarmColor)
				select @SQL = replace(@SQL, '@StartDate', '''' + convert(varchar(20), @StartDate, 101) + '''')
				select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
				execute (@SQL)

				-- Pull in the rest from the standard template plan
				select @SQL = 
				'update e set 
				e.FarmColumn{NN}_Color = ''@FarmColor'',
				e.FarmColumn{NN}_Qty = 
					case
						when d.Date > @LastCoolerLoadDate then d.SettableEggs
						else isnull(e.FarmColumn{NN}_Qty,0)
					end,
				e.FarmColumn{NN}_PulletFarmPlanDetailID = d.PulletFarmPlanDetailID,
				e.FarmColumn{NN}_FarmID = @FarmID,
				e.FarmColumn{NN}_Week = d.WeekNumber
				from #Data e
				inner join 
					(
						select Date, SettableEggs, PulletFarmPlanDetailID, WeekNumber
						from RollingDailySchedule s
						where Date >= @StartDate
						and SettableEggs is not null
						and FarmID = @FarmID
						and ContractTypeID = @ContractTypeID
						and SettableEggs > 0
					) d on e.SetDate = d.Date
				where StandardTemplateData = 1'
				
				select @SQL = replace(@SQL, '@FarmID', convert(varchar(4), @FarmID))
				select @SQL = replace(@SQL, '@ContractTypeID', convert(varchar(4), @ContractTypeID))
				select @SQL = replace(@SQL, '@FarmColor', @FarmColor)
				select @SQL = replace(@SQL, '@StartDate', '''' + convert(varchar(20), @StartDate, 101) + '''')
				select @SQL = replace(@SQL, '@LastCoolerLoadDate', '''' + convert(varchar(20), @LastCoolerLoadDate, 101) + '''')
				select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
				
				execute (@SQL)

				-- Update Visible and FarmID
				select @SQL = 'update #Data set FarmColumn{NN}_Visible = 1, FarmColumn{NN}_FarmID = @FarmID, 
				FarmColumn{NN}_FarmName = ''@FarmName'', FarmColumn{NN}_FarmNumber = ''@FarmNumber'', 
				FarmColumn{NN}_WeekNumber = ''Wk # '' + convert(varchar(2), FarmColumn{NN}_Week)'
				select @SQL = replace(@SQL, '@FarmID', convert(varchar(4), @FarmID))
				select @SQL = replace(@SQL, '@FarmName', convert(varchar(4), @FarmName))
				select @SQL = replace(@SQL, '@FarmNumber', convert(varchar(4), @FarmNumber))
				select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))

				execute (@SQL)

				-- Only show flocks / farms that have flock plans 
				select @SQL = 'if not exists (select 1 from #Data where FarmColumn{NN}_PulletFarmPlanDetailID is not null)
									update #Data set FarmColumn{NN}_Visible = 0'
				
				select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))

				execute (@SQL)

			end
		end
	end

	-- Update Egg Loss
	update ps set ps.EggLoss = d.EggLoss
	from #Data ps
	inner join 
	(
		select convert(date, QtyChangeActualDate) as ReceivedDate, sum(QtyChange) as EggLoss
		from EggTransaction et
		where QtyChangeReasonID in (4, 5) -- Breakage and Defect
		and convert(date, QtyChangeActualDate) >= @StartDate
		group by convert(date, QtyChangeActualDate)
	) d on ps.SetDate = d.ReceivedDate


	update ps set ps.CalcSettableEggs = ws.CalcSettableEggs, 
	ps.CalcSettableEggs_FromStandard = ws.CalcSettableEggs_FromStandard,
	ps.CalcSellableEggs = ws.CalcSellableEggs,
	ps.CalcSellableEggs_FromStandard = ws.CalcSellableEggs_FromStandard
	from #Data ps
	left outer join 
	(
		select Date, sum(SettableEggs) as CalcSettableEggs, 
		sum(SettableEggs_FromStandards) as CalcSettableEggs_FromStandard,
		sum(SellableEggs) as CalcSellableEggs,
		sum(SellableEggs_FromStandards) as CalcSellableEggs_FromStandard
		from RollingDailySchedule pfpd
		where ContractTypeID = @ContractTypeID 
		and exists (select 1 from #Data where Date = pfpd.Date)
		group by Date
	) ws on ps.SetDate = ws.Date
	where ps.StandardTemplateData = 1

	update #Data set 
		CalcSettableEggs = 0, 
		CalcSettableEggs_FromStandard = 0,
		CalcSellableEggs = 0, 
		CalcSellableEggs_FromStandard = 0
	where StandardTemplateData = 0

	---- Are there any SetDate / DeliveryDate combinations that are contain orders that are not in the #Data table?
	---- If so, add them in!
	--insert into #Data (SetDate, DeliveryDate)
	--select PlannedSetDate, DeliveryDate
	--from [Order] o
	--where PlannedSetDate between @StartDate and @EndDate
	--and not exists (select 1 from #Data where SetDate = o.PlannedSetDate and DeliveryDate = o.DeliveryDate)
	--group by PlannedSetDate, DeliveryDate

	update ps set ps.ActualSetQty = s.ActualSetQty
	from #Data ps
	inner join 
	(
		select o.SetDate as SetDate, o.DeliveryDate, sum(lpd.FlockQty) as ActualSetQty
		from RollingPlannedOrders o
		inner join LoadPlanning lp on o.LoadPlanningID = lp.LoadPlanningID
		inner join LoadPLanning_Detail lpd on lp.LoadPlanningID = lpd.LoadPlanningID
		where ContractTypeID = @ContractTypeID 
		and o.SetDate between @StartDate and @EndDate
		group by o.SetDate, o.DeliveryDate
	) s on ps.SetDate = s.SetDate and ps.DeliveryDate = s.DeliveryDate

	update ps set ps.OrderedEggs = Orders.PlannedQty
	from #Data ps
	inner join 
	(
		SELECT
			O.SetDate
			, O.DeliveryDate
			,sum(O.PlannedQty) as PlannedQty
		FROM RollingPlannedOrders O
		where ContractTypeID = @ContractTypeID 
		GROUP BY O.SetDate, O.DeliveryDate
	) Orders on ps.SetDate = Orders.SetDate and ps.DeliveryDate = Orders.DeliveryDate

	
	-- If Corey did not override it, then use the calculation from the standard
	update #Data set
		TargetEggs = round(OrderedEggs * (1 + @TargetPercent), 0),
		EstimatedYield = 
			case
				when CalcSettableEggs_FromStandard = 0 then 0
				else CalcSellableEggs_FromStandard / (CalcSettableEggs_FromStandard * 1.0000)
			end,
		CalculatedYield =
			case 
				when CalcSettableEggs = 0 then 0
				--else isnull(nullif(EstimatedYield,0), CalcSellableEggs / (CalcSettableEggs * 1.0000))
				-- changed by mcm on 03/07/2020
				else CalcSellableEggs / (CalcSettableEggs * 1.0000)
			end

		update d set d.EstimatedYield = (select EstimatedYield from #Data where StandardTemplateData = 1 and SetDate = d.SetDate)
		from #Data d 
		where d.StandardTemplateData = 0

		-- This is overwriting the estimated yield with Corey's override
		update d set d.EstimatedYield = pfpd.OverwrittenEstimatedYield
		from #Data d
		inner join PulletFarmPlanDetail pfpd on d.SetDate = pfpd.Date
		where pfpd.OverwrittenEstimatedYield is not null
		and pfpd.OverwrittenEstimatedYield > 0

	-- This assumes the standard calculation
	update #Data set 
		--CasesSet = (TargetEggs * EstimatedYield) / (@EggsPerCase * 1.00)
		CasesSet = 
			case
				when EstimatedYield = 0 then 0
				else round(TargetEggs / EstimatedYield / (@EggsPerCase * 1.00),1)
			end

	-- for anything that is in the past, update the following:
	--		cases set with Load Planning Detail Quantity
	--		calculated yield from load planning detail
	update d set 
		d.CasesSet = round(lpd.EggsSet / (@EggsPerCase * 1.0),1),
		d.CalculatedYield = round(lpd.CaclulatedExpectedYield,1)
	from #Data d
	inner join 
	(
		select SetDate, DeliveryDate, 
		EggsSet = sum(FlockQty),
		--ProjectedOutcome = sum(flockQty * LastCandleoutPercent/100),
		CaclulatedExpectedYield = sum(flockQty * LastCandleoutPercent/100) / sum(FlockQty)
		from LoadPlanning lp
		inner join LoadPLanning_Detail lpd on lp.LoadPlanningID = lpd.LoadPlanningID
		--where lp.LoadPlanningID = 2236
		group by SetDate, DeliveryDate
	) lpd on d.SetDate = lpd.SetDate and d.DeliveryDate = lpd.DeliveryDate

	-- Update building columns
	select @LoopCounter = 0

	while @LoopCounter < 8
	begin
		select @LoopCounter = @LoopCounter + 1
		select @BuildingCol = @LoopCounter - 1
		
		select @DestinationBuildingID = null

		select @DestinationBuildingID = DestinationBuildingID from #BuildingList where DestinationBuildingColumn = @BuildingCol

		if @DestinationBuildingID is not null
		begin
			select @SQL = 
			'update e set 
			e.BuildingColumn{NN}_Qty = d.PlannedQty, 
			e.BuildingColumn{NN}_DestinationBuildingID = @DestinationBuildingID
			from #Data e
			inner join 
				(
					select SetDate, DeliveryDate, sum(PlannedQty) as PlannedQty
					from #OrdersByBuilding
					where DestinationBuildingID = @DestinationBuildingID
					group by SetDate, DeliveryDate
				) d on e.SetDate = d.SetDate and e.DeliveryDate = d.DeliveryDate'
				

			select @SQL = replace(@SQL, '@DestinationBuildingID', convert(varchar(4), @DestinationBuildingID))
			select @SQL = replace(@SQL, '@ContractTypeID', convert(varchar(4), @ContractTypeID))
			select @SQL = replace(@SQL, '@StartDate', '''' + convert(varchar(20), @StartDate, 101) + '''')
			select @SQL = replace(@SQL, '@EndDate', '''' + convert(varchar(20), @EndDate, 101) + '''')
			select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
			execute (@SQL)

			-- Update Visible and FarmID
			select @SQL = 'update #Data set BuildingColumn{NN}_Visible = 1, BuildingColumn{NN}_DestinationBuildingID = @DestinationBuildingID'
			select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
			select @SQL = replace(@SQL, '@DestinationBuildingID', convert(varchar(4), @DestinationBuildingID))
			--print @SQL
			execute (@SQL)

		end
	end

	update e set e.LotNumbers = l.LotNumbers
	from #Data e
	inner join @LotNumbers l on e.SetDate = l.SetDate and e.DeliveryDate = l.DeliveryDate

	-- Update cases in the cooler based on the planned eggs in and eggs out
	update #Data set EggsInMinusEggsOut = isnull(CalcSettableEggs,0) - (isnull(CasesSet,0) * @EggsPerCase)
	--update #Data set EggsInMinusEggsOut = isnull(CalcSettableEggs,0) - isnull(CasesSet,0)		-- Changed by MCM on 3/11/2019
	--update d set d.CasesInCooler = (RunningTotal + FarmPickupQty) / (@EggsPerCase * 1.0)		-- Changed by MCM on 2/7/2019


	update d set d.CasesInCooler = (RunningTotal + isnull(FarmPickupQty,0) + isnull(EggLoss,0)) / (@EggsPerCase * 1.0)
	from #Data d
	inner join 
	(
		select RowNumber, RunningTotal = sum(EggsInMinusEggsOut) OVER (order by RowNumber)
		from #Data
	) rt on d.RowNumber = rt.RowNumber

	-- Now, update cases in cooler to actuals for everything in the past and present
	update d set d.CasesInCooler = c.CasesInCooler  + (FarmPickupQty / (@EggsPerCase * 1.0))
	from #Data d
	inner join @EggsInCooler c on d.SetDate = c.Date

	-- Update Gains / Losses
	update a set a.GainsLosses = isnull(a.CasesInCooler,0) - isnull(b.CasesInCooler, 0)
	from #Data a
	inner join #Data b on a.SetDate = dateadd(week,1,b.SetDate)
	where datename(weekday, a.SetDate) = 'Friday'

	-- Add in logic to "ZERO" out the cooler
	--update #Data set CasesInCooler_IgnoreZeroOut = CasesInCooler

	declare @Zero table (SetDate date)
	insert into @Zero (SetDate)
	select SetDate
	from #Data d
	inner join HatcheryRecord h on d.SetDate = h.Date and h.ContractTypeID = @ContractTypeID
	where isnull(ZeroOutCooler,0) = 1
	and StandardTemplateData = 1

	declare @ZeroCases numeric(10,1)
	declare @ZeroDate date


	while exists (select 1 from @Zero)
	begin
		select top 1 @ZeroDate = SetDate from @Zero
		select @ZeroCases = CasesInCooler from #Data where setDate = @ZeroDate
		update #Data set CasesInCooler = CasesInCooler - @ZeroCases where SetDate >= @ZeroDate
		delete from @Zero where SetDate = @ZeroDate
	end

	-- Oldest Egg Calculation
	declare @WorkID int 
	insert into Work(WorkDateTime, UserName)
	select getdate(), @UserID

	select @WorkID = SCOPE_IDENTITY()

	insert into WorkData (WorkID, RowNumber, SetDate, DeliveryDate, CasesInCooler, CasesSet, StandardTemplateData, CalcSettableEggs, CalcSettableEggs_Cases)
	select @WorkID, RowNumber, SetDate, DeliveryDate, CasesInCooler, CasesSet, StandardTemplateData, CalcSettableEggs, CalcSettableEggs / (@EggsPerCase * 1.0)
	from #Data

	-- First determine the maximum number of days to go back for each set date
	update WorkData 
		set MaxGoBackXDays = dbo.OldAge_CalcMaxDayCount(SetDate, @WorkID)
	where WorkID = @WorkID and StandardTemplateData = 1

	-- Now do the calculations
	while exists (select 1 from WorkData where WorkID = @WorkID and Processed = 0 and StandardTemplateData = 1)
	begin
		select top 1 @SetDate = SetDate, @GoBackXDays = MaxGoBackXDays
		from WorkData
		where WorkID = @WorkID and StandardTemplateData = 1 and Processed = 0
		order by SetDate
	
		execute dbo.OldAge_Calculations @SetDate, @GoBackXDays, @WorkID

		update WorkData set CasesOldestEggAge = 0 where CasesInCooler = 0.0

		update WorkData set Processed = 1  
		where WorkID = @WorkID and StandardTemplateData = 1 and Processed = 0 and SetDate = @SetDate
	
	end

	-- Now WorkData has the correct Egg Age and Cases of Oldest Egg Age for WorkID = @WorkID
	update d set d.OldestEggAge = wd.OldestEggAge, d.CasesOfOldestEggAge = wd.CasesOldestEggAge
	from #Data d
	inner join WorkData wd on wd.WorkID = @WorkID and d.RowNumber = wd.RowNumber

	delete from WorkData where WorkID = @WorkID

	---- update any situations where the same set date has multiple delivery dates
	--update #Data set CasesOfOldestEggAge = CasesOfOldestEggAge - CasesSet
	--where StandardTemplateData = 0

	-- Clean up any misleading data
	update #Data set OldestEggAge = 0 where CasesOfOldestEggAge = 0
	update #Data set FarmPickupQty = FarmPickupQty / (@EggsPerCase * 1.0)

	update #Data set GainsLosses = 0 where CasesInCooler = 0 and GainsLosses is not null


	select 
	RowNumber, 
	SetDate_Day, 
	SetDate,
	DeliveryDate,
	StandardTemplateData,
	LotNumbers,
	CalcSellableEggs,
	CalcSettableEggs,
	CalcSettableEggs_FromStandard,
	ActualSetQty,
	OrderedEggs = OrderedEggs,
	TargetedEggs = TargetEggs, 
	EstimatedYield,
	CalculatedYield,
	CasesSet, 
	FarmPickupQty,
	CasesInCooler,
	EggLoss,
	GainsLosses,	-- Only shown on Friday; Cases In Cooler this - Cases in Cooler last Friday
	OldestEggAge,
	CasesOfOldestEggAge,
	FarmColumn01_FarmID, FarmColumn01_FarmNumber, FarmColumn01_FarmName, FarmColumn01_WeekNumber, FarmColumn01_Qty = convert(numeric(10,1), FarmColumn01_Qty / (@EggsPerCase * 1.0)), FarmColumn01_Visible, FarmColumn01_ReservedForContract, FarmColumn01_PulletFarmPlanDetailID, FarmColumn01_Color,
	FarmColumn02_FarmID, FarmColumn02_FarmNumber, FarmColumn02_FarmName, FarmColumn02_WeekNumber, FarmColumn02_Qty = convert(numeric(10,1), FarmColumn02_Qty / (@EggsPerCase * 1.0)), FarmColumn02_Visible, FarmColumn02_ReservedForContract, FarmColumn02_PulletFarmPlanDetailID, FarmColumn02_Color,
	FarmColumn03_FarmID, FarmColumn03_FarmNumber, FarmColumn03_FarmName, FarmColumn03_WeekNumber, FarmColumn03_Qty = convert(numeric(10,1), FarmColumn03_Qty / (@EggsPerCase * 1.0)), FarmColumn03_Visible, FarmColumn03_ReservedForContract, FarmColumn03_PulletFarmPlanDetailID, FarmColumn03_Color,
	FarmColumn04_FarmID, FarmColumn04_FarmNumber, FarmColumn04_FarmName, FarmColumn04_WeekNumber, FarmColumn04_Qty = convert(numeric(10,1), FarmColumn04_Qty / (@EggsPerCase * 1.0)), FarmColumn04_Visible, FarmColumn04_ReservedForContract, FarmColumn04_PulletFarmPlanDetailID, FarmColumn04_Color,
	FarmColumn05_FarmID, FarmColumn05_FarmNumber, FarmColumn05_FarmName, FarmColumn05_WeekNumber, FarmColumn05_Qty = convert(numeric(10,1), FarmColumn05_Qty / (@EggsPerCase * 1.0)), FarmColumn05_Visible, FarmColumn05_ReservedForContract, FarmColumn05_PulletFarmPlanDetailID, FarmColumn05_Color,
	FarmColumn06_FarmID, FarmColumn06_FarmNumber, FarmColumn06_FarmName, FarmColumn06_WeekNumber, FarmColumn06_Qty = convert(numeric(10,1), FarmColumn06_Qty / (@EggsPerCase * 1.0)), FarmColumn06_Visible, FarmColumn06_ReservedForContract, FarmColumn06_PulletFarmPlanDetailID, FarmColumn06_Color,
	FarmColumn07_FarmID, FarmColumn07_FarmNumber, FarmColumn07_FarmName, FarmColumn07_WeekNumber, FarmColumn07_Qty = convert(numeric(10,1), FarmColumn07_Qty / (@EggsPerCase * 1.0)), FarmColumn07_Visible, FarmColumn07_ReservedForContract, FarmColumn07_PulletFarmPlanDetailID, FarmColumn07_Color,
	FarmColumn08_FarmID, FarmColumn08_FarmNumber, FarmColumn08_FarmName, FarmColumn08_WeekNumber, FarmColumn08_Qty = convert(numeric(10,1), FarmColumn08_Qty / (@EggsPerCase * 1.0)), FarmColumn08_Visible, FarmColumn08_ReservedForContract, FarmColumn08_PulletFarmPlanDetailID, FarmColumn08_Color,
	FarmColumn09_FarmID, FarmColumn09_FarmNumber, FarmColumn09_FarmName, FarmColumn09_WeekNumber, FarmColumn09_Qty = convert(numeric(10,1), FarmColumn09_Qty / (@EggsPerCase * 1.0)), FarmColumn09_Visible, FarmColumn09_ReservedForContract, FarmColumn09_PulletFarmPlanDetailID, FarmColumn09_Color,
	FarmColumn10_FarmID, FarmColumn10_FarmNumber, FarmColumn10_FarmName, FarmColumn10_WeekNumber, FarmColumn10_Qty = convert(numeric(10,1), FarmColumn10_Qty / (@EggsPerCase * 1.0)), FarmColumn10_Visible, FarmColumn10_ReservedForContract, FarmColumn10_PulletFarmPlanDetailID, FarmColumn10_Color,
	FarmColumn11_FarmID, FarmColumn11_FarmNumber, FarmColumn11_FarmName, FarmColumn11_WeekNumber, FarmColumn11_Qty = convert(numeric(10,1), FarmColumn11_Qty / (@EggsPerCase * 1.0)), FarmColumn11_Visible, FarmColumn11_ReservedForContract, FarmColumn11_PulletFarmPlanDetailID, FarmColumn11_Color,
	FarmColumn12_FarmID, FarmColumn12_FarmNumber, FarmColumn12_FarmName, FarmColumn12_WeekNumber, FarmColumn12_Qty = convert(numeric(10,1), FarmColumn12_Qty / (@EggsPerCase * 1.0)), FarmColumn12_Visible, FarmColumn12_ReservedForContract, FarmColumn12_PulletFarmPlanDetailID, FarmColumn12_Color,
	FarmColumn13_FarmID, FarmColumn13_FarmNumber, FarmColumn13_FarmName, FarmColumn13_WeekNumber, FarmColumn13_Qty = convert(numeric(10,1), FarmColumn13_Qty / (@EggsPerCase * 1.0)), FarmColumn13_Visible, FarmColumn13_ReservedForContract, FarmColumn13_PulletFarmPlanDetailID, FarmColumn13_Color,
	FarmColumn14_FarmID, FarmColumn14_FarmNumber, FarmColumn14_FarmName, FarmColumn14_WeekNumber, FarmColumn14_Qty = convert(numeric(10,1), FarmColumn14_Qty / (@EggsPerCase * 1.0)), FarmColumn14_Visible, FarmColumn14_ReservedForContract, FarmColumn14_PulletFarmPlanDetailID, FarmColumn14_Color,
	FarmColumn15_FarmID, FarmColumn15_FarmNumber, FarmColumn15_FarmName, FarmColumn15_WeekNumber, FarmColumn15_Qty = convert(numeric(10,1), FarmColumn15_Qty / (@EggsPerCase * 1.0)), FarmColumn15_Visible, FarmColumn15_ReservedForContract, FarmColumn15_PulletFarmPlanDetailID, FarmColumn15_Color,
	FarmColumn16_FarmID, FarmColumn16_FarmNumber, FarmColumn16_FarmName, FarmColumn16_WeekNumber, FarmColumn16_Qty = convert(numeric(10,1), FarmColumn16_Qty / (@EggsPerCase * 1.0)), FarmColumn16_Visible, FarmColumn16_ReservedForContract, FarmColumn16_PulletFarmPlanDetailID, FarmColumn16_Color,
	FarmColumn17_FarmID, FarmColumn17_FarmNumber, FarmColumn17_FarmName, FarmColumn17_WeekNumber, FarmColumn17_Qty = convert(numeric(10,1), FarmColumn17_Qty / (@EggsPerCase * 1.0)), FarmColumn17_Visible, FarmColumn17_ReservedForContract, FarmColumn17_PulletFarmPlanDetailID, FarmColumn17_Color,
	FarmColumn18_FarmID, FarmColumn18_FarmNumber, FarmColumn18_FarmName, FarmColumn18_WeekNumber, FarmColumn18_Qty = convert(numeric(10,1), FarmColumn18_Qty / (@EggsPerCase * 1.0)), FarmColumn18_Visible, FarmColumn18_ReservedForContract, FarmColumn18_PulletFarmPlanDetailID, FarmColumn18_Color,
	FarmColumn19_FarmID, FarmColumn19_FarmNumber, FarmColumn19_FarmName, FarmColumn19_WeekNumber, FarmColumn19_Qty = convert(numeric(10,1), FarmColumn19_Qty / (@EggsPerCase * 1.0)), FarmColumn19_Visible, FarmColumn19_ReservedForContract, FarmColumn19_PulletFarmPlanDetailID, FarmColumn19_Color,
	FarmColumn20_FarmID, FarmColumn20_FarmNumber, FarmColumn20_FarmName, FarmColumn20_WeekNumber, FarmColumn20_Qty = convert(numeric(10,1), FarmColumn20_Qty / (@EggsPerCase * 1.0)), FarmColumn20_Visible, FarmColumn20_ReservedForContract, FarmColumn20_PulletFarmPlanDetailID, FarmColumn20_Color,
	FarmColumn21_FarmID, FarmColumn21_FarmNumber, FarmColumn21_FarmName, FarmColumn21_WeekNumber, FarmColumn21_Qty = convert(numeric(10,1), FarmColumn21_Qty / (@EggsPerCase * 1.0)), FarmColumn21_Visible, FarmColumn21_ReservedForContract, FarmColumn21_PulletFarmPlanDetailID, FarmColumn21_Color,
	FarmColumn22_FarmID, FarmColumn22_FarmNumber, FarmColumn22_FarmName, FarmColumn22_WeekNumber, FarmColumn22_Qty = convert(numeric(10,1), FarmColumn22_Qty / (@EggsPerCase * 1.0)), FarmColumn22_Visible, FarmColumn22_ReservedForContract, FarmColumn22_PulletFarmPlanDetailID, FarmColumn22_Color,
	FarmColumn23_FarmID, FarmColumn23_FarmNumber, FarmColumn23_FarmName, FarmColumn23_WeekNumber, FarmColumn23_Qty = convert(numeric(10,1), FarmColumn23_Qty / (@EggsPerCase * 1.0)), FarmColumn23_Visible, FarmColumn23_ReservedForContract, FarmColumn23_PulletFarmPlanDetailID, FarmColumn23_Color,
	FarmColumn24_FarmID, FarmColumn24_FarmNumber, FarmColumn24_FarmName, FarmColumn24_WeekNumber, FarmColumn24_Qty = convert(numeric(10,1), FarmColumn24_Qty / (@EggsPerCase * 1.0)), FarmColumn24_Visible, FarmColumn24_ReservedForContract, FarmColumn24_PulletFarmPlanDetailID, FarmColumn24_Color,
	FarmColumn25_FarmID, FarmColumn25_FarmNumber, FarmColumn25_FarmName, FarmColumn25_WeekNumber, FarmColumn25_Qty = convert(numeric(10,1), FarmColumn25_Qty / (@EggsPerCase * 1.0)), FarmColumn25_Visible, FarmColumn25_ReservedForContract, FarmColumn25_PulletFarmPlanDetailID, FarmColumn25_Color,
	FarmColumn26_FarmID, FarmColumn26_FarmNumber, FarmColumn26_FarmName, FarmColumn26_WeekNumber, FarmColumn26_Qty = convert(numeric(10,1), FarmColumn26_Qty / (@EggsPerCase * 1.0)), FarmColumn26_Visible, FarmColumn26_ReservedForContract, FarmColumn26_PulletFarmPlanDetailID, FarmColumn26_Color,
	FarmColumn27_FarmID, FarmColumn27_FarmNumber, FarmColumn27_FarmName, FarmColumn27_WeekNumber, FarmColumn27_Qty = convert(numeric(10,1), FarmColumn27_Qty / (@EggsPerCase * 1.0)), FarmColumn27_Visible, FarmColumn27_ReservedForContract, FarmColumn27_PulletFarmPlanDetailID, FarmColumn27_Color,
	FarmColumn28_FarmID, FarmColumn28_FarmNumber, FarmColumn28_FarmName, FarmColumn28_WeekNumber, FarmColumn28_Qty = convert(numeric(10,1), FarmColumn28_Qty / (@EggsPerCase * 1.0)), FarmColumn28_Visible, FarmColumn28_ReservedForContract, FarmColumn28_PulletFarmPlanDetailID, FarmColumn28_Color,
	FarmColumn29_FarmID, FarmColumn29_FarmNumber, FarmColumn29_FarmName, FarmColumn29_WeekNumber, FarmColumn29_Qty = convert(numeric(10,1), FarmColumn29_Qty / (@EggsPerCase * 1.0)), FarmColumn29_Visible, FarmColumn29_ReservedForContract, FarmColumn29_PulletFarmPlanDetailID, FarmColumn29_Color,
	FarmColumn30_FarmID, FarmColumn30_FarmNumber, FarmColumn30_FarmName, FarmColumn30_WeekNumber, FarmColumn30_Qty = convert(numeric(10,1), FarmColumn30_Qty / (@EggsPerCase * 1.0)), FarmColumn30_Visible, FarmColumn30_ReservedForContract, FarmColumn30_PulletFarmPlanDetailID, FarmColumn30_Color,

	FarmColumn31_FarmID, FarmColumn31_FarmNumber, FarmColumn31_FarmName, FarmColumn31_WeekNumber, FarmColumn31_Qty = convert(numeric(10,1), FarmColumn31_Qty / (@EggsPerCase * 1.0)), FarmColumn31_Visible, FarmColumn31_ReservedForContract, FarmColumn31_PulletFarmPlanDetailID, FarmColumn31_Color,
	FarmColumn32_FarmID, FarmColumn32_FarmNumber, FarmColumn32_FarmName, FarmColumn32_WeekNumber, FarmColumn32_Qty = convert(numeric(10,1), FarmColumn32_Qty / (@EggsPerCase * 1.0)), FarmColumn32_Visible, FarmColumn32_ReservedForContract, FarmColumn32_PulletFarmPlanDetailID, FarmColumn32_Color,
	FarmColumn33_FarmID, FarmColumn33_FarmNumber, FarmColumn33_FarmName, FarmColumn33_WeekNumber, FarmColumn33_Qty = convert(numeric(10,1), FarmColumn33_Qty / (@EggsPerCase * 1.0)), FarmColumn33_Visible, FarmColumn33_ReservedForContract, FarmColumn33_PulletFarmPlanDetailID, FarmColumn33_Color,
	FarmColumn34_FarmID, FarmColumn34_FarmNumber, FarmColumn34_FarmName, FarmColumn34_WeekNumber, FarmColumn34_Qty = convert(numeric(10,1), FarmColumn34_Qty / (@EggsPerCase * 1.0)), FarmColumn34_Visible, FarmColumn34_ReservedForContract, FarmColumn34_PulletFarmPlanDetailID, FarmColumn34_Color,
	FarmColumn35_FarmID, FarmColumn35_FarmNumber, FarmColumn35_FarmName, FarmColumn35_WeekNumber, FarmColumn35_Qty = convert(numeric(10,1), FarmColumn35_Qty / (@EggsPerCase * 1.0)), FarmColumn35_Visible, FarmColumn35_ReservedForContract, FarmColumn35_PulletFarmPlanDetailID, FarmColumn35_Color,
	FarmColumn36_FarmID, FarmColumn36_FarmNumber, FarmColumn36_FarmName, FarmColumn36_WeekNumber, FarmColumn36_Qty = convert(numeric(10,1), FarmColumn36_Qty / (@EggsPerCase * 1.0)), FarmColumn36_Visible, FarmColumn36_ReservedForContract, FarmColumn36_PulletFarmPlanDetailID, FarmColumn36_Color,
	FarmColumn37_FarmID, FarmColumn37_FarmNumber, FarmColumn37_FarmName, FarmColumn37_WeekNumber, FarmColumn37_Qty = convert(numeric(10,1), FarmColumn37_Qty / (@EggsPerCase * 1.0)), FarmColumn37_Visible, FarmColumn37_ReservedForContract, FarmColumn37_PulletFarmPlanDetailID, FarmColumn37_Color,
	FarmColumn38_FarmID, FarmColumn38_FarmNumber, FarmColumn38_FarmName, FarmColumn38_WeekNumber, FarmColumn38_Qty = convert(numeric(10,1), FarmColumn38_Qty / (@EggsPerCase * 1.0)), FarmColumn38_Visible, FarmColumn38_ReservedForContract, FarmColumn38_PulletFarmPlanDetailID, FarmColumn38_Color,
	FarmColumn39_FarmID, FarmColumn39_FarmNumber, FarmColumn39_FarmName, FarmColumn39_WeekNumber, FarmColumn39_Qty = convert(numeric(10,1), FarmColumn39_Qty / (@EggsPerCase * 1.0)), FarmColumn39_Visible, FarmColumn39_ReservedForContract, FarmColumn39_PulletFarmPlanDetailID, FarmColumn39_Color,
	FarmColumn40_FarmID, FarmColumn40_FarmNumber, FarmColumn40_FarmName, FarmColumn40_WeekNumber, FarmColumn40_Qty = convert(numeric(10,1), FarmColumn40_Qty / (@EggsPerCase * 1.0)), FarmColumn40_Visible, FarmColumn40_ReservedForContract, FarmColumn40_PulletFarmPlanDetailID, FarmColumn40_Color,
	FarmColumn41_FarmID, FarmColumn41_FarmNumber, FarmColumn41_FarmName, FarmColumn41_WeekNumber, FarmColumn41_Qty = convert(numeric(10,1), FarmColumn41_Qty / (@EggsPerCase * 1.0)), FarmColumn41_Visible, FarmColumn41_ReservedForContract, FarmColumn41_PulletFarmPlanDetailID, FarmColumn41_Color,
	FarmColumn42_FarmID, FarmColumn42_FarmNumber, FarmColumn42_FarmName, FarmColumn42_WeekNumber, FarmColumn42_Qty = convert(numeric(10,1), FarmColumn42_Qty / (@EggsPerCase * 1.0)), FarmColumn42_Visible, FarmColumn42_ReservedForContract, FarmColumn42_PulletFarmPlanDetailID, FarmColumn42_Color,
	FarmColumn43_FarmID, FarmColumn43_FarmNumber, FarmColumn43_FarmName, FarmColumn43_WeekNumber, FarmColumn43_Qty = convert(numeric(10,1), FarmColumn43_Qty / (@EggsPerCase * 1.0)), FarmColumn43_Visible, FarmColumn43_ReservedForContract, FarmColumn43_PulletFarmPlanDetailID, FarmColumn43_Color,
	FarmColumn44_FarmID, FarmColumn44_FarmNumber, FarmColumn44_FarmName, FarmColumn44_WeekNumber, FarmColumn44_Qty = convert(numeric(10,1), FarmColumn44_Qty / (@EggsPerCase * 1.0)), FarmColumn44_Visible, FarmColumn44_ReservedForContract, FarmColumn44_PulletFarmPlanDetailID, FarmColumn44_Color,
	FarmColumn45_FarmID, FarmColumn45_FarmNumber, FarmColumn45_FarmName, FarmColumn45_WeekNumber, FarmColumn45_Qty = convert(numeric(10,1), FarmColumn45_Qty / (@EggsPerCase * 1.0)), FarmColumn45_Visible, FarmColumn45_ReservedForContract, FarmColumn45_PulletFarmPlanDetailID, FarmColumn45_Color,
	FarmColumn46_FarmID, FarmColumn46_FarmNumber, FarmColumn46_FarmName, FarmColumn46_WeekNumber, FarmColumn46_Qty = convert(numeric(10,1), FarmColumn46_Qty / (@EggsPerCase * 1.0)), FarmColumn46_Visible, FarmColumn46_ReservedForContract, FarmColumn46_PulletFarmPlanDetailID, FarmColumn46_Color,
	FarmColumn47_FarmID, FarmColumn47_FarmNumber, FarmColumn47_FarmName, FarmColumn47_WeekNumber, FarmColumn47_Qty = convert(numeric(10,1), FarmColumn47_Qty / (@EggsPerCase * 1.0)), FarmColumn47_Visible, FarmColumn47_ReservedForContract, FarmColumn47_PulletFarmPlanDetailID, FarmColumn47_Color,
	FarmColumn48_FarmID, FarmColumn48_FarmNumber, FarmColumn48_FarmName, FarmColumn48_WeekNumber, FarmColumn48_Qty = convert(numeric(10,1), FarmColumn48_Qty / (@EggsPerCase * 1.0)), FarmColumn48_Visible, FarmColumn48_ReservedForContract, FarmColumn48_PulletFarmPlanDetailID, FarmColumn48_Color,
	FarmColumn49_FarmID, FarmColumn49_FarmNumber, FarmColumn49_FarmName, FarmColumn49_WeekNumber, FarmColumn49_Qty = convert(numeric(10,1), FarmColumn49_Qty / (@EggsPerCase * 1.0)), FarmColumn49_Visible, FarmColumn49_ReservedForContract, FarmColumn49_PulletFarmPlanDetailID, FarmColumn49_Color,
	FarmColumn50_FarmID, FarmColumn50_FarmNumber, FarmColumn50_FarmName, FarmColumn50_WeekNumber, FarmColumn50_Qty = convert(numeric(10,1), FarmColumn50_Qty / (@EggsPerCase * 1.0)), FarmColumn50_Visible, FarmColumn50_ReservedForContract, FarmColumn50_PulletFarmPlanDetailID, FarmColumn50_Color,

	BuildingColumn01_Qty, BuildingColumn01_DestinationBuildingID, BuildingColumn01_Visible,
	BuildingColumn02_Qty, BuildingColumn02_DestinationBuildingID, BuildingColumn02_Visible,
	BuildingColumn03_Qty, BuildingColumn03_DestinationBuildingID, BuildingColumn03_Visible,
	BuildingColumn04_Qty, BuildingColumn04_DestinationBuildingID, BuildingColumn04_Visible,
	BuildingColumn05_Qty, BuildingColumn05_DestinationBuildingID, BuildingColumn05_Visible,
	BuildingColumn06_Qty, BuildingColumn06_DestinationBuildingID, BuildingColumn06_Visible,
	BuildingColumn07_Qty, BuildingColumn07_DestinationBuildingID, BuildingColumn07_Visible,
	BuildingColumn08_Qty, BuildingColumn08_DestinationBuildingID, BuildingColumn08_Visible,
	ShowFarms = @ShowFarms,
	ContractTypeID = @ContractTypeID, StartDate = @StartDate, EndDate = @EndDate
from #Data
where SetDate between @StartDate and @EndDate
order by SetDate, DeliveryDate

drop table #Data
drop table #BuildingList
drop table #OrdersByBuilding



