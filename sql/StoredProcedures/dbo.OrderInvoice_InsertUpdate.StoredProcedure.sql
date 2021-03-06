USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderInvoice_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderInvoice_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OrderInvoice_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderInvoice_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderInvoice_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[OrderInvoice_InsertUpdate]
	@I_vOrderInvoiceID int = null
	, @I_vOrderID int = null
	, @I_vInvoiceID int = null
	, @I_vInvoiceNbr varchar(10) = null
	, @I_vInvoiceDate date = null
	, @I_vCreatedDate date = null
	, @I_vDueDate date = null
	, @I_vEggsDelivered varchar(100)
	, @I_vEggsInvoiced varchar(100) = null
	, @I_vUnitPrice numeric(19,10) 
	, @I_vDeliveryCharge varchar(100) = null
	, @I_vPrinted bit = null
	, @I_vUploaded bit = null
	, @I_vPaid bit = null
	, @I_vCancelled bit = null
	, @I_vCummulativeQty varchar(100)
	, @I_vUserName varchar(255) = null
	, @I_vNotes varchar(500) = null
	, @O_iErrorState int=0 output
	, @oErrString varchar(255)='' output
	, @iRowID varchar(255)=NULL output
AS

declare 
	@EggsDelivered int
	, @EggsInvoiced int
	, @DeliveryCharge money
	, @AccumulatedEggCount int

	select @EggsDelivered = dbo.StripOutMoneyFormat(@I_vEggsDelivered)
	, @EggsInvoiced = dbo.StripOutFormatForInt(@I_vEggsInvoiced)
	, @DeliveryCharge = dbo.StripOutMoneyFormat(@I_vDeliveryCharge)
	, @AccumulatedEggCount = dbo.StripOutFormatForInt(@I_vCummulativeQty)


	select @EggsInvoiced = nullif(@EggsInvoiced, 0)
	select @EggsInvoiced = isnull(@EggsInvoiced, @EggsDelivered)


-- Update the invoice
update Invoice set 
	InvoiceDate = @I_vInvoiceDate,
	CreatedDate = @I_vCreatedDate, 
	DueDate = @I_vDueDate, 
	EggsDelivered = @EggsDelivered,
	EggsInvoiced = @EggsInvoiced,
	UnitPrice = @I_vUnitPrice, 
	ChargeForEggsInvoiced = round((@EggsInvoiced * @I_vUnitPrice),2),
	DeliveryCharge = @DeliveryCharge, 
	InvoiceAmount = round((@EggsInvoiced * @I_vUnitPrice),2) + @DeliveryCharge, 
	Printed = @I_vPrinted, 
	Uploaded = @I_vUploaded, 
	Paid = @I_vPaid,
	Cancelled = @I_vCancelled,
	AccumulatedEggCount = @AccumulatedEggCount,
	Notes = @I_vNotes,
	IsActive = case when Cancelled = 1 then 0 else 1 end
where InvoiceID = @I_vInvoiceID

if @I_vCancelled = 1
begin
	execute Invoice_Delete @I_vInvoiceID = @I_vInvoiceID
end




GO
