USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[RecalcOrderFlockActualQty]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[RecalcOrderFlockActualQty]
GO
/****** Object:  StoredProcedure [dbo].[RecalcOrderFlockActualQty]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RecalcOrderFlockActualQty]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RecalcOrderFlockActualQty] AS' 
END
GO



ALTER proc [dbo].[RecalcOrderFlockActualQty] @OrderID int
as

	declare @FlockQty table (FlockID int, ActualQty int)

	insert into @FlockQty (FlockID, ActualQty)
	select FlockID, sum(dcf.ActualQty) as ActualQty
	from [Order] o
	inner join OrderDelivery od on o.OrderID = od.OrderID
	inner join DeliveryCart dc on od.DeliveryID = dc.DeliveryID
	inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
	where O.OrderID = @OrderID and isnull(dcf.ActualQty,0) > 0
	group by FlockID


	insert into OrderFlock (OrderID, FlockID)
	select @OrderID, FlockID
	from @FlockQty fq
	where not exists (select 1 from OrderFlock where OrderID = @OrderID and FlockID = fq.FlockID)

	update OrderFlock set ActualQty = null where OrderID = @OrderID

	update ofl set ofl.ActualQty = fq.ActualQty
	from OrderFlock ofl
	inner join @FlockQty fq on ofl.OrderID = @OrderID and ofl.FlockID = fq.FlockID



GO
