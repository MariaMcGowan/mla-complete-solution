if exists (select 1 from sys.procedures p inner join sys.schemas s on p.schema_id = s.schema_id where p.name = 'HoldingIncubatorLoad_Detail_InsertUpdate' and s.name = 'dbo')
begin
	drop proc HoldingIncubatorLoad_Detail_InsertUpdate
end
GO

create proc HoldingIncubatorLoad_Detail_InsertUpdate
	@I_vDeliveryID int

	,@I_vLocationNumber int
	,@I_vIncubatorLocationNumber int = null
	,@I_vDeliveryCartID int = null
	,@I_vOrderID int = null
	,@I_vLoadDate date = null
	,@I_vLoadTime time = null

	,@I_vDeliveryCartFlockID1 int = 0
	,@I_vFlockID1 int = null
	,@I_vActualQty1 int = 0
	,@I_vCarts1 int = 0
	,@I_vShelves1 int = 0
	,@I_vTrays1 int = 0
	,@I_vEggs1 int = 0

	,@I_vDeliveryCartFlockID2 int = 0
	,@I_vFlockID2 int = null
	,@I_vActualQty2 int = 0
	,@I_vCarts2 int = 0
	,@I_vShelves2 int = 0
	,@I_vTrays2 int = 0
	,@I_vEggs2 int = 0

	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS


select @I_vActualQty1 =
	dbo.ConvertDeliveryCartsToEggs(@I_vCarts1)
	+ dbo.ConvertDeliveryShelvesToEggs(@I_vShelves1)
	+ dbo.ConvertTraysToEggs(@I_vTrays1)
	+ @I_vEggs1

select @I_vActualQty2 = case when @I_vActualQty1 = 4320 then 0 else
	dbo.ConvertDeliveryCartsToEggs(@I_vCarts2)
	+ dbo.ConvertDeliveryShelvesToEggs(@I_vShelves2)
	+ dbo.ConvertTraysToEggs(@I_vTrays2)
	+ @I_vEggs2
	end

-- if there is no flock, zero out the quantity
if isnull(@I_vFlockID1,0) = 0
	set @I_vActualQty1 = 0

-- if there is no flock, zero out the quantity
if isnull(@I_vFlockID2,0) = 0
	set @I_vActualQty2 = 0

-- if there is no quantity, blank out the flock
if isnull(@I_vActualQty1,0) = 0
	set @I_vFlockID1 = null

-- if there is no quantity, blank out the flock
if isnull(@I_vActualQty2,0) = 0
	set @I_vFlockID2 = null

declare @I_vLoadDateTime datetime
select @I_vLoadDateTime = convert(datetime,@I_vLoadDate) + convert(datetime,@I_vLoadTime)

declare @I_vHoldingIncubatorID int
select @I_vHoldingIncubatorID = HoldingIncubatorID from Delivery where DeliveryID = @I_vDeliveryID

declare @I_vOrderDeliveryID int
select @I_vOrderDeliveryID = OrderDeliveryID
	from OrderDelivery
	where OrderID = @I_vOrderID and DeliveryID = @I_vDeliveryID


if @I_vFlockID1 is not null and @I_vActualQty1 > 0
begin
	if @I_vDeliveryCartID = 0
	begin
		-- Let's be sure
		select @I_vDeliveryCartID = dbo.GetDeliveryCartID(@I_vDeliveryID, @I_vLocationNumber, @I_vFlockID1)
	end

	if @I_vDeliveryCartFlockID1 = 0
	begin
		-- Let's be sure
		select @I_vDeliveryCartFlockID1 = dbo.GetDeliveryCartFlockID(@I_vDeliveryID, @I_vLocationNumber, @I_vFlockID1)

	end
end

if @I_vFlockID2 is not null and @I_vActualQty2 > 0
begin
	if @I_vDeliveryCartID = 0
	begin
		-- Let's be sure
		select @I_vDeliveryCartID = dbo.GetDeliveryCartID(@I_vDeliveryID, @I_vLocationNumber, @I_vFlockID2)
	end

	if @I_vDeliveryCartFlockID2 = 0
	begin
		-- Let's be sure
		select @I_vDeliveryCartFlockID2 = dbo.GetDeliveryCartFlockID(@I_vDeliveryID, @I_vLocationNumber, @I_vFlockID2)

	end
end


If IsNull(@I_vOrderDeliveryID,0) = 0
begin
	declare @OrderDeliveryID table (OrderDeliveryID int)
	insert into OrderDelivery (OrderID,DeliveryID)
	output inserted.OrderDeliveryID into @OrderDeliveryID(OrderDeliveryID)
	select @I_vOrderID, @I_vHoldingIncubatorID

	select @I_vOrderDeliveryID = OrderDeliveryID from @OrderDeliveryID
end

If IsNull(@I_vDeliveryCartID,0) = 0 and @I_vFlockID1 is not null and @I_vActualQty1 > 0
begin
	declare @DeliveryCartID table (DeliveryCartID int)
	insert into DeliveryCart (DeliveryCart,SortOrder,IsActive,CartNumber,IncubatorLocationNumber,LoadDateTime, DeliveryID, OrderID)
	output inserted.DeliveryCartID into @DeliveryCartID(DeliveryCartID)
	select
		@I_vLocationNumber
		,@I_vLocationNumber
		,1
		,@I_vLocationNumber
		,@I_vLocationNumber
		,@I_vLoadDateTime
		,@I_vDeliveryID
		,@I_vOrderID

	select @I_vDeliveryCartID = DeliveryCartID from @DeliveryCartID
end
else
begin
	update DeliveryCart
	set LoadDateTime = @I_vLoadDateTime
		,OrderID = @I_vOrderID
	where DeliveryCartID = @I_vDeliveryCartID
end

If IsNull(@I_vDeliveryCartFlockID1,0) = 0 and @I_vFlockID1 is not null and @I_vActualQty1 > 0
begin
	insert into DeliveryCartFlock(DeliveryCartID,PlannedQty,ActualQty,FlockID)
	select
		@I_vDeliveryCartID
		,0
		,@I_vActualQty1
		,@I_vFlockID1
end
else
begin
	update DeliveryCartFlock
	set ActualQty = @I_vActualQty1
		,FlockID = @I_vFlockID1
	where DeliveryCartFlockID = @I_vDeliveryCartFlockID1
end


If IsNull(@I_vDeliveryCartFlockID2,0) = 0 and @I_vFlockID2 is not null and @I_vActualQty2 > 0
begin
	insert into DeliveryCartFlock(DeliveryCartID,PlannedQty,ActualQty,FlockID)
	select
		@I_vDeliveryCartID
		,0
		,@I_vActualQty2
		,@I_vFlockID2
end
else
begin
	update DeliveryCartFlock
	set ActualQty = @I_vActualQty2
		,FlockID = @I_vFlockID2
	where DeliveryCartFlockID = @I_vDeliveryCartFlockID2
end

-- Lastly, check for any "ghost" carts in the delivery!
delete from DeliveryCart 
where DeliveryID = @I_vDeliveryID and not exists (select 1 from DeliveryCartFlock where DeliveryCartID = DeliveryCart.DeliveryCartID)

update [Order] set OrderStatusID = 3 where OrderID = @I_vOrderID
