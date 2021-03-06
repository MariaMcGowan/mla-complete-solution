USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_GetBuildingSummary]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HoldingIncubatorLoad_GetBuildingSummary]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_GetBuildingSummary]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldingIncubatorLoad_GetBuildingSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HoldingIncubatorLoad_GetBuildingSummary] AS' 
END
GO



ALTER proc [dbo].[HoldingIncubatorLoad_GetBuildingSummary]
	@DeliveryID int
AS
declare	@LoadPlanningID int
declare @DeliveryDate date

select @DeliveryDate = o.DeliveryDate, @LoadPlanningID = lp.LoadPlanningID
from [Order] o
inner join OrderDelivery od on o.OrderID = od.OrderID
inner join LoadPlanning lp on o.LoadPlanningID = lp.LoadPlanningID
where od.DeliveryID = @DeliveryID

declare @BuildingTotals table (DestinationBuildingID int, ActualQty int)
insert into @BuildingTotals
select DestinationBuildingID
	,SUM(IsNull(dcf.ActualQty,0))
from Delivery d
	inner join DeliveryCart dc on dc.DeliveryID = d.DeliveryID
	inner join DeliveryCartFlock dcf on dcf.DeliveryCartID = dc.DeliveryCartID
	inner join OrderDelivery od on d.DeliveryID = od.DeliveryID
	inner join [Order] o on od.OrderID = o.OrderID
--where o.DeliveryDate = @DeliveryDate
where o.LoadPlanningID = @LoadPlanningID
group by o.DestinationBuildingID


select DestinationBuilding, ActualQty = dbo.FormatIntComma(ActualQty), PlannedQty = dbo.FormatIntComma(PlannedQty), 
PlannedOver = dbo.FormatIntComma(PlannedOver), ExcessEggs = dbo.FormatIntComma(ExcessEggs) + ExcessEggsDescription
from 
(
	select
	db.DestinationBuilding
	--Total
	,bt.ActualQty
	--Target- I'm not sure where the target quantity is coming from. We're going to say it's the planned quantity on the Order
	--		There is a target quantity for the whole delivery date that we can get from Load Planning, but not sure how this would break down by order
	,o.PlannedQty
	--2% Over
	,round((o.PlannedQty * 1.02),0) as PlannedOver
	--Excess/Short
	,case 
		when bt.ActualQty >= o.PlannedQty and bt.ActualQty <= round((o.PlannedQty * 1.02),0)
			then null
		when bt.ActualQty < o.PlannedQty
			then ABS(bt.ActualQty - o.PlannedQty)
		when bt.ActualQty > ceiling(o.PlannedQty * 1.02)
			then bt.ActualQty - round((o.PlannedQty * 1.02),0)
		else ''
	end as ExcessEggs
	,case 
		when bt.ActualQty >= o.PlannedQty and bt.ActualQty <= round((o.PlannedQty * 1.02),0)
			then ''
		when bt.ActualQty < o.PlannedQty
			then ' shortage'
		when bt.ActualQty > ceiling(o.PlannedQty * 1.02)
			then ' overage'
		else ''
	end as ExcessEggsDescription

	from [Order] o
	inner join @BuildingTotals bt on o.DestinationBuildingID = bt.DestinationBuildingID
	inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
	--where o.DeliveryDate = @DeliveryDate
	where o.LoadPlanningID = @LoadPlanningID
) d


GO
