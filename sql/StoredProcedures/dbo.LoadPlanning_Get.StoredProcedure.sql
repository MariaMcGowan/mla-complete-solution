USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[LoadPlanning_Get]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[LoadPlanning_Get] AS' 
END
GO


ALTER proc [dbo].[LoadPlanning_Get]
@LoadPlanningID int = null
As

select
	LoadPlanningID
	, DeliveryDate
	, SetDate
	, OverflowFlockID
	, PercentCushion = isnull(nullif(PercentCushion,0),1.60)
	, TargetQty = 
		case
			when TargetQty is null then (select sum(PlannedQty) from [Order] where OrderStatusID <> 5 and LoadPlanningID = lp.LoadPlanningID)
			when TargetQty =0 then (select sum(PlannedQty) from [Order] where OrderStatusID <> 5 and LoadPlanningID = lp.LoadPlanningID)
			else TargetQty
		end
	, (select sum(PlannedQty) from [Order] where OrderStatusID <> 5 and LoadPlanningID = lp.LoadPlanningID)  as TotalOrderPlannedQty
    , STUFF((    SELECT ',' + LotNbr
                FROM [Order] 
                WHERE OrderStatusID <> 5 and LoadPlanningID = lp.LoadPlanningID
                FOR XML PATH('')
                ), 1, 1, '' )
            AS LotNumbers
FROM  LoadPlanning lp
where IsNull(@LoadPlanningID,LoadPlanningID) = LoadPlanningID
order by SetDate desc, DeliveryDate desc



GO
