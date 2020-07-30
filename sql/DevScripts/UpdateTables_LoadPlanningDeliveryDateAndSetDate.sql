update lp set lp.SetDate = o.PlannedSetDate
from LoadPlanning lp
inner join [Order] o on lp.DeliveryDate = o.DeliveryDate

update o set o.LoadPlanningID = lp.LoadPlanningID
from LoadPlanning lp
inner join [Order] o on lp.DeliveryDate = o.DeliveryDate

