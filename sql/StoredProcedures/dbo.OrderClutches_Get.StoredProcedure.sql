USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderClutches_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderClutches_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderClutches_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderClutches_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderClutches_Get] AS' 
END
GO


ALTER proc [dbo].[OrderClutches_Get]
@OrderID int
As

select
	ofl.FlockID
	, LayDate
	, ofc.PlannedQty
	, ofc.ActualQty
	, ofc.OrderFlockClutchID
from OrderFlock ofl
inner join OrderFlockClutch ofc on ofl.OrderFlockID = ofc.OrderFlockID
inner join Clutch c on ofc.ClutchID = c.ClutchID
where OrderID = @OrderID



GO
