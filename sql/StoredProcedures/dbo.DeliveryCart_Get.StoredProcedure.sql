USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryCart_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[DeliveryCart_Get]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryCart_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryCart_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeliveryCart_Get] AS' 
END
GO
ALTER proc [dbo].[DeliveryCart_Get]
@OrderHoldingIncubatorID int
,@IncludeNew bit = 1
As

select
	DeliveryCartID
	, DeliveryCart
	, SortOrder
	, IsActive
	, CartNumber
	, IncubatorLocationNumber
	, OrderHoldingIncubatorID
from DeliveryCart
where @OrderHoldingIncubatorID = OrderHoldingIncubatorID
union all
select
	DeliveryCartID = convert(int,0)
	, DeliveryCart = convert(varchar(255),null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,null)
	, CartNumber = convert(varchar(25),null)
	, IncubatorLocationNumber = convert(int,null)
	, OrderHoldingIncubatorID = @OrderHoldingIncubatorID
where @IncludeNew = 1
GO
