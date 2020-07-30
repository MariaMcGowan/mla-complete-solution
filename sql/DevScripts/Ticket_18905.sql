select *
from Incubator 
where Incubator = '324'
-- IncubatorID = 150

select o.OrderID, LotNbr, oi.OrderIncubatorID
from [Order] o
inner join OrderIncubator oi on o.OrderID = oi.OrderID
inner join Incubator i on oi.IncubatorID = i.IncubatorID
where DeliveryDate = '04/30/2020'
and Incubator = 310
-- OrderIncubatorID = 5555

update OrderIncubator set IncubatorID = 150 where OrderIncubatorID = 5555


select *
from Incubator 
where Incubator = '325'
-- IncubatorID = 151


select o.OrderID, LotNbr, oi.OrderIncubatorID
from [Order] o
inner join OrderIncubator oi on o.OrderID = oi.OrderID
inner join Incubator i on oi.IncubatorID = i.IncubatorID
where DeliveryDate = '04/30/2020'
and Incubator = 311
-- OrderIncubatorID = 5556

update OrderIncubator set IncubatorID = 151 where OrderIncubatorID = 5556