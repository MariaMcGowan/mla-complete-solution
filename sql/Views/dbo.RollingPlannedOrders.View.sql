USE [MLA]
GO
/****** Object:  View [dbo].[RollingPlannedOrders]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP VIEW IF EXISTS [dbo].[RollingPlannedOrders]
GO
/****** Object:  View [dbo].[RollingPlannedOrders]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[RollingPlannedOrders]'))
EXEC dbo.sp_executesql @statement = N'--drop view RollingPlannedOrders
create view [dbo].[RollingPlannedOrders] 
with SCHEMABINDING
as 

	select OrderID, ContractTypeID, LotNbr, DestinationBuildingID, SetDate = PlannedSetDate, DeliveryDate, PlannedQty, LoadPlanningID, CustomIncubation, ProjectedOrder = convert(bit, 0)
	from dbo.[Order]
	where OrderStatusID <> 5
	union all
	select ProjectedOrderID, ContractTypeID, ''Projected'', DestinationBuildingID, SetDate, DeliveryDate, Qty, LoadPlanningID = 0, CustomIncubation, ProjectedOrder = convert(bit, 1)
	from dbo.ProjectedOrder
	where SetDate > (select max(PlannedsetDate) from dbo.[Order] where OrderStatusID <> 5)

	--create unique clustered index idxPulletFarmPlan_WeeklyScheduleID on dbo.RollingWeeklySchedule(PulletFarmPlan_WeeklyScheduleID)' 
GO
