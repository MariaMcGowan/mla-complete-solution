USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[GetEggFlowSchedule_OmitFarms]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetEggFlowSchedule_OmitFarms]
GO
/****** Object:  StoredProcedure [dbo].[GetEggFlowSchedule_OmitFarms]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEggFlowSchedule_OmitFarms]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetEggFlowSchedule_OmitFarms] AS' 
END
GO



ALTER proc [dbo].[GetEggFlowSchedule_OmitFarms] @UserID varchar(255), @StartDate date, @EndDate date, @ContractTypeID int
as

set nocount off

	declare @BlankStartDate date
	declare @BlankEndDate date
	--declare @EstimatedYield numeric(7,4)

	declare @EggsPerCase int = 360
	declare @TargetPercent numeric(4,2) = .02

	if @TargetPercent > 1
		select @TargetPercent = @TargetPercent / 100

	create table #Data
	(
		Date date, 
		CalcSettableEggs int,
		CalcSellableEggs int,
		OrderedEggs int,
		TargetEggs int, 
		EstimatedYield numeric(4,2),
		CasesSet numeric(6,2), 
		--LotNbrs varchar(50),
		-- Note - Qty stands for the calculated embryo quantity
		ActualSetQty int default 0
	)


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


	update ps set ps.CalcSettableEggs = ws.CalcSettableEggs, 
	ps.CalcSellableEggs = ws.CalcSellableEggs
	from #Data ps
	left outer join 
	(
		select Date, sum(SettableEggs) as CalcSettableEggs, sum(SellableEggs) as CalcSellableEggs
		from RollingDailySchedule pfpd
		where exists (select 1 from #Data where Date = pfpd.Date)
		group by Date
	) ws on ps.Date = ws.Date

	update ps set ps.ActualSetQty = s.ActualSetQty
	from #Data ps
	inner join 
	(
		select o.PlannedSetDate as SetDate, sum(lpd.FlockQty) as ActualSetQty
		from [Order] o
		inner join LoadPlanning lp on o.DeliveryDate = lp.DeliveryDate
		inner join LoadPLanning_Detail lpd on lp.LoadPlanningID = lpd.LoadPlanningID
		where o.PlannedSetDate between @StartDate and @EndDate
		group by o.PlannedSetDate
	) s on ps.Date = s.SetDate

	update ps set ps.OrderedEggs = Orders.PlannedQty
	from #Data ps
	inner join 
	(
		SELECT
			O.PlannedSetDate 
			,sum(O.PlannedQty) as PlannedQty
		FROM [Order] O
		GROUP BY O.PlannedSetDate
	) Orders on ps.Date = Orders.PlannedSetDate

	
	update d set d.EstimatedYield = efp.EstimatedYield
	from #Data d
	inner join EggFlowPlaning efp on d.Date = efp.Date

	update #Data set
		TargetEggs = round(OrderedEggs * (1 + @TargetPercent), 0),
		EstimatedYield = nullif(EstimatedYield,0)

	
	update #Data set 
		CasesSet = (TargetEggs * EstimatedYield) / (CalcSettableEggs * 1.00)


	select 
	Date, 
	CalcSellableEggs,
	CalcSettableEggs,
	ActualSetQty,
	OrderedEggs = OrderedEggs,
	TargetedEggs = TargetEggs, 
	EstimatedYield = null,
	CalculatedYield = convert(numeric(5,4), CalcSellableEggs / (CalcSettableEggs * 1.0000)), 
	CasesSet
from #Data
order by Date

drop table #Data




GO
