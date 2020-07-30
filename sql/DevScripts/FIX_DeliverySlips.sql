--select OrderDeliveryID, o.OrderID, LotNbr, DeliverySlip, Processed = 0
--into FIX_OrderDeliverySlip
--from [order] o
--inner join OrderDelivery od
--on o.OrderID = od.OrderID

while exists (select 1 from FIX_OrderDeliverySlip where Processed = 0)
begin
	declare @OrderDeliveryID int 

	select top 1 @OrderDeliveryID = OrderDeliveryID
	from FIX_OrderDeliverySlip
	where Processed = 0
	order by OrderDeliveryID

	update OrderDelivery set DeliverySlip = 
	(
		select rtrim(f.LotNbr) + '.' + right('00' + 
			cast(((select count(1) from OrderDelivery od2 where od2.OrderID = f.OrderID and IsNull(DeliverySlip,'') <> '')+ 1) as varchar),2)
		from FIX_OrderDeliverySlip f
		where OrderDeliveryID = @OrderDeliveryID
	)
	where OrderDeliveryID = @OrderDeliveryID

	update FIX_OrderDeliverySlip set Processed = 1 where OrderDeliveryID = @OrderDeliveryID

end


select OrderDeliveryID, o.OrderID, LotNbr, DeliverySlip, DeliveryDate
from [order] o
inner join OrderDelivery od
on o.OrderID = od.OrderID
where isnull(OrderStatusID,0) <> 5
order by DeliveryDate, DeliverySlip


