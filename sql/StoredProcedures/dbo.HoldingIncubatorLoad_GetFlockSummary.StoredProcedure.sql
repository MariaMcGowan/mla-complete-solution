USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_GetFlockSummary]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HoldingIncubatorLoad_GetFlockSummary]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_GetFlockSummary]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldingIncubatorLoad_GetFlockSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HoldingIncubatorLoad_GetFlockSummary] AS' 
END
GO



ALTER proc [dbo].[HoldingIncubatorLoad_GetFlockSummary]
	@DeliveryID int
AS
declare	@LoadPlanningID int
declare @DeliveryDate date

select @DeliveryDate = o.DeliveryDate, @LoadPlanningID = o.LoadPlanningID
from [Order] o
inner join OrderDelivery od on o.OrderID = od.OrderID
--inner join LoadPlanning lp on o.DeliveryDate = lp.DeliveryDate
where od.DeliveryID = @DeliveryID

select hi.HoldingIncubator, fl.Flock
	,sum(floor(IsNull(dcf.ActualQty,0) / 4320.0)) as FullCarts
	,sum(convert(numeric(19,3),IsNull(dcf.ActualQty,0) / 4320.0)) as TotalCarts
	,dbo.FormatIntComma(SUM(IsNull(dcf.ActualQty,0))) as TotalEggs
from Delivery d
	inner join DeliveryCart dc on dc.DeliveryID = d.DeliveryID
	inner join DeliveryCartFlock dcf on dcf.DeliveryCartID = dc.DeliveryCartID
	inner join Flock fl on dcf.FlockID = fl.FlockID
	inner join OrderDelivery od on d.DeliveryID = od.DeliveryID
	inner join [Order] o on od.OrderID = o.OrderID
	inner join HoldingIncubator hi on d.HoldingIncubatorID = hi.HoldingIncubatorID
where o.LoadPlanningID = @LoadPlanningID
group by hi.HoldingIncubator, fl.Flock
order by hi.HoldingIncubator, fl.Flock



GO
