USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderDestinationBuilding_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderDestinationBuilding_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[OrderDestinationBuilding_Lookup]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDestinationBuilding_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderDestinationBuilding_Lookup] AS' 
END
GO


ALTER proc [dbo].[OrderDestinationBuilding_Lookup]
	@OrderFlockID int
As

declare @OrderID int

select @OrderID = OrderID from OrderFlock where OrderFlockID = @OrderFlockID

select DestinationBuilding,db.DestinationBuildingID
from dbo.DestinationBuilding db
inner join dbo.OrderDestinationBuilding odb on db.DestinationBuildingID = odb.DestinationBuildingID
where OrderID = @OrderID
order by 1



GO
