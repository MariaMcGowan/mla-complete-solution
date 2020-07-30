select Row_Number() over (Order by Flock) as NewSortOrder, FlockID, FLock
into tempFlockOrder
from Flock
where IsActive = 1
order by Flock

update Flock set SortOrder = isnull(SortOrder, 0) + 100 where IsActive = 0


update fl set SortOrder = NewSortOrder
from Flock fl
inner join tempFlockOrder fix on fl.FlockID = fix.FlockID

drop table tempFlockOrder