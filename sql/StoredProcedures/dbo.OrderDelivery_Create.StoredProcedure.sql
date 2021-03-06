USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderDelivery_Create]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderDelivery_Create]
GO
/****** Object:  StoredProcedure [dbo].[OrderDelivery_Create]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDelivery_Create]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderDelivery_Create] AS' 
END
GO



ALTER proc [dbo].[OrderDelivery_Create]
	@I_vOrderID int
	,@I_vDeliveryDescription nvarchar(255) = ''
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

declare @Delivery table (DeliveryID int)
insert into Delivery (DeliveryDescription)
output inserted.DeliveryID into @Delivery(DeliveryID)
	select @I_vDeliveryDescription

declare @DeliveryID int
select @DeliveryID = DeliveryID from @Delivery

insert into OrderDelivery (OrderID, DeliveryID, DeliverySlip)
	select
		@I_vOrderID
		, @DeliveryID
		--,(select rtrim(LotNbr) + '.' + right('00' + cast((
		--	(select count(1) from OrderDelivery where OrderID = @I_vOrderID and IsNull(DeliverySlip,'') = '')
		--	+ 1) as varchar),2)
		--	from [Order] where OrderID = @I_vOrderID)
		,(select rtrim(o.LotNbr) + '.' + right('00' + cast((
						(select count(1) from OrderDelivery od2 where od2.OrderID = o.OrderID and IsNull(DeliverySlip,'') <> '')
						+ 1) as varchar),2)
			from [Order] o where o.OrderID = @I_vOrderID)



GO
