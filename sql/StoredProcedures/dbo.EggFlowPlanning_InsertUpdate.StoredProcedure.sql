USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggFlowPlanning_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggFlowPlanning_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[EggFlowPlanning_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggFlowPlanning_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggFlowPlanning_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[EggFlowPlanning_InsertUpdate] 
	@I_vDate date, 
	@I_vEstimatedYield numeric(7,4) = null,
	@I_vFarmColumn01_Qty numeric(7,4) = null,
	@I_vFarmColumn02_Qty numeric(7,4) = null,
	@I_vFarmColumn03_Qty numeric(7,4) = null,
	@I_vFarmColumn04_Qty numeric(7,4) = null,
	@I_vFarmColumn05_Qty numeric(7,4) = null,
	@I_vFarmColumn06_Qty numeric(7,4) = null,
	@I_vFarmColumn07_Qty numeric(7,4) = null,
	@I_vFarmColumn08_Qty numeric(7,4) = null,
	@I_vFarmColumn09_Qty numeric(7,4) = null,
	@I_vFarmColumn10_Qty numeric(7,4) = null,
	@I_vFarmColumn11_Qty numeric(7,4) = null,
	@I_vFarmColumn12_Qty numeric(7,4) = null,
	@I_vFarmColumn13_Qty numeric(7,4) = null,
	@I_vFarmColumn14_Qty numeric(7,4) = null,
	@I_vFarmColumn15_Qty numeric(7,4) = null,
	@I_vFarmColumn16_Qty numeric(7,4) = null,
	@I_vFarmColumn17_Qty numeric(7,4) = null,
	@I_vFarmColumn18_Qty numeric(7,4) = null,
	@I_vFarmColumn19_Qty numeric(7,4) = null,
	@I_vFarmColumn20_Qty numeric(7,4) = null,
	@I_vFarmColumn21_Qty numeric(7,4) = null,
	@I_vFarmColumn22_Qty numeric(7,4) = null,
	@I_vFarmColumn23_Qty numeric(7,4) = null,
	@I_vFarmColumn24_Qty numeric(7,4) = null,
	@I_vFarmColumn25_Qty numeric(7,4) = null,
	@I_vFarmColumn26_Qty numeric(7,4) = null,
	@I_vFarmColumn27_Qty numeric(7,4) = null,
	@I_vFarmColumn28_Qty numeric(7,4) = null,
	@I_vFarmColumn29_Qty numeric(7,4) = null,
	@I_vFarmColumn30_Qty numeric(7,4) = null,
	@I_vFarmColumn01_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn02_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn03_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn04_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn05_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn06_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn07_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn08_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn09_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn10_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn11_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn12_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn13_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn14_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn15_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn16_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn17_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn18_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn19_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn20_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn21_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn22_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn23_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn24_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn25_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn26_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn27_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn28_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn29_PulletFarmPlanDetailID int = null,
	@I_vFarmColumn30_PulletFarmPlanDetailID int = null,	 
	@O_iErrorState int=0 output,				  
	@oErrString varchar(255)='' output,
	@iRowID varchar(255)=NULL output  

as


	declare @FarmID int
	declare @FarmColor varchar(10)
	declare @sql varchar(4000)
	declare @LoopCounter int = 0
	declare @FarmCol int = 0
	declare @EggsPerCase int = 360


	create table #Data
	(
		Date date, 
		EstimatedYield numeric(4,2),
		FarmColumn01_Qty int,  
		FarmColumn02_Qty int,  
		FarmColumn03_Qty int,  
		FarmColumn04_Qty int,  
		FarmColumn05_Qty int,  
		FarmColumn06_Qty int,  
		FarmColumn07_Qty int,  
		FarmColumn08_Qty int,  
		FarmColumn09_Qty int,  
		FarmColumn10_Qty int,  
		FarmColumn11_Qty int,  
		FarmColumn12_Qty int,  
		FarmColumn13_Qty int,  
		FarmColumn14_Qty int,  
		FarmColumn15_Qty int,  
		FarmColumn16_Qty int,  
		FarmColumn17_Qty int,  
		FarmColumn18_Qty int,  
		FarmColumn19_Qty int,  
		FarmColumn20_Qty int,  
		FarmColumn21_Qty int,  
		FarmColumn22_Qty int,  
		FarmColumn23_Qty int,  
		FarmColumn24_Qty int,  
		FarmColumn25_Qty int,  
		FarmColumn26_Qty int,  
		FarmColumn27_Qty int,  
		FarmColumn28_Qty int,  
		FarmColumn29_Qty int,  
		FarmColumn30_Qty int,
		FarmColumn01_PulletFarmPlanDetailID int,
		FarmColumn02_PulletFarmPlanDetailID int,
		FarmColumn03_PulletFarmPlanDetailID int,
		FarmColumn04_PulletFarmPlanDetailID int,
		FarmColumn05_PulletFarmPlanDetailID int,
		FarmColumn06_PulletFarmPlanDetailID int,
		FarmColumn07_PulletFarmPlanDetailID int,
		FarmColumn08_PulletFarmPlanDetailID int,
		FarmColumn09_PulletFarmPlanDetailID int,
		FarmColumn10_PulletFarmPlanDetailID int,
		FarmColumn11_PulletFarmPlanDetailID int,
		FarmColumn12_PulletFarmPlanDetailID int,
		FarmColumn13_PulletFarmPlanDetailID int,
		FarmColumn14_PulletFarmPlanDetailID int,
		FarmColumn15_PulletFarmPlanDetailID int,
		FarmColumn16_PulletFarmPlanDetailID int,
		FarmColumn17_PulletFarmPlanDetailID int,
		FarmColumn18_PulletFarmPlanDetailID int,
		FarmColumn19_PulletFarmPlanDetailID int,
		FarmColumn20_PulletFarmPlanDetailID int,
		FarmColumn21_PulletFarmPlanDetailID int,
		FarmColumn22_PulletFarmPlanDetailID int,
		FarmColumn23_PulletFarmPlanDetailID int,
		FarmColumn24_PulletFarmPlanDetailID int,
		FarmColumn25_PulletFarmPlanDetailID int,
		FarmColumn26_PulletFarmPlanDetailID int,
		FarmColumn27_PulletFarmPlanDetailID int,
		FarmColumn28_PulletFarmPlanDetailID int,
		FarmColumn29_PulletFarmPlanDetailID int,
		FarmColumn30_PulletFarmPlanDetailID int,
	)

	insert into #Data (
		Date, 
		EstimatedYield,
		FarmColumn01_Qty,  
		FarmColumn02_Qty,  
		FarmColumn03_Qty,  
		FarmColumn04_Qty,  
		FarmColumn05_Qty,  
		FarmColumn06_Qty,  
		FarmColumn07_Qty,  
		FarmColumn08_Qty,  
		FarmColumn09_Qty,  
		FarmColumn10_Qty,  
		FarmColumn11_Qty,  
		FarmColumn12_Qty,  
		FarmColumn13_Qty,  
		FarmColumn14_Qty,  
		FarmColumn15_Qty,  
		FarmColumn16_Qty,  
		FarmColumn17_Qty,  
		FarmColumn18_Qty,  
		FarmColumn19_Qty,  
		FarmColumn20_Qty,  
		FarmColumn21_Qty,  
		FarmColumn22_Qty,  
		FarmColumn23_Qty,  
		FarmColumn24_Qty,  
		FarmColumn25_Qty,  
		FarmColumn26_Qty,  
		FarmColumn27_Qty,  
		FarmColumn28_Qty,  
		FarmColumn29_Qty,  
		FarmColumn30_Qty,
		FarmColumn01_PulletFarmPlanDetailID,
		FarmColumn02_PulletFarmPlanDetailID,
		FarmColumn03_PulletFarmPlanDetailID,
		FarmColumn04_PulletFarmPlanDetailID,
		FarmColumn05_PulletFarmPlanDetailID,
		FarmColumn06_PulletFarmPlanDetailID,
		FarmColumn07_PulletFarmPlanDetailID,
		FarmColumn08_PulletFarmPlanDetailID,
		FarmColumn09_PulletFarmPlanDetailID,
		FarmColumn10_PulletFarmPlanDetailID,
		FarmColumn11_PulletFarmPlanDetailID,
		FarmColumn12_PulletFarmPlanDetailID,
		FarmColumn13_PulletFarmPlanDetailID,
		FarmColumn14_PulletFarmPlanDetailID,
		FarmColumn15_PulletFarmPlanDetailID,
		FarmColumn16_PulletFarmPlanDetailID,
		FarmColumn17_PulletFarmPlanDetailID,
		FarmColumn18_PulletFarmPlanDetailID,
		FarmColumn19_PulletFarmPlanDetailID,
		FarmColumn20_PulletFarmPlanDetailID,
		FarmColumn21_PulletFarmPlanDetailID,
		FarmColumn22_PulletFarmPlanDetailID,
		FarmColumn23_PulletFarmPlanDetailID,
		FarmColumn24_PulletFarmPlanDetailID,
		FarmColumn25_PulletFarmPlanDetailID,
		FarmColumn26_PulletFarmPlanDetailID,
		FarmColumn27_PulletFarmPlanDetailID,
		FarmColumn28_PulletFarmPlanDetailID,
		FarmColumn29_PulletFarmPlanDetailID,
		FarmColumn30_PulletFarmPlanDetailID)
	select 
		@I_vDate, 
		@I_vEstimatedYield,
		@I_vFarmColumn01_Qty * @EggsPerCase,  
		@I_vFarmColumn02_Qty * @EggsPerCase,  
		@I_vFarmColumn03_Qty * @EggsPerCase,  
		@I_vFarmColumn04_Qty * @EggsPerCase,  
		@I_vFarmColumn05_Qty * @EggsPerCase,  
		@I_vFarmColumn06_Qty * @EggsPerCase,  
		@I_vFarmColumn07_Qty * @EggsPerCase,  
		@I_vFarmColumn08_Qty * @EggsPerCase,  
		@I_vFarmColumn09_Qty * @EggsPerCase,  
		@I_vFarmColumn10_Qty * @EggsPerCase,  
		@I_vFarmColumn11_Qty * @EggsPerCase,  
		@I_vFarmColumn12_Qty * @EggsPerCase,  
		@I_vFarmColumn13_Qty * @EggsPerCase,  
		@I_vFarmColumn14_Qty * @EggsPerCase,  
		@I_vFarmColumn15_Qty * @EggsPerCase,  
		@I_vFarmColumn16_Qty * @EggsPerCase,  
		@I_vFarmColumn17_Qty * @EggsPerCase,  
		@I_vFarmColumn18_Qty * @EggsPerCase,  
		@I_vFarmColumn19_Qty * @EggsPerCase,  
		@I_vFarmColumn20_Qty * @EggsPerCase,  
		@I_vFarmColumn21_Qty * @EggsPerCase,  
		@I_vFarmColumn22_Qty * @EggsPerCase,  
		@I_vFarmColumn23_Qty * @EggsPerCase,  
		@I_vFarmColumn24_Qty * @EggsPerCase,  
		@I_vFarmColumn25_Qty * @EggsPerCase,  
		@I_vFarmColumn26_Qty * @EggsPerCase,  
		@I_vFarmColumn27_Qty * @EggsPerCase,  
		@I_vFarmColumn28_Qty * @EggsPerCase,  
		@I_vFarmColumn29_Qty * @EggsPerCase,  
		@I_vFarmColumn30_Qty * @EggsPerCase,
		@I_vFarmColumn01_PulletFarmPlanDetailID,
		@I_vFarmColumn02_PulletFarmPlanDetailID,
		@I_vFarmColumn03_PulletFarmPlanDetailID,
		@I_vFarmColumn04_PulletFarmPlanDetailID,
		@I_vFarmColumn05_PulletFarmPlanDetailID,
		@I_vFarmColumn06_PulletFarmPlanDetailID,
		@I_vFarmColumn07_PulletFarmPlanDetailID,
		@I_vFarmColumn08_PulletFarmPlanDetailID,
		@I_vFarmColumn09_PulletFarmPlanDetailID,
		@I_vFarmColumn10_PulletFarmPlanDetailID,
		@I_vFarmColumn11_PulletFarmPlanDetailID,
		@I_vFarmColumn12_PulletFarmPlanDetailID,
		@I_vFarmColumn13_PulletFarmPlanDetailID,
		@I_vFarmColumn14_PulletFarmPlanDetailID,
		@I_vFarmColumn15_PulletFarmPlanDetailID,
		@I_vFarmColumn16_PulletFarmPlanDetailID,
		@I_vFarmColumn17_PulletFarmPlanDetailID,
		@I_vFarmColumn18_PulletFarmPlanDetailID,
		@I_vFarmColumn19_PulletFarmPlanDetailID,
		@I_vFarmColumn20_PulletFarmPlanDetailID,
		@I_vFarmColumn21_PulletFarmPlanDetailID,
		@I_vFarmColumn22_PulletFarmPlanDetailID,
		@I_vFarmColumn23_PulletFarmPlanDetailID,
		@I_vFarmColumn24_PulletFarmPlanDetailID,
		@I_vFarmColumn25_PulletFarmPlanDetailID,
		@I_vFarmColumn26_PulletFarmPlanDetailID,
		@I_vFarmColumn27_PulletFarmPlanDetailID,
		@I_vFarmColumn28_PulletFarmPlanDetailID,
		@I_vFarmColumn29_PulletFarmPlanDetailID,
		@I_vFarmColumn30_PulletFarmPlanDetailID


-- Update the EggFlowPlanning table first
if not exists (select 1 from EggFlowPlanning where Date = @I_vDate)
begin
	insert into EggFlowPlanning (Date) 
	select @I_vDate
end

update EggFlowPlanning set
	EstimatedYield = @I_vEstimatedYield
where Date = @I_vDate

while @LoopCounter < 30
begin
	select @LoopCounter = @LoopCounter + 1

	begin
		select @SQL = 
		'update pfpd set pfpd.OverwrittenSettableEggs = d.FarmColumn{NN}_Qty
		from PulletFarmPlanDetail pfpd 
		inner join #Data d on pfpd.Date = d.Date
		where PulletFarmPlanDetailID = d.FarmColumn{NN}_PulletFarmPlanDetailID'

		select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
		print (@SQL)
		execute (@SQL)

	end
end



GO
