--select PulletFarmPlanID, FarmID, coalesce(ActualHatchDate, PlannedHatchDate), FlockNumber, dbo.GetFlockNumber (coalesce(ActualHatchDate, PlannedHatchDate), FarmID)
--from PulletFarmPlan
--where coalesce(ActualHatchDate, PlannedHatchDate) >= '01/01/2021'

update PulletFarmPlan
set FlockNumber = dbo.GetFlockNumber (coalesce(ActualHatchDate, PlannedHatchDate), FarmID)
where coalesce(ActualHatchDate, PlannedHatchDate) >= '01/01/2021'