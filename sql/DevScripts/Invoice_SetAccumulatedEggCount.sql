select i.InvoiceID, 
CummulativeQty = sum(isnull(EggsInvoiced, i.EggsDelivered)) over 
	   (partition by datepart(Year, DeliveryDate) order by InvoiceDate ROWS UNBOUNDED PRECEDING)
into #AccumulatedEggCount
from Invoice i
inner join OrderInvoice oi on i.InvoiceID = oi.InvoiceID
inner join [Order] o on oi.OrderID = o.OrderID
where isnull(Cancelled,0) = 0
order by InvoiceDate 

update i set i.AccumulatedEggCount = a.CummulativeQty
from Invoice i
inner join #AccumulatedEggCount a on i.InvoiceID = a.InvoiceID

drop table #AccumulatedEggCount