USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OverridePulletFarmPlanDetail_GetSummaryData]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OverridePulletFarmPlanDetail_GetSummaryData]
GO
/****** Object:  StoredProcedure [dbo].[OverridePulletFarmPlanDetail_GetSummaryData]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OverridePulletFarmPlanDetail_GetSummaryData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OverridePulletFarmPlanDetail_GetSummaryData] AS' 
END
GO




ALTER proc [dbo].[OverridePulletFarmPlanDetail_GetSummaryData]
	@StartDate date = null, @EndDate date = null, @ContractTypeID int = null, @DayOfWeekID int = null
as

select @StartDate = isnull(nullif(@StartDate, ''), convert(date,getdate()))
select @EndDate = isnull(nullif(@EndDate, ''),dateadd(day,7,@StartDate)),
	@DayOfWeekID = nullif(nullif(@DayOfWeekID, ''),0),
	@ContractTypeID = isnull(nullif(@ContractTypeID,''),0) 


declare @EggsPerCase int = 360

select 
	UniqueRowID = row_number() over (order by Date),
	Date as SetDate,
	DeliveryDate = dateadd(day,12,Date),
	SettableEggs = sum(coalesce(nullif(OverwrittenSettableEggs,0), SettableEggs)),
	SettableEggs_Cases = sum(round(coalesce(nullif(OverwrittenSettableEggs,0), SettableEggs) / (@EggsPerCase * 1.0),1)),
	CurrentStatus = 
		case
			when exists (select 1 from PulletFarmPlanDetail where date = d.Date and ReservedForContract = 1) then
				case
					when exists (select 1 from PulletFarmPlanDetail where date = d.Date and ReservedForContract = 0) then 'Partially Reserved'
					else 'Reserved'
				end
			else 'Not Reserved'
		end,
	DayOfWeek = DateName(dw,dateadd(day,12,Date)),	-- Day of week for delivery date
	ReserveReleaseID = convert(bit, null)
from RollingDailySchedule d
where Date between @StartDate and @EndDate 
and ContractTypeID = @ContractTypeID
and datepart(dw,dateadd(day,12,Date)) = isnull(@DayOfWeekID, datepart(dw,dateadd(day,12,Date)))
group by Date
			


GO
