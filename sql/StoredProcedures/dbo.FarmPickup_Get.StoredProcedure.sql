USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FarmPickup_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FarmPickup_Get]
GO
/****** Object:  StoredProcedure [dbo].[FarmPickup_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FarmPickup_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FarmPickup_Get] AS' 
END
GO



ALTER proc [dbo].[FarmPickup_Get] 
	@StartDate date = null, @EndDate date = null, @ContractTypeID int = null
as

declare @EggsPerCase int = 360

select @StartDate = isnull(nullif(@StartDate, ''), convert(date,getdate()))
select @EndDate = isnull(nullif(@EndDate, ''),dateadd(day,7,@StartDate)),
	@ContractTypeID = isnull(nullif(@ContractTypeID,''),0)


	create table #Data
	(
		UniqueRowID int, 
		Date date, 
		FarmPickupQty numeric(10,1)
	)


	;With DateSequence( Date ) as
	(
		Select @StartDate as Date
			union all
		Select dateadd(day, 1, Date)
			from DateSequence
			where Date < @EndDate
	)

	insert into #Data (UniqueRowID, Date)
	select row_number() over (order by Date), Date
	from DateSequence
	OPTION (MAXRECURSION 32747)


	update d set d.FarmPickupQty = hr.FarmPickupQty / (@EggsPerCase * 1.00)
	from #Data d
	inner join HatcheryRecord hr on d.Date = hr.Date
	where hr.ContractTypeID = @ContractTypeID


	select 
		UniqueRowID, 
		Date,
		FarmPickupQty,
		ContractTypeID = @ContractTypeID
	from #Data
	order by Date



GO
