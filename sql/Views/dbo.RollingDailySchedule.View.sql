/****** Object:  View [dbo].[RollingDailySchedule]    Script Date: 3/9/2020 7:27:09 PM ******/
--DROP VIEW IF EXISTS [dbo].[RollingDailySchedule]
--GO
/****** Object:  View [dbo].[RollingDailySchedule]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[RollingDailySchedule]'))
EXEC dbo.sp_executesql @statement = N'--drop view RollingDailySchedule
--go

create view [dbo].[RollingDailySchedule]
with SCHEMABINDING
as 

select 
pfp.PulletFarmPlanID, 
pfpd.PulletFarmPlanDetailID,
pfp.PlannedOrActual,
pfp.FarmID, 
pfp.ContractStartDate, 
pfp.ContractEndDate,
pfp.CommercialStartDate,
pfp.CommercialEndDate,
pfpd.WeekNumber, 
WeekEndingDate,
UseSourceType = 
	case
		when pfpd.OverwrittenSettableEggs is not null then ''Overwritten''
		when PlannedOrActual = ''P'' then ''Planned''
		else ''Actual''
	end,
pfpd.Date, 
SellableEggs = 
	case
		when pfpd.Date < pfp.ContractStartDate then 0
		when pfpd.Date > pfp.ContractEndDate then 0
		when pfpd.ReservedForContract = 0 then 0
		when pfp.ContractTypeID = (select ContractTypeID from dbo.ContractType where ContractType = ''Commercial'') then 0
		else coalesce(pfpd.ActualSellableEggs, pfpd.CalcSellableEggs)
	end,
SellableEggs_FromStandards = 
	case
		when pfpd.Date < pfp.ContractStartDate then 0
		when pfpd.Date > pfp.ContractEndDate then 0
		when pfp.ContractTypeID = (select ContractTypeID from dbo.ContractType where ContractType = ''Commercial'') then 0
		else coalesce(pfpd.ActualSellableEggs, pfpd.CalcSellableEggs)
	end,
SettableEggs = 
	case
		when pfpd.Date < pfp.ContractStartDate then 0
		when pfpd.Date > pfp.ContractEndDate then 0
		when pfpd.ReservedForContract = 0 then 0
		when pfp.ContractTypeID = (select ContractTypeID from dbo.ContractType where ContractType = ''Commercial'') then 0
		else coalesce(pfpd.OverwrittenSettableEggs, pfpd.ActualSettableEggs, pfpd.CalcSettableEggs)
	end,
SettableEggs_FromStandards = 
	case
		when pfpd.Date < pfp.ContractStartDate then 0
		when pfpd.Date > pfp.ContractEndDate then 0
		-- Changed by MCM on 3/3/2020
		-- when pfpd.ReservedForContract = 0 then 0
		when pfp.ContractTypeID = (select ContractTypeID from dbo.ContractType where ContractType = ''Commercial'') then 0
		else coalesce(pfpd.ActualSettableEggs, pfpd.CalcSettableEggs)
	end,
OverwrittenSettableEggs, -- this is what Corey overrides flocks
CommercialEggs = 
	case
		when pfpd.Date < pfp.CommercialStartDate then 0
		when pfpd.Date > pfp.CommercialEndDate then 0
		else coalesce(pfpd.ActualCommercialEggs, pfpd.CalcCommercialEggs)
	end
	+ 
	-- Plus anything that the contract can''t use
	case
		when pfpd.Date < pfp.CommercialStartDate then 0
		when pfpd.Date > pfp.CommercialEndDate then 0
		when pfp.ContractTypeID = (select ContractTypeID from dbo.ContractType where ContractType = ''Commercial'') then coalesce(pfpd.OverwrittenSettableEggs, pfpd.ActualSettableEggs, pfpd.CalcSettableEggs)
		when pfpd.Date < pfp.ContractStartDate then coalesce(pfpd.OverwrittenSettableEggs, pfpd.ActualSettableEggs, pfpd.CalcSettableEggs)
		when pfpd.Date > ContractEndDate then coalesce(pfpd.OverwrittenSettableEggs, pfpd.ActualSettableEggs, pfpd.CalcSettableEggs)
		when pfpd.ReservedForContract = 0 then coalesce(pfpd.OverwrittenSettableEggs, pfpd.ActualSettableEggs, pfpd.CalcSettableEggs)
		else 0
	end,
TotalCommercialAndContractEggs = coalesce(pfpd.OverwrittenSettableEggs, pfpd.ActualSettableEggs, pfpd.CalcSettableEggs) + coalesce(pfpd.ActualCommercialEggs, pfpd.CalcCommercialEggs), 
EggWeightClassificationID = coalesce(pfpd.ActualEggWeightClassificationID, pfpd.CalcEggWeightClassificationID),
ModifiedAfterOrderConfirm, 
OverrideModifiedAfterOrderConfirm,
pfp.PulletQtyAt16Weeks,
pfpd.CalcPulletQty,
ContractTypeID
from dbo.FlockSummary pfp
inner join dbo.PulletFarmPlanDetail pfpd on pfp.PulletFarmPlanID = pfpd.PulletFarmPlanID
inner join dbo.WeekEndingDate wed on pfpd.Date = wed.Date
where pfp.RemovalDate > pfpd.Date


' 
GO
