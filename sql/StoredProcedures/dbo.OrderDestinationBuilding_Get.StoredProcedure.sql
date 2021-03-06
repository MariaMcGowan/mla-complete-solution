USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderDestinationBuilding_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderDestinationBuilding_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderDestinationBuilding_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDestinationBuilding_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderDestinationBuilding_Get] AS' 
END
GO


ALTER proc [dbo].[OrderDestinationBuilding_Get]
@OrderID int = null
,@DestinationBuildingID int = null
,@IncludeNew bit = 1
,@UserName nvarchar(255) = ''
As

select
	OrderDestinationBuildingID
	, OrderDestinationBuilding
	, OrderID
	, DestinationBuildingID
	, PlannedQty
	, OrderQty
	, @UserName as UserName
from OrderDestinationBuilding
where isnull(@OrderID, OrderID) = OrderID 
and isnull(@DestinationBuildingID, DestinationBuildingID) = DestinationBuildingID
union all
select
	OrderDestinationBuildingID = convert(int,0)
	, OrderDestinationBuilding = convert(varchar(255),null)
	, OrderID = @OrderID
	, DestinationBuildingID = convert(int,0)
	, PlannedQty = convert(int,0)
	, OrderQty = convert(int,0)
	,@UserName As UserName
where @IncludeNew = 1



GO
