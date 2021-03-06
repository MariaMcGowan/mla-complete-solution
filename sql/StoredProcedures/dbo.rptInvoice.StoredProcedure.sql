USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[rptInvoice]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[rptInvoice]
GO
/****** Object:  StoredProcedure [dbo].[rptInvoice]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rptInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[rptInvoice] AS' 
END
GO


ALTER proc [dbo].[rptInvoice] @DeliveryDate date = null, @LotNbr varchar(100) = null
as

--declare @DeliveryDate date = null, @LotNbr varchar(100) = null
--set @LotNbr = '1646001'

declare @OrderID int
declare @DeliverySlips varchar(100)
declare @Counter int = 0
declare @MaxCounter int

if @DeliveryDate is null
	set @DeliveryDate = getdate()

create table #OrderList (ID int identity(1,1), OrderID int, DeliverySlips varchar(100))

insert into #OrderList (OrderID)
select OrderID 
from [Order]
where OrderStatusID <> 5
and isnull(LotNbr, '') <> ''
and isnull(DeliveryDate, '01/01/1900') <> '01/01/1900'
and (DeliveryDate = isnull(@DeliveryDate, '01/01/1900') or LotNbr = isnull(@LotNbr, 'XXXXXXXX'))

select @MaxCounter = max(ID) from #OrderList

while @Counter < @MaxCounter
begin
	select @Counter = @Counter + 1

	select @OrderID = OrderID from #OrderList o where ID = @Counter

	select @DeliverySlips = ''
	select @DeliverySlips = @DeliverySlips + ', ' + DeliverySlip
	from OrderDelivery od
	inner join Delivery d  on od.DeliveryID = d.DeliveryID
	where OrderID = @OrderID

	if left(@DeliverySlips,2) = ', ' 
	begin
		select @DeliverySlips = substring(@DeliverySlips, 3, 100)
	end

	update #OrderList set DeliverySlips = @DeliverySlips where OrderID = @OrderID
end

update i set i.Printed = 1
from #OrderList ol 
inner join [Order] o on ol.OrderID = o.OrderID
inner join OrderInvoice oi on o.OrderID = oi.OrderID
inner join Invoice i on oi.InvoiceID = i.InvoiceID
where i.IsActive = 1



select I.InvoiceID, InvoiceNbr, EggsInvoiced as EggQuantity, UnitPrice, 
i.ChargeForEggsInvoiced as AmountDue,  cast(round(DeliveryCharge, 2) as numeric(19,2)) as DeliveryCharge, 
i.InvoiceAmount as TotalAmount, 
Printed, Uploaded, Cancelled, Paid, i.IsActive, CONVERT(char(10), InvoiceDate,101) as InvoiceDate, 
o.CustomerReferenceNbr, CONVERT(char(10), DeliveryDate,101) as DeliveryDate, DeliverySlips, isnull(i.Notes,'') as Notes, 
db.InvoiceContactInfo, 
db.Address1 as InvoiceAddr1, db.Address2 as InvoiceAddr2, 
rtrim(db.City) + ' ' + ltrim(rtrim(db.State)) + ' ' + ltrim(rtrim(db.Zip)) as InvoiceAddr3
from #OrderList ol 
inner join [Order] o on ol.OrderID = o.OrderID
inner join OrderInvoice oi on o.OrderID = oi.OrderID
inner join Invoice i on oi.InvoiceID = i.InvoiceID
inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
where i.IsActive = 1

drop table #OrderList


update [Order] set OrderStatusID = 6 where OrderID = @OrderID



GO
