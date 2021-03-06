USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderClutch_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderClutch_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderClutch_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderClutch_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderClutch_Get] AS' 
END
GO


ALTER proc [dbo].[OrderClutch_Get]
@OrderFlockClutchID int
,@UserName nvarchar(255) = ''
AS

Select
	o.OrderNbr
	,o.DeliveryDate
	,o.PlannedSetDate
	,Farm.Farm
	,Farm.FarmNumber
	,Flock.Flock
	,ofc.PlannedQty
	,ofc.ActualQty
From OrderFlockClutch ofc
inner join OrderFlock ofl on ofc.OrderFlockID = ofl.OrderFlockID
inner join [Order] o on ofl.OrderID = o.OrderID
inner join Flock on ofl.FlockID = Flock.FlockID
inner join Farm on Flock.FarmID = Farm.FarmID



GO
