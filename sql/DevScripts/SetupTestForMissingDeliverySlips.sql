
select OrderDeliveryID, o.OrderID, LotNbr, DeliverySlip, DeliveryDate
from [order] o
inner join OrderDelivery od
on o.OrderID = od.OrderID
where isnull(OrderStatusID,0) <> 5
order by DeliveryDate, DeliverySlip


update MLA_test.dbo.OrderDelivery set DeliverySlip = null where OrderDeliveryID = 7