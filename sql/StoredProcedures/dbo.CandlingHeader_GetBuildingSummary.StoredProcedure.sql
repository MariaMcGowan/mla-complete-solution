USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CandlingHeader_GetBuildingSummary]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CandlingHeader_GetBuildingSummary]
GO
/****** Object:  StoredProcedure [dbo].[CandlingHeader_GetBuildingSummary]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CandlingHeader_GetBuildingSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CandlingHeader_GetBuildingSummary] AS' 
END
GO



ALTER proc [dbo].[CandlingHeader_GetBuildingSummary]
	@LoadPlanningID int
AS

declare @DeliveryDate date

select @DeliveryDate = DeliveryDate
from LoadPlanning
where LoadPlanningID = @LoadPlanningID


declare @BuildingTotals table (DestinationBuildingID int, ActualQty int)
insert into @BuildingTotals
select DestinationBuildingID
	,SUM(IsNull(dcf.ActualQty,0))
from [Order] o 
	inner join OrderDelivery od on o.OrderID = od.OrderID
	inner join Delivery d on od.DeliveryID = d.DeliveryID
	inner join DeliveryCart dc on dc.DeliveryID = d.DeliveryID
	inner join DeliveryCartFlock dcf on dcf.DeliveryCartID = dc.DeliveryCartID
--where DeliveryDate = @DeliveryDate
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
	,
	case 
		when bt.ActualQty >= o.PlannedQty and bt.ActualQty <= round((o.PlannedQty * 1.02),0)
			then null
		when bt.ActualQty < o.PlannedQty
			then ABS(bt.ActualQty - o.PlannedQty)
		when bt.ActualQty > ceiling(o.PlannedQty * 1.02)
			then bt.ActualQty - round((o.PlannedQty * 1.02),0)
		else ''
	end as ExcessEggs
	,
		case 
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
