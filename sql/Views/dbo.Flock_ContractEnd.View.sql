--DROP VIEW IF EXISTS [dbo].Flock_ContractEnd
--GO
/****** Object:  View [dbo].[Flock_ContractEnd]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Flock_ContractEnd]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[Flock_ContractEnd] 
with SCHEMABINDING
as 

select PulletFarmPlanID, EndDate = min(date)
from 
(
	select 
		PulletFarmPlanID
		, Source = ''Based on Removal Date''
		, Date = dateadd(day,-1,pfp.ProductionFarm_RemoveDate)
	from dbo.PulletFarmPlan pfp
	where ProductionFarm_RemoveDate is not null
	union all
	select
		PulletFarmPlanID
		, Source = ''Actual End Date''
		, Date = pfp.ActualEndDate
	from dbo.PulletFarmPlan pfp
	where ActualEndDate is not null
	union all
	select 
		PulletFarmPlanID
		, Source = ''65 Week Date''
		, coalesce(pfp.Actual65WeekDate, pfp.Planned65WeekDate)
	from dbo.PulletFarmPlan pfp
) d
group by PulletFarmPlanID '

go
