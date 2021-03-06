USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderClutchCooler_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderClutchCooler_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderClutchCooler_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderClutchCooler_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderClutchCooler_Get] AS' 
END
GO


ALTER proc [dbo].[OrderClutchCooler_Get]
@OrderFlockClutchID int = null
,@OrderClutchCoolerID int = null
,@IncludeNew bit = 1
As

select
	OrderClutchCoolerID
	, OrderFlockClutchID
	, occ.CoolerID
	, c.Cooler
	, PlannedQty
	, ActualQty
	, DateTimeDelivered
	, convert(date,DateTimeDelivered) As DateDelivered
	, convert(time,DateTimeDelivered) As TimeDelivered
	, DateTimeMovedToIncubator
	, convert(date,DateTimeMovedToIncubator) As DateMovedToIncubator
	, convert(time,DateTimeMovedToIncubator) As TimeMovedToIncubator
from OrderClutchCooler occ
inner join Cooler c on occ.CoolerID = c.CoolerID
where IsNull(@OrderFlockClutchID,OrderFlockClutchID) = OrderFlockClutchID
and IsNull(@OrderClutchCoolerID,OrderClutchCoolerID) = OrderClutchCoolerID
union all
select
	OrderClutchCoolerID = convert(int,0)
	, OrderFlockClutchID = @OrderFlockClutchID
	, CoolerID = convert(int,null)
	, Cooler = ''
	, PlannedQty = convert(int,null)
	, ActualQty = convert(int,null)
	, DateTimeDelivered = convert(datetime,null)
	, DateDelivered = convert(date,null)
	, TimeDelivered = convert(time,null)
	, DateTimeMovedToIncubator = convert(datetime,null)
	, DateMovedToIncubator = convert(date,null)
	, TimeMovedToIncubator = convert(time,null)
where @IncludeNew = 1




GO
