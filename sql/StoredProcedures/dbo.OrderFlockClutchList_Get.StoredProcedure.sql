USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderFlockClutchList_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderFlockClutchList_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderFlockClutchList_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderFlockClutchList_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderFlockClutchList_Get] AS' 
END
GO


ALTER proc [dbo].[OrderFlockClutchList_Get]
@OrderID int = null
,@IncludeNew bit = 0
,@UserName nvarchar(255) = ''
As

select 
	o.OrderID
	, ofl.FlockID
	, LayDate
	, c.PlannedQty
	, @UserName As UserName
	, OrderFlockClutchID
from [Order] o
inner join OrderFlock ofl on o.OrderID = ofl.OrderID
inner join OrderFlockClutch ofcl on ofl.OrderFlockID = ofcl.OrderFlockID
inner join Clutch c on ofcl.ClutchID = c.ClutchID
where o.OrderStatusID not in (4, 5) 
and IsNull(@OrderID,o.OrderID) = o.OrderID
union all
select
	OrderID = convert(int,0)
	, FlockID = convert(int,0)
	, LayDate = convert(date, null)
	, PlannedQty = convert(int,null)
	, @UserName As UserName
	, OrderFlockClutchID  = convert(int,0)
where @IncludeNew = 1




GO
