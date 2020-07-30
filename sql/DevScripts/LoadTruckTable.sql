SET IDENTITY_INSERT dbo.Truck ON;  

insert into Truck (TruckID, Truck, SortOrder, IsActive)
select 1, 1, 1, 1 union all
select 2, 2, 2, 1 union all
select 3, 3, 3, 1 union all
select 4, 4, 4, 1 union all
select 5, 5, 5, 1 union all
select 6, 6, 6, 1 union all
select 7, 7, 7, 1 union all
select 8, 8, 8, 1 union all
select 9, 9, 9, 1 union all
select 10, 10, 10, 1 union all
select 11, 11, 11, 1 union all
select 12, 12, 12, 1

SET IDENTITY_INSERT dbo.Truck OFF;  

select *
from Truck