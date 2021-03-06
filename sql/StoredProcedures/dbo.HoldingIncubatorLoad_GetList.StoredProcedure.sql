USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HoldingIncubatorLoad_GetList]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_GetList]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldingIncubatorLoad_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HoldingIncubatorLoad_GetList] AS' 
END
GO


ALTER proc [dbo].[HoldingIncubatorLoad_GetList]
@UserName nvarchar(255) = ''
AS

--select distinct
--o.OrderID
--,o.OrderNbr
--,hi.HoldingIncubator
--,o.DeliveryDate
--,o.PlannedSetDate
--,o.LotNbr
--,hi.HoldingIncubatorID
--,convert(varchar,o.OrderID) + '&p=' + convert(varchar,hi.HoldingIncubatorID) as linkValue
--from
--[Order] o
--inner join OrderDelivery od on o.OrderID = od.OrderID
--inner join Delivery d on o.OrderID = od.OrderID
--inner join HoldingIncubator hi on d.HoldingIncubatorID = hi.HoldingIncubatorID
----where DeliveryDate > GETDATE()

declare @orderInfo table (DeliveryID int, LotNumbers nvarchar(500), DestinationBuildings nvarchar(500), DeliveryDate date)
insert into @orderInfo (DeliveryID)
select DeliveryID from Delivery

declare @LotNumbers nvarchar(500) = '', @DestinationBuildings nvarchar(500) = '', @DeliveryDate date
	,@DeliveryID int
while exists (select 1 from @orderInfo where LotNumbers is null)
begin
	select top 1 @DeliveryID = DeliveryID
		,@LotNumbers = ''
		,@DestinationBuildings = ''
		,@DeliveryDate = null
	from @orderInfo where LotNumbers is null


	select @LotNumbers = @LotNumbers + case when @LotNumbers = '' then '' else ', ' end + IsNull(LotNbr,'')
	from [Order] o
	inner join OrderDelivery od on o.OrderID = od.OrderID
	where od.DeliveryID = @DeliveryID
	
	select @DestinationBuildings = @DestinationBuildings + case when @DestinationBuildings = '' then '' else ', ' end + IsNull(DestinationBuilding,'')
	from [Order] o
	inner join OrderDelivery od on o.OrderID = od.OrderID
	inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
	where od.DeliveryID = @DeliveryID
	
	select top 1 @DeliveryDate = DeliveryDate
	from [Order] o
	inner join OrderDelivery od on o.OrderID = od.OrderID
	where od.DeliveryID = @DeliveryID

	update @orderInfo 
	set LotNumbers = IsNull(@LotNumbers,'')
		, DestinationBuildings = IsNull(@DestinationBuildings,'')
		, DeliveryDate = IsNull(@DeliveryDate,'')
	where DeliveryID = @DeliveryID
end

select distinct
d.DeliveryID
,hi.HoldingIncubator
,oi.DeliveryDate
,oi.DestinationBuildings
,oi.LotNumbers
,case when d.HoldingIncubatorID is null then null else d.DeliveryID end as DeliveryID_forLink
,d.DeliveryDescription
from Delivery d
left outer join HoldingIncubator hi on d.HoldingIncubatorID = hi.HoldingIncubatorID
left outer join @orderInfo oi on d.DeliveryID = oi.DeliveryID
where d.DeliveryID in
(select DeliveryID from OrderDelivery)
order by oi.DeliveryDate desc



GO
