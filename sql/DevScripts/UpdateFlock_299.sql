select *
from PulletFarmPlan
where FarmID = 52

select *
from PulletFarmPlanDetail
where PulletFarmPlanID = 107

select *
from dbo.RollingWeeklySchedule
where PulletFarmPlanID = 107

select *
from FlockSummary
where PulletFarmPlanID = 107

update PulletFarmPlan set PulletQtyAt16Weeks = 17200
where PulletFarmPlanID = 107

delete from PulletFarmPlanDetail where PulletFarmPlanID = 107

execute [dbo].[PulletFarmPlanDetail_InsertUpdate] 
	107, 
	1, 
	0