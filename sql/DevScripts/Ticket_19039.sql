select *
from LoadPlanning
where LoadPlanningID = 2851


select FlockID, Keep = min(LoadPlanning_DetailID), 
Discard = max(LoadPlanning_DetailID)
into #DeleteMe
from LoadPLanning_Detail d
where LoadPlanningID = 2851
group by FlockID
having min(LoadPlanning_DetailID) <> max(LoadPlanning_DetailID)

delete from LoadPlanning_Detail
where LoadPlanning_DetailID in 
(select Discard from #DeleteMe)


