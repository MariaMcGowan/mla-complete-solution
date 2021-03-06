USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Candling]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Candling]
GO
/****** Object:  StoredProcedure [dbo].[Candling]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Candling]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Candling] AS' 
END
GO



ALTER proc [dbo].[Candling] @OrderID int = 28
--, @LotNbr varchar(100) = null
as

--if isnull(@LotNbr, '') = ''
	
--select @OrderID = LotNbr
--from [Order]
--where LotNbr = isnull(@LotNbr, LotNbr)


declare @EggsPerIncubatorCart int = 4608
		,@EggsPerHoldingIncubatorCart int = 4320
		,@EggsPerShelf int = 1080
		,@EggsPerTray int = 36
		,@EggsPerCase int = 360

declare @incubatorFlockQuantities table (FlockID int, PreviousOrderID int, IncubatorQuantity int, HoldingIncubatorQuantity int, PreviousOrderIncubatorQuantity int, PreviousOrderHoldingIncubatorQuantity int)
insert into @incubatorFlockQuantities (FlockID)
select distinct
	FlockID
from OrderFlock ofl
inner join OrderFlockClutch ofc on ofl.OrderFlockID = ofc.OrderFlockID
inner join OrderClutchIncubator oci on ofc.OrderFlockClutchID = oci.OrderFlockClutchID
where ofl.OrderID = @OrderID

declare @currentDeliveryDate date
select @currentDeliveryDate = DeliveryDate from [Order] where OrderID = @OrderID

update ofq
	set ofq.PreviousOrderID = (select top 1 o.OrderID
								from [Order] o
									inner join OrderFlock ofl on o.OrderID = ofl.OrderID
								where ofl.FlockID = ofq.FlockID
									and o.DeliveryDate < @currentDeliveryDate
								order by o.DeliveryDate desc)
from @incubatorFlockQuantities ofq

update ofq
	set ofq.IncubatorQuantity = (select sum(oci.ActualQty) 
							from OrderClutchIncubator oci
							inner join OrderFlockClutch ofc on oci.OrderFlockClutchID = ofc.OrderFlockClutchID
							inner join OrderFlock ofl on ofc.OrderFlockID = ofl.OrderFlockID
							where ofl.FlockID = ofq.FlockID and ofl.OrderID = @OrderID
						)
		,ofq.HoldingIncubatorQuantity = (select sum(ohi.ActualQty)
										from OrderFlock ofl
										inner join OrderHoldingIncubator ohi on ofl.OrderID = ohi.OrderID
										where ofl.FlockID = ofq.FlockID and ofl.OrderID = @OrderID
										)
		,ofq.PreviousOrderIncubatorQuantity = (select sum(oci.ActualQty) 
							from OrderClutchIncubator oci
							inner join OrderFlockClutch ofc on oci.OrderFlockClutchID = ofc.OrderFlockClutchID
							inner join OrderFlock ofl on ofc.OrderFlockID = ofl.OrderFlockID
							where ofl.FlockID = ofq.FlockID and ofl.OrderID = ofq.PreviousOrderID
						)
		,ofq.PreviousOrderHoldingIncubatorQuantity = (select sum(ohi.ActualQty)
										from OrderFlock ofl
										inner join OrderHoldingIncubator ohi on ofl.OrderID = ohi.OrderID
										where ofl.FlockID = ofq.FlockID and ofl.OrderID = ofq.PreviousOrderID
										)
from @incubatorFlockQuantities ofq

--I don't trust that this works
--it needs to be tested

declare @HoldingIncubatorAndDelivery table (OrderFlockID int, HoldingIncubators nvarchar(255), Deliveries nvarchar(255))
declare @HoldingIncubators nvarchar(255), @Deliveries nvarchar(255), @currentID int
insert into @HoldingIncubatorAndDelivery (OrderFlockID)
select OrderFlockID
from OrderFlock
where OrderID = @OrderID

while exists (select 1 from @HoldingIncubatorAndDelivery where HoldingIncubators is null)
begin
	select top 1 @HoldingIncubators = '', @Deliveries = '', @currentID = OrderFlockID from @HoldingIncubatorAndDelivery where HoldingIncubators is null

	select @HoldingIncubators = @HoldingIncubators + case when @HoldingIncubators = '' then '' else ', ' end + HoldingIncubator
		from OrderFlock ofl
		inner join OrderHoldingIncubator ohi on ohi.OrderID = @OrderID
		inner join DeliveryCart dc on dc.OrderHoldingIncubatorID = ohi.OrderHoldingIncubatorID
		inner join OrderDeliveryCart odc on odc.DeliveryCartID = dc.DeliveryCartID and odc.FlockID = ofl.FlockID
		inner join HoldingIncubator hi on ohi.HoldingIncubatorID = hi.HoldingIncubatorID
		where ofl.OrderFlockID = @currentID

	--when we create a way for deliveries to link to holding incubators, load the deliveries list
	update @HoldingIncubatorAndDelivery
	set HOldingIncubators = IsNull(@HoldingIncubators,''), Deliveries = IsNull(@Deliveries,'')
	where OrderFlockID = @currentID
end


set datefirst 2
select
	f.FarmNumber
	,'M' + rtrim(convert(varchar,f.FarmNumber)) + '-' + convert(varchar,DATEPART(wk,fl.HatchDate)) + right(convert(varchar,datepart(yy,o.DeliveryDate)),2)
		as FlockNumber

	--# Plat Racks Started
	--We could count the number of Incubator Carts or we can divide the number of eggs by 4608
	,Round(ofq.IncubatorQuantity / @EggsPerIncubatorCart,0)
		as PlatRacksStarted

	--# Eggs Started
	,ofq.IncubatorQuantity 
		as NumberEggsStarted

	--# Full Lab Carts @ End
	--Sum of total carts in holding incubator for the order
	,Round(ofq.HoldingIncubatorQuantity / @EggsPerHoldingIncubatorCart ,0,1) 
		as NumberFullLabCarts
	
	----------------------Mixed Cart section, deferred for now------------------------
	--this logic isn't quite right yet, so there is some math here that we will eventually use
	--Flock #
	--On Cart, so it should be previous flock / current flock then current flock / next flock

	--The following is 3 parts to one quantity (like hour:min:sec) that add up to #eggs on mix cart
	--#Shelves @ End
	,Round(ofq.HoldingIncubatorQuantity / @EggsPerShelf,0,1)
		as NumberShelvesAtEnd
	--#Trays @ End
	,Round(ofq.HoldingIncubatorQuantity / @EggsPerTray,0,1)
		as NumberTraysAtEnd
	--#Eggs @ End
	,ofq.HoldingIncubatorQuantity % @EggsPerTray
		as NumberEggsAtEnd

	--# Eggs on Mix Cart (this is the full holding incubator flock quantity minus the full carts)
	,ofq.HoldingIncubatorQuantity % @EggsPerHoldingIncubatorCart
		as NumberEggsOnMixCart

	---------------------------------------------------------------------------------------

	--Total Eggs
	,ofq.HoldingIncubatorQuantity
		as TotalEggs

	--Total Candleout %
	,100 * (ofq.HoldingIncubatorQuantity / ofq.IncubatorQuantity)
		as TotalCandleoutPercent

	--Previous Candleout %
	,100 * (ofq.PreviousOrderHoldingIncubatorQuantity / ofq.PreviousOrderIncubatorQuantity)
		as PreiousCandleoutPercent

	--Weight (Pre-conversion)
	,WgtPreConversion
		as WeightPreConversion

	--Weight (Post-conversion)
	,dbo.ApplyWgtConversion(WgtPreConversion)
		as WeightPostConversion

	--Holding Incubator
	,hiad.HoldingIncubators

	--Truck Load #
	,hiad.Deliveries

	--#Cases Started
	,ofq.IncubatorQuantity / @EggsPerCase
		as NumberCasesStarted

	--#Eggs Delivered
	--The excel sheet has some math, but it looks like it's the same as Total Eggs, but can be overridden???
	,ofq.HoldingIncubatorQuantity
		as NumberEggsDelivered

	--Pickout % (for production worksheet)
	,100 * (1-(ofq.HoldingIncubatorQuantity / ofq.IncubatorQuantity))
		As PickoutPercent

from OrderFlock ofl
inner join [Order] o on ofl.OrderID = o.OrderID
inner join Flock fl on ofl.FlockID = fl.FlockID
inner join Farm f on fl.FarmID = f.FarmID

left outer join @incubatorFlockQuantities ofq on fl.FlockID = ofq.FlockID
left outer join @HoldingIncubatorAndDelivery hiad on hiad.OrderFlockID = ofl.OrderFlockID
where o.OrderID = @OrderID




GO
