select *
from Farm
where FarmNumber = '218'

select *
from Flock
where FarmID = 38
order by HatchDate desc
-- FlockID = 124

select *
from LoadPlanning_Detail
where LoadPlanningID = 2851

insert into LoadPlanning_Detail (LoadPlanningID, FlockID, FlockQty, LastCandleoutPercent)
select 2851, 124, 27648, 87.00

select *
from Orig_Flock

update LoadPlanning_Detail set FlockQty = 27648
where LoadPlanning_DetailID = 10243


IF EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'dbo.LoadPlanning_Detail')
   AND parent_object_id = OBJECT_ID(N'dbo.Orig_Flock')
)
  ALTER TABLE [dbo.TableName] DROP CONSTRAINT [FK_TableName_TableName2]