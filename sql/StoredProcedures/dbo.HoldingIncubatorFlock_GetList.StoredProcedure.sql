USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorFlock_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HoldingIncubatorFlock_GetList]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorFlock_GetList]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldingIncubatorFlock_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HoldingIncubatorFlock_GetList] AS' 
END
GO


ALTER proc [dbo].[HoldingIncubatorFlock_GetList] 
@HoldingIncubatorID int
, @DeliveryDate date
, @UserName varchar(100)
As

	select d.DeliveryID 
	, dc.DeliveryCartID
	, hi.HoldingIncubatorID
	, HoldingIncubator
	, IncubatorLocationNumber
	, dcf.FlockID
	, f.Flock
	, dbo.ConvertEggsToHoldingIncubatorCarts(dcf.ActualQty) as  HoldingIncubatorQtyCarts
	, dcf.ActualQty as HoldingIncubatorQty
	, @UserName as UserName
	, DeliveryCartFlockID
	from [Order] o 
	inner join OrderDelivery od on o.OrderID = od.OrderID
	inner join Delivery d on od.DeliveryID = d.DeliveryID
	inner join DeliveryCart dc on d.DeliveryID = dc.DeliveryID
	inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
	inner join HoldingIncubator hi on d.HoldingIncubatorID = hi.HoldingIncubatorID
	inner join Flock f on dcf.FlockID = f.FlockID
	where hi.HoldingIncubatorID = @HoldingIncubatorID and o.DeliveryDate = @DeliveryDate
	and dcf.FlockID is not null
	order by IncubatorLocationNumber



GO
