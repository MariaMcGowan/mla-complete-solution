USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Order_LookupForDeliveryCreate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Order_LookupForDeliveryCreate]
GO
/****** Object:  StoredProcedure [dbo].[Order_LookupForDeliveryCreate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_LookupForDeliveryCreate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Order_LookupForDeliveryCreate] AS' 
END
GO



ALTER proc [dbo].[Order_LookupForDeliveryCreate]
AS

select o.LotNbr as display, 
	o.OrderID as value, 
	o.DeliveryDate
	from [ORDER] o
	where OrderStatusID < 4	-- delivery slips have not been printed!



GO
