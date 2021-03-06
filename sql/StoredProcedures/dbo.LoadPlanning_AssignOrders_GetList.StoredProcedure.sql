USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_AssignOrders_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[LoadPlanning_AssignOrders_GetList]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_AssignOrders_GetList]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning_AssignOrders_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[LoadPlanning_AssignOrders_GetList] AS' 
END
GO


ALTER proc [dbo].[LoadPlanning_AssignOrders_GetList]
@LoadPlanningID int = null
As

declare @DeliveryDate date, @SetDate date


select top 1 @DeliveryDate = DeliveryDate, @SetDate = SetDate from LoadPlanning where LoadPlanningID = @LoadPlanningID

select
	 Selected = 
		case
			when isnull(LoadPlanningID,0) = @LoadPlanningID then convert(bit, 1)
			else convert(bit, 0)
		end
	, LoadPlanningID = @LoadPlanningID
	, DeliveryDate
	, PlannedSetDate as SetDate
	, PlannedQty
    , LotNbr
	, OrderID
FROM  [Order]
where LoadPlanningID = @LoadPlanningID or
(
	isnull(LoadPlanningID,0) = 0
	and DeliveryDate = @DeliveryDate 
	and PlannedSetDate = @SetDate
)



GO
