USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OverrideExpectedYield_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OverrideExpectedYield_Get]
GO
/****** Object:  StoredProcedure [dbo].[OverrideExpectedYield_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OverrideExpectedYield_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OverrideExpectedYield_Get] AS' 
END
GO



ALTER proc [dbo].[OverrideExpectedYield_Get] 
	@StartDate date = null, @EndDate date = null, @ContractTypeID int = null
as

select @StartDate = isnull(nullif(@StartDate, ''), convert(date,getdate()))
select @EndDate = isnull(nullif(@EndDate, ''),dateadd(day,7,@StartDate)),
	@ContractTypeID = isnull(nullif(@ContractTypeID,''),0)

	declare @EggsPerCase int = 360
	declare @TargetPercent numeric(4,2) = .02

	if @TargetPercent > 1
		select @TargetPercent = @TargetPercent / 100

	create table #Data
	(
		UniqueRowID int, 
		SetDate date, 
		DeliveryDate date,
		LotNumbers varchar(200),
		CalcSettableEggs int,
		CalcSellableEggs int,
		SettableEggs_FromStandards int,
		OrderedEggs int,
		TargetEggs int, 
		EstimatedYield numeric(4,2),
		CalculatedYield numeric(4,2)
	)


	;With DateSequence( Date ) as
	(
		Select @StartDate as Date
			union all
		Select dateadd(day, 1, Date)
			from DateSequence
			where Date < @EndDate
	)

	insert into #Data (UniqueRowID, SetDate, DeliveryDate)
	select row_number() over (order by Date),
		Date, dateadd(day,12, Date)
	from DateSequence
	OPTION (MAXRECURSION 32747)


	update ps set ps.CalcSettableEggs = ws.CalcSettableEggs, 
	ps.CalcSellableEggs = ws.CalcSellableEggs, 
	ps.SettableEggs_FromStandards = ws.SettableEggs_FromStandards
	from #Data ps
	left outer join 
	(
		select Date, sum(SettableEggs) as CalcSettableEggs, sum(SellableEggs) as CalcSellableEggs, sum(SettableEggs_FromStandards) as SettableEggs_FromStandards
		from RollingDailySchedule pfpd
		where ContractTypeID = @ContractTypeID 
		and exists (select 1 from #Data where Date = pfpd.Date)
		group by Date
	) ws on ps.SetDate = ws.Date

	
	-- This is overwriting the estimated yield with Corey's override
	update d set d.EstimatedYield = pfpd.OverwrittenEstimatedYield
	from #Data d
	inner join PulletFarmPlanDetail pfpd on d.SetDate = pfpd.Date

	-- If Corey did not override it, then use the calculation from the standard
	update #Data set
		TargetEggs = round(OrderedEggs * (1 + @TargetPercent), 0),
		EstimatedYield = 
			case 
				when isnull(CalcSettableEggs,0) > 0 then isnull(nullif(EstimatedYield,0), CalcSellableEggs / (SettableEggs_FromStandards * 1.0000))
				else 0
			end,
		CalculatedYield = 
			case
				when isnull(CalcSettableEggs,0) > 0 then CalcSellableEggs / (CalcSettableEggs * 1.0000)
				else 0
			end




	select 
		UniqueRowID, 
		SetDate,
		DeliveryDate,
		EstimatedYield,
		CalculatedYield,
		ContractTypeID = @ContractTypeID
	from #Data
	order by SetDate, DeliveryDate



GO
