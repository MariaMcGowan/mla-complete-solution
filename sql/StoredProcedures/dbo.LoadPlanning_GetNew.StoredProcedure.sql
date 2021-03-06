USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_GetNew]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[LoadPlanning_GetNew]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_GetNew]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning_GetNew]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[LoadPlanning_GetNew] AS' 
END
GO


ALTER proc [dbo].[LoadPlanning_GetNew]
@DeliveryDate date, @SetDate date
As

select convert(int,0) as LoadPlanningID, 
convert(bit,1) as Selected, 
DeliveryDate, 
PlannedSetDate as SetDate, 
LotNbr, 
PlannedQty,
OrderID
from [Order]
where LoadPlanningID is null
and DeliveryDate = @DeliveryDate and PlannedSetDate = @SetDate
order by LotNbr


GO
