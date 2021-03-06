USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ReadyToInvoice_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ReadyToInvoice_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[ReadyToInvoice_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReadyToInvoice_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReadyToInvoice_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[ReadyToInvoice_InsertUpdate]
	@I_vOrderID int
	, @I_vSelected bit
    , @I_vLotNbr varchar(20) = null
    , @I_vDeliveredQty int = null
	, @I_vInvoiceQty int = null
    , @I_vUnitPrice numeric(19,10) = null
    , @I_vDeliveryCharge money = null
	, @I_vDeliveryDate date = null
    , @I_vTerms int = 20
	, @O_iErrorState int=0 output
	, @oErrString varchar(255)='' output
	, @iRowID varchar(255)=NULL output
AS

declare @InvoiceID int = 0
declare @OrderStatusID int

select @OrderStatusID = OrderStatusID
from [order] o
where OrderID = @I_vOrderID


select @I_vSelected = nullif(@I_vSelected, '')

if isnull(@I_vSelected ,0) = 1
begin
	select @I_vInvoiceQty = nullif(@I_vInvoiceQty, 0), 
	@I_vDeliveredQty = nullif(@I_vDeliveredQty, 0)

	if @I_vDeliveredQty is null
	begin
		select @I_vDeliveredQty = OrderQty
		from [order] o 
		where OrderID = @I_vOrderID
	end

	if @I_vInvoiceQty is null
	begin
		select @I_vInvoiceQty = sum(isnull(nullif(d.ActualQty,0), d.PlannedQty))
		from [Order] o
		left outer join OrderDelivery od on o.OrderID = od.OrderID
		left outer join OrderInvoice oi on o.OrderID = oi.OrderID
		left outer join Invoice i on oi.InvoiceID = i.InvoiceID
		left outer join Delivery d on od.DeliveryID = d.DeliveryID
		where o.OrderID = @I_vOrderID
	end

	select @I_vInvoiceQty = isnull(@I_vInvoiceQty, @I_vDeliveredQty)

	if not exists 
	(
		select 1 
		from OrderInvoice oi
		inner join Invoice i on oi.InvoiceID = i.InvoiceID
		where OrderID = @I_vOrderID and i.IsActive = 1
	)
	begin
		-- Create the invoice and then associate it with the order
		select @I_vLotNbr = nullif(@I_vLotNbr, '')

		if @I_vLotNbr is null
		begin
			select @I_vLotNbr = LotNbr from [order] where OrderID = @I_vOrderID
		end

		declare @Invoice table (InvoiceID int)
		insert into Invoice (InvoiceNbr) 
		output inserted.InvoiceID into @Invoice(InvoiceID)
		select @I_vLotNbr

		select top 1 @InvoiceID = InvoiceID from @Invoice

		insert into OrderInvoice (OrderID, InvoiceID)
		select @I_vOrderID, @InvoiceID

	end
	else
	begin
		select top 1 @InvoiceID = InvoiceID from OrderInvoice where OrderID = @I_vOrderID
	end


	declare @LastAccumulatedEggQty int, @LastAccumulatedEggYear int

	select top 1 @LastAccumulatedEggQty = AccumulatedEggCount, @LastAccumulatedEggYear = DatePart(Year,InvoiceDate)
	from Invoice 
	order by InvoiceDate desc, InvoiceID desc


	-- Update the invoice
	update Invoice set 
		InvoiceDate = @I_vDeliveryDate,
		CreatedDate = getdate(), 
		DueDate = dateadd(day,@I_vTerms,@I_vDeliveryDate),
		EggsDelivered = @I_vDeliveredQty,
		EggsInvoiced = @I_vInvoiceQty,
		AccumulatedEggCount = 
			case
				when datepart(Year, @I_vDeliveryDate) = @LastAccumulatedEggYear then @LastAccumulatedEggQty + @I_vInvoiceQty
				else @I_vInvoiceQty
			end,
		UnitPrice = @I_vUnitPrice, 
		ChargeForEggsInvoiced = round((@I_vInvoiceQty * @I_vUnitPrice), 2),
		InvoiceAmount = round((@I_vInvoiceQty * @I_vUnitPrice), 2) + isnull(@I_vDeliveryCharge, 0),
		DeliveryCharge = @I_vDeliveryCharge, 
		IsActive = 1
	where InvoiceID = @InvoiceID

	-- Also update the Order Deliveries
	update d  set d.InvoiceID = @InvoiceID 
	from OrderDelivery od 
	inner join Delivery d on od.DeliveryID = d.DeliveryID
	where OrderID = @I_vOrderID

	-- Update OrderStatus
	update o set o.OrderStatusID = 6	-- InvoicePrinted!
	from [Order] o 
	inner join OrderInvoice oi on o.OrderID = oi.OrderID
	where InvoiceID = @InvoiceID

	select @InvoiceID as InvoiceID, 'forward' as referenceType

end




GO
