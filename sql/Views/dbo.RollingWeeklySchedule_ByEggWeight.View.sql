
/****** Object:  View [dbo].[RollingWeeklySchedule_ByEggWeight]    Script Date: 3/9/2020 7:27:09 PM ******/
--DROP VIEW IF EXISTS [dbo].RollingWeeklySchedule_ByEggWeight
--GO
/****** Object:  View [dbo].[RollingWeeklySchedule_ByEggWeight]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[RollingWeeklySchedule_ByEggWeight]'))
EXEC dbo.sp_executesql @statement = N'--drop view RollingWeeklySchedule_ByEggWeight
--go

create view [dbo].[RollingWeeklySchedule_ByEggWeight] 
with SCHEMABINDING
as 

select 
	PulletFarmPlanID, 
	CalcPulletQty = 
		sum(
			--case
			--	when WeekNumber between 24 and 65 then CalcPulletQty
			--	else 0
			--end
			case
				when ContractTypeID = 3 and Date between CommercialStartDate and CommercialEndDate then CalcPulletQty
				when Date between ContractStartDate and ContractEndDate then CalcPulletQty
				else 0
			end
			) / 7,
	CalcPulletQty_NotProrated = 
		max(
			case
				when ContractTypeID = 3 and Date between CommercialStartDate and CommercialEndDate then CalcPulletQty
				when Date between ContractStartDate and ContractEndDate then CalcPulletQty
				else 0
			end
			),
	UseSourceType = 
		case
			when PlannedOrActual = ''A'' then ''Actual''
			else ''Planned''
		end,
	WeekEndingDate,
	CalcSellableEggs = sum(SellableEggs),
	CalcSettableEggs = sum(SettableEggs),
	CalcCommercialEggs = sum(CommercialEggs),
	TotalCommercialAndContractEggs = sum(TotalCommercialAndContractEggs),
	ModifiedAfterOrderConfirm, 
	OverrideModifiedAfterOrderConfirm,
	PulletQtyAt16Weeks,
	ContractTypeID, 
	FlockStartDate = ContractStartDate,
	FlockEndDate = ContractEndDate,
	CommercialStartDate, 
	CommercialEndDate,
	CalcEggWeightClassificationID = EggWeightClassificationID, 
	FarmID, 
	CalcDays = sum(
		case
			when SettableEggs > 0 then 1
			else 0
		end
		)
from dbo.RollingDailySchedule
group by PulletFarmPlanID, WeekEndingDate, ModifiedAfterOrderConfirm, 
OverrideModifiedAfterOrderConfirm, PulletQtyAt16Weeks, ContractTypeID, PlannedOrActual,
ContractStartDate, ContractEndDate, EggWeightClassificationID, 
FarmID, 
CommercialStartDate, CommercialEndDate


--go

--create unique clustered index idxUniqueIndex on dbo.RollingWeeklySchedule(UniqueIndex)
--create nonclustered index idxPulletFarmPlanID on dbo.RollingWeeklySchedule(PulletFarmPlanID)
--create nonclustered index idxWeekEndingDate on dbo.RollingWeeklySchedule(WeekEndingDate)
--create nonclustered index idxContractTypeID on dbo.RollingWeeklySchedule(ContractTypeID)
' 
GO
