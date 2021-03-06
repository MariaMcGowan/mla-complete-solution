USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ReadyToInvoice_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ReadyToInvoice_Get]
GO
/****** Object:  StoredProcedure [dbo].[ReadyToInvoice_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReadyToInvoice_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReadyToInvoice_Get] AS' 
END
GO


ALTER proc [dbo].[ReadyToInvoice_Get] 
as

	-- An invoiceID  is associated to an order and one or more deliveries within the order
	-- The orderid is the invoice header, the deliveries are the invoice lines

	declare @OrderHistory table (OrderID int, LotNbr varchar(20), DestinationBuildingID int, DeliveryDate date, DeliveryCnt int, 
	DeliveredQty int, CummulativeQty int, InvoiceQty int)

	insert into @OrderHistory (OrderID, LotNbr, DestinationBuildingID, DeliveryDate, DeliveryCnt, DeliveredQty, InvoiceQty, CummulativeQty)
	select OrderID, LotNbr, DestinationBuildingID, 
	DeliveryDate, DeliveryCnt, DeliveredQty, isnull(EggsInvoiced, DeliveredQty),
	CummulativeQty = sum(isnull(EggsInvoiced, DeliveredQty)) over 
	   (partition by DeliveryYear order by DeliveryDate ROWS UNBOUNDED PRECEDING)
	from
	(
		select o.OrderID, LotNbr, DestinationBuildingID, DeliveryDate, 
		datepart(Year, DeliveryDate) as DeliveryYear, 
		count(d.DeliveryID) as DeliveryCnt, sum(d.ActualQty) as DeliveredQty, i.EggsInvoiced
		from [Order] o
		inner join OrderDelivery od on o.OrderID = od.OrderID
		left outer join OrderInvoice oi on o.OrderID = oi.OrderID
		left outer join Invoice i on oi.InvoiceID = i.InvoiceID
		inner join Delivery d on od.DeliveryID = d.DeliveryID
		where OrderStatusID <> 5	-- the order has not been cancelled
		and isnull(i.Cancelled,0) = 0 -- the invoice has not been cancelled
		group by o.OrderID, LotNbr, DeliveryDate, DestinationBuildingID, i.EggsInvoiced
	) a


	select oh.OrderID, LotNbr, DestinationBuildingID, DeliveryDate, DeliveryCnt, InvoiceQty, DeliveredQty, 
	CummulativeQty, e.UnitPrice,
	cast(0 as money) as DeliveryCharge, 0 as InvoiceID, cast(null as bit) as Selected, 20 as Terms
	from @OrderHistory oh
	inner join EggUnitPrice e on oh.CummulativeQty between e.MinEggCount and e.MaxEggCount and oh.DeliveryDate between e.FromDate and e.ToDate
	left outer join OrderInvoice oi on oh.OrderID = oi.OrderID
	where DeliveryDate < getdate()	-- the order is marked as delivered
	and not exists 
	(select 1 from OrderDelivery where OrderID = oh.OrderID and InvoiceID is not null)
	and e.IsActive = 1



GO
