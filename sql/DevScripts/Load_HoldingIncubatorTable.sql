delete from HoldingIncubator

SET IDENTITY_INSERT dbo.HoldingIncubator ON;  

insert into HoldingIncubator (HoldingIncubatorID, HoldingIncubator, CartCapacity, SortOrder, IsActive, TopLeftLocationNbr)
select 1, 34, 28, 1, 1, 23 union all
select 2, 35, 28, 2, 1, 23 union all
select 3, 36, 28, 3, 1, 23 union all
select 4, 43, 28, 4, 1, 23 union all
select 5, 44, 28, 5, 1, 23 union all
select 6, 45, 28, 6, 1, 23

SET IDENTITY_INSERT dbo.HoldingIncubator OFF;  

select *
from HoldingIncubator