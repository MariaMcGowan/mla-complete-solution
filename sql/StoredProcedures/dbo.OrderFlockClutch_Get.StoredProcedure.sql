USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderFlockClutch_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderFlockClutch_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderFlockClutch_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderFlockClutch_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderFlockClutch_Get] AS' 
END
GO


ALTER proc [dbo].[OrderFlockClutch_Get]
@OrderFlockID int
,@OrderFlockClutchID int = null
,@IncludeNew bit = 1
,@UserName nvarchar(255) = ''
As

select
	OrderFlockClutchID
	, OrderFlockID
	, ofc.ClutchID
	, LayDate
	, ofc.PlannedQty
	, dbo.ConvertEggsToIncubatorCarts(ofc.PlannedQty) As PlannedQtyCarts
	, ofc.ActualQty
	, dbo.ConvertEggsToIncubatorCarts(ofc.ActualQty) As ActualQtyCarts
	, @UserName As UserName
from OrderFlockClutch ofc
inner join Clutch c on ofc.ClutchID = c.ClutchID
where @OrderFlockID = OrderFlockID and IsNull(@OrderFlockClutchID,OrderFlockClutchID) = OrderFlockClutchID
union all
select
	OrderFlockClutchID = convert(int,0)
	, OrderFlockID = @OrderFlockID
	, ClutchID = convert(int,null)
	, LayDate = convert(date, null)
	, PlannedQty = convert(int,null)
	, PlannedQtyCarts = convert(numeric(19,5),null)
	, ActualQty = convert(int,null)
	, ActualQtyCarts = convert(numeric(19,5),null)
,@UserName As UserName
where @IncludeNew = 1




GO
