USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Order_LookupForDelivery]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Order_LookupForDelivery]
GO
/****** Object:  StoredProcedure [dbo].[Order_LookupForDelivery]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_LookupForDelivery]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Order_LookupForDelivery] AS' 
END
GO


ALTER proc [dbo].[Order_LookupForDelivery]
@DeliveryID int
AS

declare @DeliveryDate date
select top 1 @DeliveryDate = DeliveryDate
from [ORDER] o
	inner join OrderDelivery od on o.OrderID = od.OrderID
	inner join Delivery d on od.DeliveryID = d.DeliveryID
where d.DeliveryID = @DeliveryID

select rtrim(o.LotNbr) + ' (' + rtrim(db.DestinationBuilding) + ')',o.OrderID
	from [ORDER] o
	left outer join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
	where OrderStatusID <> (select OrderStatusID from OrderStatus where OrderStatus = 'Cancelled')
	and o.DeliveryDate = @DeliveryDate



GO
