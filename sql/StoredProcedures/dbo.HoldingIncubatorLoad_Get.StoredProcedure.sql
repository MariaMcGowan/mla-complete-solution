
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HoldingIncubatorLoad_Get]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldingIncubatorLoad_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HoldingIncubatorLoad_Get] AS' 
END
GO



ALTER proc [dbo].[HoldingIncubatorLoad_Get]
@DeliveryID int
,@UserName nvarchar(255) = ''
AS

declare @LotNumbers nvarchar(500) = '', @DestinationBuildings nvarchar(500) = ''
select @LotNumbers = @LotNumbers + case when @LotNumbers = '' then '' else ', ' end + LotNbr
from [Order] o
inner join OrderDelivery od on o.OrderID = od.OrderID
where od.DeliveryID = @DeliveryID

select @DestinationBuildings = @DestinationBuildings + case when @DestinationBuildings = '' then '' else ', ' end + DestinationBuilding
from [Order] o
inner join OrderDelivery od on o.OrderID = od.OrderID
inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
where od.DeliveryID = @DeliveryID

select distinct
@LotNumbers as LotNumber
,convert(varchar,o.DeliveryDate,22) as DeliveryDate
,@DestinationBuildings as DestinationBuilding
,hi.HoldingIncubator
,d.DeliveryID
,d.PlannedQty
,d.ActualQty
,d.TruckID
,convert(varchar,d.TimeOfDelivery,22) as TimeOfDelivery
,d.DriverID
,od.DeliverySlip
,d.InvoiceID
,d.DeliveryDescription
,hi.HoldingIncubatorID
,o.LoadPlanningID
,d.HoldingIncubatorNotes
from Delivery d
inner join HoldingIncubator hi on d.HoldingIncubatorID = hi.HoldingIncubatorID
inner join OrderDelivery od on d.DeliveryID = od.DeliveryID
inner join [Order] o on od.OrderID = o.OrderID
--left outer join LoadPlanning lp on o.DeliveryDate = lp.DeliveryDate
where d.DeliveryID = @DeliveryID