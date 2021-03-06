
/****** Object:  View [dbo].[FlockSummary]    Script Date: 3/9/2020 7:27:09 PM ******/
--DROP VIEW IF EXISTS [dbo].[FlockSummary]
--GO
/****** Object:  View [dbo].[FlockSummary]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[FlockSummary]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[FlockSummary] 
with SCHEMABINDING
as 

select pfp.PulletFarmPlanID
	, FlockNumber
	, FarmID
	, ContractTypeID
	, PlannedOrActual = 
		case
			when pfp.ActualHatchDate is not null then ''A''
			else ''P''
		end
	, ContractStartDate = 
		case
			when pfp.ActualHatchDate is not null then coalesce(pfp.ActualStartDate, pfp.Actual24WeekDate)
			else coalesce(pfp.PlannedStartDate, pfp.Planned24WeekDate)
		end	
	, ContractEndDate = fce.EndDate
	, CommercialStartDate = 
		case
			when pfp.ActualHatchDate is not null then pfp.Actual16WeekDate
			else pfp.Planned16WeekDate
		end
	, CommercialEndDate = 
		case
			when pfp.ActualHatchDate is not null then coalesce(dateadd(day,-1,pfp.ProductionFarm_RemoveDate), pfp.ActualCommercialEndDate, dateadd(week,65,pfp.ActualHatchDate))
			else coalesce(dateadd(day,-1,pfp.ProductionFarm_PlannedRemoveDate), pfp.PlannedCommercialEndDate, dateadd(week,65,pfp.PlannedHatchDate))
		end
	, HatchDate = 
		case
			when pfp.ActualHatchDate is not null then pfp.ActualHatchDate
			else pfp.PlannedHatchDate
		end
	, RemovalDate = 
		case
			-- Changed on 12/30/2019
			-- if the removal date is not filled in, assume that it is the day following the 65 week date.
			when pfp.ActualHatchDate is not null then coalesce(pfp.ProductionFarm_RemoveDate, dateadd(day,(65 * 7) + 1,pfp.ActualHatchDate))
			else coalesce(pfp.ProductionFarm_PlannedRemoveDate, dateadd(day,(65 * 7) + 1,pfp.PlannedHatchDate))
		end
	, ModifiedAfterOrderConfirm
	, OverrideModifiedAfterOrderConfirm
	, PulletQtyAt16Weeks
from dbo.PulletFarmPlan pfp
left outer join dbo.Flock_ContractEnd fce on pfp.PulletFarmPlanID = fce.PulletFarmPlanID
where ContractTypeID <> 4
' 
GO
