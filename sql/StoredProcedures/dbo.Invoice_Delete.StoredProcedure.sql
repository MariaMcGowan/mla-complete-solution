USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Invoice_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Invoice_Delete]
GO
/****** Object:  StoredProcedure [dbo].[Invoice_Delete]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Invoice_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Invoice_Delete] AS' 
END
GO


ALTER proc [dbo].[Invoice_Delete]
	@I_vInvoiceID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS


update Invoice set IsActive = 0, Cancelled = 1 where InvoiceID = @I_vInvoiceID

-- Reset the order status!
declare @OrderID int

select @OrderID = OrderID from OrderInvoice where InvoiceID = @I_vInvoiceID
update [order] set OrderStatusID = 4 where OrderID = @OrderID

-- Remove association between invoice and order
delete from OrderInvoice where InvoiceID = @I_vInvoiceID
update Delivery set InvoiceID = null where InvoiceID = @I_vInvoiceID





GO
