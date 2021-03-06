USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderFlock_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderFlock_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderFlock_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderFlock_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderFlock_Get] AS' 
END
GO


ALTER proc [dbo].[OrderFlock_Get]
@OrderID int
,@OrderFlockID int = null
,@IncludeNew bit = 0
,@UserName nvarchar(255) = ''
As

select
	ofl.OrderFlockID
	, OrderID
	, ofl.FlockID
	, PlannedQty
	, ClutchPlannedQty = isnull(ClutchPlannedQty,0)
	, ActualQty
	, @UserName As UserName
	, Flock
from OrderFlock ofl
inner join Flock fl on ofl.FlockID = fl.FlockID
left outer join 
(
	select ofcl.OrderFlockID, sum(ofcl.PlannedQty) as ClutchPlannedQty
	from OrderFlock ofl2
	inner join OrderFlockClutch ofcl on ofl2.OrderFlockID = ofcl.OrderFlockID and ofl2.OrderID = @OrderID
	inner join Clutch c on ofcl.ClutchID = c.ClutchID
	where IsNull(@OrderFlockID,ofl2.OrderFlockID) = ofl2.OrderFlockID
	group by ofcl.OrderFlockID
) c on ofl.OrderFlockID = c.OrderFlockID
where OrderID = @OrderID and IsNull(@OrderFlockID,ofl.OrderFlockID) = ofl.OrderFlockID
union all
select
	OrderFlockID = convert(int,0)
	, OrderID = @OrderID
	, FlockID = convert(int,null)
	, PlannedQty = convert(int,null)
	, ClutchPlannedQty = convert(int,null)
	, ActualQty = convert(int,null)
,@UserName As UserName
,Flock = 'ZZZ'
where @IncludeNew = 1
order by Flock



GO
