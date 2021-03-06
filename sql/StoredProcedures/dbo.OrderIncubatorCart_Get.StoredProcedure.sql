USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubatorCart_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderIncubatorCart_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubatorCart_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubatorCart_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderIncubatorCart_Get] AS' 
END
GO


ALTER proc [dbo].[OrderIncubatorCart_Get]
@OrderIncubatorID int
,@IncludeNew bit = 1
As

select
	ocic.OrderIncubatorCartID
	, ocic.OrderIncubatorID
	, ocic.IncubatorCartID
	, ocic.PlannedQty
	, ocic.ActualQty
	, convert(date,LoadDateTime) as LoadDate
	, convert(time,LoadDateTime) as LoadTime
	, ic.IncubatorCart
	, ic.CartNumber
	, ic.IncubatorLocationNumber
	, ic.CoolerID
	, ic.IncubatorID
from OrderIncubatorCart ocic
inner join IncubatorCart ic on ocic.IncubatorCartID = ic.IncubatorCartID
where @OrderIncubatorID = OrderIncubatorID
union all
select
	OrderIncubatorCartID = convert(int,0)
	, OrderIncubatorID = OrderIncubatorID
	, IncubatorCartID = convert(int,0)
	, PlannedQty = convert(int,null)
	, ActualQty = convert(int,null)
	, LoadDate = convert(date,null)
	, LoadTime = convert(time,null)
	, IncubatorCart = convert(nvarchar(255),'')
	, CartNumber = convert(varchar(25),'')
	, IncubatorLocationNumber = convert(int,null)
	, CoolerID = null -- (select top 1 CoolerID from OrderClutchCooler occ where occ.OrderID = oci.OrderID)
	, IncubatorID
from OrderIncubator oci
where @IncludeNew = 1 and OrderIncubatorID = @OrderIncubatorID



GO
