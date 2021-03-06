USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CandlingHeader_GetDeliverySummary]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CandlingHeader_GetDeliverySummary]
GO
/****** Object:  StoredProcedure [dbo].[CandlingHeader_GetDeliverySummary]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CandlingHeader_GetDeliverySummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CandlingHeader_GetDeliverySummary] AS' 
END
GO



ALTER proc [dbo].[CandlingHeader_GetDeliverySummary]
	@LoadPlanningID int
AS

declare @DeliveryDate date

--select @DeliveryDate = DeliveryDate
--from LoadPlanning
--where LoadPlanningID = @LoadPlanningID

declare @DeliveryTotals table (DeliveryID int, ActualQty int)
insert into @DeliveryTotals
select d.DeliveryID
	,SUM(IsNull(dcf.ActualQty,0))
from [Order] o 
	inner join OrderDelivery od on o.OrderID = od.OrderID
	inner join Delivery d on od.DeliveryID = d.DeliveryID
	inner join DeliveryCart dc on dc.DeliveryID = d.DeliveryID
	inner join DeliveryCartFlock dcf on dcf.DeliveryCartID = dc.DeliveryCartID
--where DeliveryDate = @DeliveryDate
where o.LoadPlanningID = @LoadPlanningID
group by d.DeliveryID


select DestinationBuilding, DeliveryDescription, HoldingIncubator, 
FullCarts = dbo.FormatIntComma(FullCarts), DeliveryShelves = dbo.FormatIntComma(DeliveryShelves), 
Trays = dbo.FormatIntComma(Trays), Eggs = dbo.FormatIntComma(Eggs), ActualQty = dbo.FormatIntComma(ActualQty)
from 
(
	select
	db.DestinationBuilding
	,d.DeliveryDescription
	,hi.HoldingIncubator

	--Full Carts
	,convert(int,Round(dbo.ConvertEggsToHoldingIncubatorCarts(dt.ActualQty),0,1)) as FullCarts
	--Shelves
	,convert(int,Round(dbo.ConvertEggsToDeliveryShelves(
		dt.ActualQty - dbo.ConvertDeliveryCartsToEggs(Round(dbo.ConvertEggsToHoldingIncubatorCarts(dt.ActualQty),0,1))
		),0,1)) as DeliveryShelves

	--Trays
	,convert(int,Round(dbo.ConvertEggsToTrays(
		dt.ActualQty - dbo.ConvertDeliveryShelvesToEggs(Round(dbo.ConvertEggsToDeliveryShelves(dt.ActualQty),0,1))
		),0,1)) as Trays
	--Eggs
	,dt.ActualQty - dbo.ConvertTraysToEggs(Round(dbo.ConvertEggsToTrays(dt.ActualQty),0,1)) as Eggs
	--Total
	,dt.ActualQty

	from Delivery d
	left outer join @DeliveryTotals dt on d.DeliveryID = dt.DeliveryID
	inner join HoldingIncubator hi on d.HoldingIncubatorID = hi.HoldingIncubatorID
	inner join OrderDelivery od on d.DeliveryID = od.DeliveryID
	inner join [Order] o on o.OrderID = od.OrderID
	inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
	--where o.DeliveryDate = @DeliveryDate
	where o.LoadPlanningID = @LoadPlanningID
) d


GO
