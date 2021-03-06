USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Invoice_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Invoice_Get]
GO
/****** Object:  StoredProcedure [dbo].[Invoice_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Invoice_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Invoice_Get] AS' 
END
GO


ALTER proc [dbo].[Invoice_Get] 
@InvoiceID int = null
,@LotNbr nvarchar(255) = null
,@DestinationBuildingID int = null
,@DeliveryDate_Start date = null
,@DeliveryDate_End date = null

as

select @LotNbr = nullif(@LotNbr, ''), 
@DestinationBuildingID = nullif(@DestinationBuildingID, ''),
@DeliveryDate_Start = isnull(nullif(@DeliveryDate_Start, ''), '01/01/2000'), 
@DeliveryDate_End = isnull(nullif(@DeliveryDate_End, ''), '12/12/3000')

declare @InvoiceList table (InvoiceID int, InvoiceNbr varchar(100), InvoiceDate date, CreatedDate date, DueDate date, DestinationBuildingID int, 
EggsDelivered int, UnitPrice numeric(19,9), InvoiceAmount money, DeliveryCharge money, 
Printed bit, Uploaded bit, Cancelled bit, Paid bit, IsActive bit, EggsInvoiced int, ChargeForEggsInvoiced money,
Notes varchar(1000), LotNbr varchar(20), DeliveryDate date, CummulativeQty int, Terms int, DeliveryCount int, OrderID int)


-- Invoices already created
insert into @InvoiceList (InvoiceID, InvoiceNbr, InvoiceDate, CreatedDate, DueDate, DestinationBuildingID, 
EggsDelivered, UnitPrice, InvoiceAmount, DeliveryCharge, Printed, Uploaded, Cancelled, Paid, IsActive, 
EggsInvoiced, ChargeForEggsInvoiced, Notes, LotNbr, DeliveryDate, CummulativeQty, OrderID, DeliveryCount)
select i.InvoiceID, InvoiceNbr, InvoiceDate, CreatedDate, DueDate, DestinationBuildingID, 
EggsDelivered, UnitPrice, InvoiceAmount, DeliveryCharge, 
isnull(Printed,0), isnull(Uploaded,0), isnull(Cancelled,0), isnull(Paid,0), IsActive, 
isnull(EggsInvoiced, EggsDelivered) as EggsInvoiced, ChargeForEggsInvoiced, Notes, LotNbr, DeliveryDate,
i.AccumulatedEggCount, o.OrderID, 
DeliveryCount = 
	case
		when o.OrderStatusID = 5 then 0
		else d.DeliveryCount
	end
from Invoice i
inner join OrderInvoice oi on i.InvoiceID = oi.InvoiceID
inner join [Order] o on oi.OrderID = o.OrderID
left outer join 
(
	select OrderID, count(*) as DeliveryCount
	from OrderDelivery od
	group by OrderID
) d on o.OrderID = d.OrderID
where isnull(Cancelled,0) = 0
order by InvoiceDate, AccumulatedEggCount


declare @LastAccumulatedEggQty int, @LastAccumulatedEggYear int

select top 1 @LastAccumulatedEggQty = AccumulatedEggCount, @LastAccumulatedEggYear = DatePart(Year,InvoiceDate)
from Invoice 
order by InvoiceDate desc, InvoiceID desc


-- Add in orders that have NOT been cancelled!
-- and are ready to be invoiced
-- This means that the OrderStatusID = 4 (Delivery Slip has been printed!)
insert into @InvoiceList (InvoiceID, InvoiceNbr, InvoiceDate, CreatedDate, DueDate, DestinationBuildingID, 
EggsDelivered, UnitPrice, InvoiceAmount, DeliveryCharge, Printed, Uploaded, Cancelled, Paid, IsActive, 
EggsInvoiced, ChargeForEggsInvoiced, Notes, LotNbr, DeliveryDate, OrderID, DeliveryCount)
select InvoiceID = 0
, InvoiceNbr = LotNbr
, InvoiceDate = null
, CreatedDate = null
, DueDate = null
, DestinationBuildingID
, EggsDelivered = sum(d.ActualQty)
, UnitPrice = null
, InvoiceAmount = null
, DeliveryCharge = null
, Printed = 0
, Uploaded = 0
, Cancelled = 0
, Paid = 0
, IsActive = null
, EggsInvoiced = sum(coalesce(nullif(d.ActualQty, 0), d.PlannedQty))
, ChargeForEggsInvoiced = null
, Notes = null
, LotNbr = LotNbr
, DeliveryDate
, o.OrderID
, count(distinct od.DeliveryID) as DeliveryCount
from [Order] o
inner join OrderDelivery od on o.OrderID = od.OrderID
inner join Delivery d on od.DeliveryID = d.DeliveryID
where OrderStatusID = 4	-- Delivery slips should have already been printed!
and not exists (select 1 from @InvoiceList where InvoiceNbr = o.LotNbr)	--just in case 
group by o.OrderID, LotNbr, DeliveryDate, DestinationBuildingID, OrderStatusID


-- Add in orders that WERE CANCELLED!
-- This means that the OrderStatusID = 5 (Order Cancelled)
insert into @InvoiceList (InvoiceID, InvoiceNbr, InvoiceDate, CreatedDate, DueDate, DestinationBuildingID, 
EggsDelivered, UnitPrice, InvoiceAmount, DeliveryCharge, Printed, Uploaded, Cancelled, Paid, IsActive, 
EggsInvoiced, ChargeForEggsInvoiced, Notes, LotNbr, DeliveryDate, OrderID, DeliveryCount)
select InvoiceID = 0
, InvoiceNbr = LotNbr
, InvoiceDate = null
, CreatedDate = null
, DueDate = null
, DestinationBuildingID
, EggsDelivered = 0
, UnitPrice = null
, InvoiceAmount = null
, DeliveryCharge = null
, Printed = 0
, Uploaded = 0
, Cancelled = 0
, Paid = 0
, IsActive = null
, EggsInvoiced = sum(o.PlannedQty)
, ChargeForEggsInvoiced = null
, Notes = null
, LotNbr = LotNbr
, DeliveryDate
, o.OrderID
, 0 as DeliveryCount
from [Order] o
left outer join OrderDelivery od on o.OrderID = od.OrderID
left outer join Delivery d on od.DeliveryID = d.DeliveryID
where OrderStatusID = 5	-- the order was cancelled...
and not exists (select 1 from @InvoiceList where InvoiceNbr = o.LotNbr)	--just in case 
group by o.OrderID, LotNbr, DeliveryDate, DestinationBuildingID, OrderStatusID


update il set il.CummulativeQty = 
case
	when datepart(Year, il.DeliveryDate) = @LastAccumulatedEggYear then @LastAccumulatedEggQty + d.CummulativeQty
	else d.CummulativeQty
end
from @InvoiceList il 
inner join 
(
	select InvoiceID, InvoiceNbr, CummulativeQty = 
		sum(EggsInvoiced) over 
			   (partition by datepart(Year, DeliveryDate) order by isnull(InvoiceDate, DeliveryDate) ROWS UNBOUNDED PRECEDING)
	from @InvoiceList 
	where InvoiceID =0
) d on il.InvoiceNbr = d.InvoiceNbr


select InvoiceNbr, InvoiceDate, DeliveryDate, DueDate, CreatedDate,
EggsDelivered = dbo.FormatIntComma(EggsDelivered), 
EggsInvoiced = dbo.FormatIntComma(EggsInvoiced), 
CummulativeQty = dbo.FormatIntComma(CummulativeQty), 
ChargeForEggsInvoiced = dbo.FormatMoney(ChargeForEggsInvoiced),
DeliveryCharge = dbo.FormatMoney(DeliveryCharge), 
InvoiceAmount = dbo.FormatMoney(InvoiceAmount),
Printed, Uploaded, Paid, Cancelled, OrderID, InvoiceID, 
UnitPrice = isnull(il.UnitPrice, e.UnitPrice), LotNbr,
BlankField = convert(varchar, null), DeliveryCount,
NoFormat_EggsDelivered = EggsDelivered,
NoFormat_EggsInvoiced = EggsInvoiced,
--CummulativeQty = dbo.FormatIntComma(CummulativeQty), 
--ChargeForEggsInvoiced = dbo.FormatMoney(ChargeForEggsInvoiced),
NoFormat_DeliveryCharge = DeliveryCharge
from @InvoiceList il
inner join EggUnitPrice e on il.CummulativeQty between e.MinEggCount and e.MaxEggCount and il.DeliveryDate between e.FromDate and e.ToDate
where isnull(InvoiceID,0) = isnull(@InvoiceID, isnull(InvoiceID,0))
and LotNbr = isnull(@LotNbr, LotNbr)
and DestinationBuildingID = isnull(@DestinationBuildingID, DestinationBuildingID)
and DeliveryDate between @DeliveryDate_Start and @DeliveryDate_End
order by DeliveryDate



GO
