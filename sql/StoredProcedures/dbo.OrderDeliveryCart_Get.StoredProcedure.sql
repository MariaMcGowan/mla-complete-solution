USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderDeliveryCart_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderDeliveryCart_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderDeliveryCart_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDeliveryCart_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderDeliveryCart_Get] AS' 
END
GO


ALTER proc [dbo].[OrderDeliveryCart_Get]
@DeliveryCartID int
,@IncludeNew bit = 1
As

select
	ocic.OrderDeliveryCartID
	, ocic.DeliveryCartID
	, ocic.PlannedQty
	, ocic.ActualQty
	, ocic.FlockID
from OrderDeliveryCart ocic
where @DeliveryCartID = DeliveryCartID
union all
select
	OrderDeliveryCartID = convert(int,0)
	, DeliveryCartID = @DeliveryCartID
	, PlannedQty = convert(int,null)
	, ActualQty = convert(int,null)
	, FlockID = convert(int,null)
where @IncludeNew = 1 



GO
