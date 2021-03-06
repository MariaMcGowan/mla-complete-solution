USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[GetCandleOutByFlock]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetCandleOutByFlock]
GO
/****** Object:  StoredProcedure [dbo].[GetCandleOutByFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCandleOutByFlock]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCandleOutByFlock] AS' 
END
GO



ALTER proc [dbo].[GetCandleOutByFlock] 
as

set nocount off

	declare @FarmID int
	declare @FarmColor varchar(10)
	declare @sql varchar(4000)
	declare @LoopCounter int = 0
	declare @FarmCol int = 0
	declare @BlankLoopID int = 0
	declare @BlankStartDate date
	declare @BlankEndDate date
	declare @ExpectedYield numeric(7,4)

	create table #Data
	(
		SortOrder int, 
		HeaderColumn01 varchar(50),
		HeaderColumn02 varchar(50),
		FarmColumn01_CandleOut numeric(6,4), FarmColumn01_FarmID int, FarmColumn01_Visible bit DEFAULT 0, 
		FarmColumn02_CandleOut numeric(6,4), FarmColumn02_FarmID int, FarmColumn02_Visible bit DEFAULT 0, 
		FarmColumn03_CandleOut numeric(6,4), FarmColumn03_FarmID int, FarmColumn03_Visible bit DEFAULT 0, 
		FarmColumn04_CandleOut numeric(6,4), FarmColumn04_FarmID int, FarmColumn04_Visible bit DEFAULT 0, 
		FarmColumn05_CandleOut numeric(6,4), FarmColumn05_FarmID int, FarmColumn05_Visible bit DEFAULT 0, 
		FarmColumn06_CandleOut numeric(6,4), FarmColumn06_FarmID int, FarmColumn06_Visible bit DEFAULT 0, 
		FarmColumn07_CandleOut numeric(6,4), FarmColumn07_FarmID int, FarmColumn07_Visible bit DEFAULT 0, 
		FarmColumn08_CandleOut numeric(6,4), FarmColumn08_FarmID int, FarmColumn08_Visible bit DEFAULT 0, 
		FarmColumn09_CandleOut numeric(6,4), FarmColumn09_FarmID int, FarmColumn09_Visible bit DEFAULT 0, 
		FarmColumn10_CandleOut numeric(6,4), FarmColumn10_FarmID int, FarmColumn10_Visible bit DEFAULT 0, 
		FarmColumn11_CandleOut numeric(6,4), FarmColumn11_FarmID int, FarmColumn11_Visible bit DEFAULT 0, 
		FarmColumn12_CandleOut numeric(6,4), FarmColumn12_FarmID int, FarmColumn12_Visible bit DEFAULT 0, 
		FarmColumn13_CandleOut numeric(6,4), FarmColumn13_FarmID int, FarmColumn13_Visible bit DEFAULT 0, 
		FarmColumn14_CandleOut numeric(6,4), FarmColumn14_FarmID int, FarmColumn14_Visible bit DEFAULT 0, 
		FarmColumn15_CandleOut numeric(6,4), FarmColumn15_FarmID int, FarmColumn15_Visible bit DEFAULT 0, 
		FarmColumn16_CandleOut numeric(6,4), FarmColumn16_FarmID int, FarmColumn16_Visible bit DEFAULT 0, 
		FarmColumn17_CandleOut numeric(6,4), FarmColumn17_FarmID int, FarmColumn17_Visible bit DEFAULT 0, 
		FarmColumn18_CandleOut numeric(6,4), FarmColumn18_FarmID int, FarmColumn18_Visible bit DEFAULT 0, 
		FarmColumn19_CandleOut numeric(6,4), FarmColumn19_FarmID int, FarmColumn19_Visible bit DEFAULT 0, 
		FarmColumn20_CandleOut numeric(6,4), FarmColumn20_FarmID int, FarmColumn20_Visible bit DEFAULT 0, 
		FarmColumn21_CandleOut numeric(6,4), FarmColumn21_FarmID int, FarmColumn21_Visible bit DEFAULT 0, 
		FarmColumn22_CandleOut numeric(6,4), FarmColumn22_FarmID int, FarmColumn22_Visible bit DEFAULT 0, 
		FarmColumn23_CandleOut numeric(6,4), FarmColumn23_FarmID int, FarmColumn23_Visible bit DEFAULT 0, 
		FarmColumn24_CandleOut numeric(6,4), FarmColumn24_FarmID int, FarmColumn24_Visible bit DEFAULT 0, 
		FarmColumn25_CandleOut numeric(6,4), FarmColumn25_FarmID int, FarmColumn25_Visible bit DEFAULT 0, 
		FarmColumn26_CandleOut numeric(6,4), FarmColumn26_FarmID int, FarmColumn26_Visible bit DEFAULT 0, 
		FarmColumn27_CandleOut numeric(6,4), FarmColumn27_FarmID int, FarmColumn27_Visible bit DEFAULT 0, 
		FarmColumn28_CandleOut numeric(6,4), FarmColumn28_FarmID int, FarmColumn28_Visible bit DEFAULT 0, 
		FarmColumn29_CandleOut numeric(6,4), FarmColumn29_FarmID int, FarmColumn29_Visible bit DEFAULT 0, 
		FarmColumn30_CandleOut numeric(6,4), FarmColumn30_FarmID int, FarmColumn30_Visible bit DEFAULT 0 
	)

	declare @FarmList table (FarmColumn int, FarmID int, FarmName varchar(100), FarmNumber varchar(6))
	insert into @FarmList
	exec HatcheryRecords_Get_FarmList

	create table #CandleOut (FarmID int, FarmNumber varchar(3), CandleOutPercentage numeric(6,4), DeliveryDate date, SortOrder int) 
	insert into #CandleOut (FarmID, FarmNumber, CandleOutPercentage, DeliveryDate, SortOrder)
	select FarmID, FarmNumber, CandleOutPercentage, DeliveryDate, SortOrder
	from dbo.GetCandleOutPercentages ('All', 3)

	insert into #Data (SortOrder)
	select 1
	union all
	select 2
	union all
	select 3

	while @LoopCounter < 30
	begin
		select @LoopCounter = @LoopCounter + 1
		select @FarmCol = @LoopCounter - 1

		select @FarmID = null

		select @FarmID = FarmID from @FarmList where FarmColumn = @FarmCol

		if @FarmID is not null
		begin
			select @SQL = 
			'update d set 
			d.FarmColumn{NN}_CandleOut = c.CandleoutPercentage
			from #Data d
			inner join #CandleOut c on d.SortOrder = c.SortOrder
			where c.FarmID = @FarmID'
				
			select @SQL = replace(@SQL, '@FarmID', convert(varchar(4), @FarmID))
			select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
			execute (@SQL)

			-- Update Visible and FarmID
			select @SQL = 'update #Data set FarmColumn{NN}_Visible = 1, FarmColumn{NN}_FarmID = @FarmID'
			select @SQL = replace(@SQL, '@FarmID', convert(varchar(4), @FarmID))
			select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @LoopCounter),2))
			execute (@SQL)

		end
	end

	update #Data set HeaderColumn01 = 'Most recent', HeaderColumn02 = 'Candleout %'
	where SortOrder = 1


	select *
	from #Data
	order by SortOrder



GO
