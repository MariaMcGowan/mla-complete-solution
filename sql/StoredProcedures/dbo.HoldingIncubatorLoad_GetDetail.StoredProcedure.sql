USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_GetDetail]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HoldingIncubatorLoad_GetDetail]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_GetDetail]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldingIncubatorLoad_GetDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HoldingIncubatorLoad_GetDetail] AS' 
END
GO



ALTER proc [dbo].[HoldingIncubatorLoad_GetDetail]
@DeliveryID int
,@UserName nvarchar(255) = ''
AS

declare @HoldingIncubatorID int
	, @LocationCount int

select @HoldingIncubatorID = HoldingIncubatorID from Delivery where DeliveryID = @DeliveryID
select @LocationCount = Row_Count * Column_Count
from HoldingIncubator 
where HoldingIncubatorID = @HoldingIncubatorID

declare @currentLocation int = 1
declare @locations table (LocationNumber int)
while @currentLocation between 1 and @LocationCount
begin
	insert into @locations (LocationNumber)
	select @currentLocation
	select @currentLocation = @currentLocation + 1
end


declare @firstDeliveryCart table (DeliveryCartID int, DeliveryCartFlockID int)
insert into @firstDeliveryCart (DeliveryCartID)
select DeliveryCartID 
	from DeliveryCart dc
	inner join Delivery d on dc.DeliveryID = d.DeliveryID
	where d.DeliveryID = @DeliveryID

update fdc
set DeliveryCartFlockID = (select top 1 DeliveryCartFlockID from DeliveryCartFlock dcf where dcf.DeliveryCartID = fdc.DeliveryCartID)
from @firstDeliveryCart fdc

--arbitrarily pick an Order to default- 9 times out of 10 there's only going to be one order anyway, so it's just to speed up data entry
declare @defaultOrderID int
select top 1 @defaultOrderID = OrderID from OrderDelivery where DeliveryID = @DeliveryID

Select
@HoldingIncubatorID as HoldingIncubatorID
,@DeliveryID as DeliveryID
--,@OrderID as OrderID
	,cart.IncubatorLocationNumber
	,cart.LoadDate
	,cart.LoadTime
	,cart.DeliveryCartID
	--,IsNull(cart.OrderHoldingIncubatorID,0) as OrderHoldingIncubatorID

	,cart.DeliveryCartFlockID1
	,cart.ActualQty1
	,cart.Carts1
	,cart.Shelves1
	,cart.Trays1
	,cart.Eggs1
	,cart.FlockID1
	
	,cart.DeliveryCartFlockID2
	,cart.ActualQty2
	,cart.Carts2
	,cart.Shelves2
	,cart.Trays2
	,cart.Eggs2
	,cart.FlockID2

	,IsNull(cart.OrderID,@defaultOrderID) as OrderID
	,l.LocationNumber
	,case 
		when IsNull(cart.ActualQty1,0) + IsNull(cart.ActualQty2,0) <> 4320 and isnull(cart.ActualQty1,0) <> 0 then 'yellowBackground' 
		else ''
	 end as className
from
@locations l
left outer join 
	(select 
		dc.IncubatorLocationNumber
		,convert(date,dc.LoadDateTime) as LoadDate
		,convert(varchar,convert(time,dc.LoadDateTime),22) as LoadTime
		,IsNull(dc.DeliveryCartID,0) as DeliveryCartID
		--,IsNull(ohi.OrderHoldingIncubatorID,0) as OrderHoldingIncubatorID
		
		,IsNull(dcf1.DeliveryCartFlockID,0) as DeliveryCartFlockID1
		,IsNull(dcf1.ActualQty,0) as ActualQty1
		,convert(int,Round(dbo.ConvertEggsToHoldingIncubatorCarts(IsNull(dcf1.ActualQty,0)),0,1))
			As Carts1
		,convert(int,Round(dbo.ConvertEggsToDeliveryShelves(
			IsNull(dcf1.ActualQty,0) - dbo.ConvertDeliveryCartsToEggs(Round(dbo.ConvertEggsToHoldingIncubatorCarts(IsNull(dcf1.ActualQty,0)),0,1))
			),0,1))
			As Shelves1
		,convert(int,Round(dbo.ConvertEggsToTrays(
			IsNull(dcf1.ActualQty,0) - dbo.ConvertDeliveryShelvesToEggs(Round(dbo.ConvertEggsToDeliveryShelves(IsNull(dcf1.ActualQty,0)),0,1))
			),0,1))
			As Trays1
		,convert(int,IsNull(dcf1.ActualQty,0) - dbo.ConvertTraysToEggs(Round(dbo.ConvertEggsToTrays(IsNull(dcf1.ActualQty,0)),0,1)))
			As Eggs1
		,IsNull(dcf1.FlockID,0) as FlockID1

		,IsNull(dcf2.DeliveryCartFlockID,0) as DeliveryCartFlockID2
		,IsNull(dcf2.ActualQty,0) as ActualQty2
		,convert(int,Round(dbo.ConvertEggsToHoldingIncubatorCarts(IsNull(dcf2.ActualQty,0)),0,1))
			As Carts2
		,convert(int,Round(dbo.ConvertEggsToDeliveryShelves(
			IsNull(dcf2.ActualQty,0) - dbo.ConvertDeliveryCartsToEggs(Round(dbo.ConvertEggsToHoldingIncubatorCarts(IsNull(dcf2.ActualQty,0)),0,1))
			),0,1))
			As Shelves2
		,convert(int,Round(dbo.ConvertEggsToTrays(
			IsNull(dcf2.ActualQty,0) - dbo.ConvertDeliveryShelvesToEggs(Round(dbo.ConvertEggsToDeliveryShelves(IsNull(dcf2.ActualQty,0)),0,1))
			),0,1))
			As Trays2
		,convert(int,IsNull(dcf2.ActualQty,0) - dbo.ConvertTraysToEggs(Round(dbo.ConvertEggsToTrays(IsNull(dcf2.ActualQty,0)),0,1)))
			As Eggs2
		,IsNull(dcf2.FlockID,0) as FlockID2
		
		,IsNull(dc.OrderID,@defaultOrderID) as OrderID
	from
		Delivery d
		--left outer join OrderHoldingIncubator ohi on o.OrderID = ohi.OrderID and ohi.HoldingIncubatorID = @HoldingIncubatorID
		left outer join DeliveryCart dc on d.DeliveryID = dc.DeliveryID
		left outer join @firstDeliveryCart fdc on fdc.DeliveryCartID = dc.DeliveryCartID
		left outer join DeliveryCartFlock dcf1 on fdc.DeliveryCartID = dcf1.DeliveryCartID and dcf1.DeliveryCartFlockID = fdc.DeliveryCartFlockID
		left outer join DeliveryCartFlock dcf2 on dcf2.DeliveryCartID = dc.DeliveryCartID and dcf2.DeliveryCartFlockID <> fdc.DeliveryCartFlockID
		where @DeliveryID = d.DeliveryID

	) cart on cart.IncubatorLocationNumber = l.LocationNumber


GO
