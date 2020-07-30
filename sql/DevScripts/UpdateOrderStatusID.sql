select OrderStatusID, count(*)
from [Order]
group by OrderStatusID
order by 1

update [Order] set OrderStatusID = null where OrderStatusID <> 5

update o set o.OrderStatusID = 6
from [Order] o 
inner join OrderInvoice oi on o.OrderID = oi.OrderID
where OrderStatusID is null


update o set o.OrderStatusID = 3
from [Order] o
inner join OrderDelivery od on o.OrderID = od.OrderID
inner join Delivery d on d.DeliveryID = od.DeliveryID
where d.HoldingIncubatorID is not null  and OrderStatusID is null


update o set o.OrderStatusID = 2
from [Order] o
inner join OrderIncubator oi on o.OrderID = oi.OrderID
inner join OrderIncubatorCart oic on oi.OrderIncubatorID = oic.OrderIncubatorID
where OrderStatusID is null


update o set o.OrderStatusID = 1
from [Order] o
where OrderStatusID is null

update [Order] set OrderStatusID = 4 where DeliveryDate < getdate()

select OrderStatusID, count(*)
from [Order]
group by OrderStatusID
order by 1
