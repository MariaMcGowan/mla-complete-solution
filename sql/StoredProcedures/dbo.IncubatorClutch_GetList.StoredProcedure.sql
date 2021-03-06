USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorClutch_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorClutch_GetList]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorClutch_GetList]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorClutch_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorClutch_GetList] AS' 
END
GO


ALTER proc [dbo].[IncubatorClutch_GetList] 
@IncubatorID int
, @DeliveryDate date
, @UserName varchar(100)
As


	select oi.OrderIncubatorID
	, OrderIncubatorCartID
	, i.IncubatorID
	, Incubator
	, IncubatorLocationNumber
	, c.FlockID
	, f.Flock
	, c.ClutchID
	, c.LayDate
	, dbo.ConvertEggsToIncubatorCarts(oic.ActualQty) As IncubatorQtyCarts
	, oic.ActualQty as IncubatorQty
	, @UserName as UserName
	from OrderIncubator oi
	inner join OrderIncubatorCart oic on oi.OrderIncubatorID = oic.OrderIncubatorID
	inner join IncubatorCart ic on oic.IncubatorCartID = ic.IncubatorCartID
	inner join Incubator i on oi.IncubatorID = i.IncubatorID
	inner join Clutch c on oic.ClutchID = c.ClutchID
	inner join [Order] o on oi.OrderID = o.OrderID
	inner join Flock f on c.FlockID = f.FlockID
	where i.IncubatorID = @IncubatorID and o.DeliveryDate = @DeliveryDate
	order by IncubatorLocationNumber


GO
