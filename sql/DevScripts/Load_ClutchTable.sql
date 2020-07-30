insert into Clutch (FlockID, LayDate, RackCnt, CaseCnt, ActualQty, IsActive)
select FlockID, LayDate, RackCnt, CaseCnt, EggCnt, 1
from [dbo].[LayDate_CurrentAndPredictions_Template] l
inner join Flock f on l.Flock = f.Flock