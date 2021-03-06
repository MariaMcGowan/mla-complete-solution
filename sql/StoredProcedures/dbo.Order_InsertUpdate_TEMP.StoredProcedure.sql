USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Order_InsertUpdate_TEMP]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Order_InsertUpdate_TEMP]
GO
/****** Object:  StoredProcedure [dbo].[Order_InsertUpdate_TEMP]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_InsertUpdate_TEMP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Order_InsertUpdate_TEMP] AS' 
END
GO


ALTER proc [dbo].[Order_InsertUpdate_TEMP]
	@I_vOrderID int = null
	,@I_vCustomerReferenceNbr varchar(100) = null
	,@I_vIncubationDayCnt int=null
	,@I_vDeliveryDate date = null
	,@I_vDestinationID int = 1
	,@I_vDestinationBuildingID int = null
	,@I_vPlannedQty int = null
	,@I_vOrderQty int = null
	,@I_vOrderStatusID int = null
	,@I_vPlannedSetDate datetime=null
	,@I_vUserName varchar(255) = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

--We are disabling any changes to building and delivery date if the order is today or earlier, as that will mess up lot numbers real bad
declare @savedDeliveryDate date, @savedDestinationBuildingID int
select @savedDeliveryDate = DeliveryDate, @savedDestinationBuildingID = DestinationBuildingID from [Order] where OrderID = @I_vOrderID
--if (@savedDeliveryDate <= convert(date,GETDATE()) OR @I_vDeliveryDate <= convert(date,GETDATE()))
--	AND (@savedDeliveryDate <> @I_vDeliveryDate OR @savedDestinationBuildingID <> @I_vDestinationBuildingID)
--begin
--	RAISERROR('This order has a delivery date in the past. Building and Delivery Date cannot be changed.', 16, 1)
--	RETURN
--end

declare @DestinationBuildingMaxLen int = 4
declare @DestinationBuilding varchar(100)

If @I_vDestinationBuildingID is null
begin
	set @DestinationBuilding = 'XXX'
end
else
begin
	select @DestinationBuilding = replace(DestinationBuilding, ' ', '')
	from DestinationBuilding
	where DestinationBuildingID = @I_vDestinationBuildingID
end

if len(@DestinationBuilding) > @DestinationBuildingMaxLen
	set @DestinationBuilding = left(@DestinationBuilding,@DestinationBuildingMaxLen)


if @I_vPlannedSetDate is null and @I_vDeliveryDate is not null and @I_vIncubationDayCnt is not null
begin
	/*
		In order entry, there is a difference between incubation day count and the number of days between the 
		Set Date and the Delivery Date. The incubation day count should default to 11, (which it does) 
		but the software should understand that the set date is always one day before the incubation starts. 
		So, in essence, what we want to happen is that when an incubation day count is entered, 
		the difference between the set date and the delivery date is 1 more day than the incubation count. 
		For example, the incubation day count is 11, but the set date is actually 12 days before the 
		delivery date. This is because the eggs are set in the incubator the day before the incubator 
		begins the incubation process. This would be true for any incubation day count we enter. 
		A 9 day incubation order would be set 10 days before the delivery date, 
		an 8 day incubation order would be set 9 days before, etc... 
	*/
	
	set @I_vPlannedSetDate = DateAdd(day, -1*(@I_vIncubationDayCnt+1), @I_vDeliveryDate)
end

if @I_vOrderID = 0
begin
	-- Is there order information to actually save?
	if exists 
	(
		select CustomerReferenceNbr = @I_vCustomerReferenceNbr,
		DeliveryDate = @I_vDeliveryDate,
		PlannedQty = @I_vPlannedQty,
		OrderQty = @I_vOrderQty
		except
		select CustomerReferenceNbr = null,
		DeliveryDate = null,
		PlannedQty = null,
		OrderQty = null
	)
	begin
		declare @OrderID table (OrderID int)
		insert into [ORDER] (
			CustomerReferenceNbr
			, DeliveryDate
			, DestinationID
			, DestinationBuildingID
			, PlannedQty
			, OrderQty
			, OrderStatusID
			, PlannedSetDate
			, CreationDate
		)
		output inserted.OrderID into @OrderID(OrderID)
		select
			@I_vCustomerReferenceNbr
			, @I_vDeliveryDate
			, @I_vDestinationID
			, @I_vDestinationBuildingID
			, @I_vPlannedQty
			, @I_vOrderQty
			, isnull(@I_vOrderStatusID,1)
			, @I_vPlannedSetDate
			, getdate()

		select top 1 @I_vOrderID = OrderID, @iRowID = OrderID from @OrderID
		
		update [Order] 
		set --LotNbr = dbo.GetLotNbr(OrderID)
			OrderNbr = 'MLA-' + @DestinationBuilding + right(replicate('0',8-len(@DestinationBuilding)) + cast(@I_vOrderID as varchar),8) 
		where OrderID = @I_vOrderID

		-- Add all flocks to an order
		insert into OrderFlock (OrderID, FlockID)
		select @I_vOrderID, FlockID
		from Flock 
		where isnull(isActive,1) = 1
		
	end
end
else
begin
	update [ORDER]
	set
		CustomerReferenceNbr = @I_vCustomerReferenceNbr
		,DeliveryDate = @I_vDeliveryDate
		,DestinationID = @I_vDestinationID
		,DestinationBuildingID = @I_vDestinationBuildingID
		,PlannedQty = @I_vPlannedQty
		,OrderQty = @I_vOrderQty
		,OrderStatusID = @I_vOrderStatusID
		,PlannedSetDate = @I_vPlannedSetDate
		,OrderNbr = 'MLA-' + @DestinationBuilding + right(replicate('0',8-len(@DestinationBuilding)) + cast(@I_vOrderID as varchar),8) 
		--,LotNbr = 
		--case
		--	-- did the delivery year change?
		--	when left(LotNbr, 2) <> right(cast(DatePart(Year,DeliveryDate) as varchar), 2) then dbo.GetLotNbr(OrderID)
		--	-- did the destination building change?
		--	when DestinationBuildingID <> @I_vDestinationBuildingID then dbo.GetLotNbr(OrderID)
		--	else LotNbr
		--end
	where @I_vOrderID = OrderID

	select @iRowID = @I_vOrderID
end

--Set the lot number for this order and any order with a delivery date greater than or equal to this one but still this year
declare @updateLots table (OrderID int, DeliveryDate date, DestinationBuildingID int, LotNbr varchar(20))
insert into @updateLots (OrderID, DeliveryDate, DestinationBuildingID)
select OrderID, DeliveryDate, DestinationBuildingID
	from [Order] 
	where DeliveryDate >= @I_vDeliveryDate 
		and DeliveryDate < convert(date,'1/1/' + convert(varchar,DATEPART(yyyy,@I_vDeliveryDate)+1))

declare @currentOrderID int, @currentDate date, @currentBuildingID int
		,@FirstOfYear date = convert(date,'1/1/' + convert(varchar,DATEPART(yyyy,@I_vDeliveryDate)))
		,@LotYear varchar(2) = right(cast(DatePart(Year,@I_vDeliveryDate) as varchar), 2)
		,@NextNbr int
		,@LotDestination varchar(2)



while exists (select 1 from @updateLots where LotNbr is null)
begin
	select top 1 @currentOrderID = OrderID, @currentDate = DeliveryDate, @currentBuildingID = DestinationBuildingID from @updateLots where LotNbr is null

	select @NextNbr = count(distinct DeliveryDate)
		from [Order] 
		where DeliveryDate >= @FirstOfYear
		and DeliveryDate <= @currentDate
		and OrderStatusID <> 5

	select @LotDestination = right('00' + cast(replace(DestinationBuilding,' ','') as varchar),2)
		from DestinationBuilding where DestinationBuildingID = @currentBuildingID

	update @updateLots 
	set LotNbr = @LotYear + @LotDestination + right('000' + cast(@NextNbr as varchar),3) 
	where OrderID = @currentOrderID
end
	
update o
set o.LotNbr = ul.LotNbr
from [Order] o
inner join @updateLots ul on o.OrderID = ul.OrderID

--Redo any delivery slips if lot number has changed
declare @LotNbr nvarchar(20)
select @LotNbr = LotNbr from [Order] where OrderID = @I_vOrderID

declare @OrderDelivery table (OrderDeliveryID int, OrderID int, DeliverySlip varchar(10))
insert into @OrderDelivery (OrderDeliveryID, OrderID) select OrderDeliveryID, OrderID from OrderDelivery where OrderID = @I_vOrderID order by DeliveryID
declare @currentID int
while exists (select 1 from @OrderDelivery where DeliverySlip is null)
begin
	select top 1 @currentID = OrderDeliveryID from @OrderDelivery where DeliverySlip is null

	update @OrderDelivery
	set DeliverySlip = (select rtrim(LotNbr) + '.' + right('00' + cast((
		(select count(1) from @OrderDelivery od where od.OrderID = o.OrderID and IsNull(DeliverySlip,'') <> '')
		+ 1) as varchar),2)
		from [Order] o where OrderID = @I_vOrderID)
	where OrderDeliveryID = @currentID
end

update od
	set od.DeliverySlip = od2.DeliverySlip
from OrderDelivery od
inner join @OrderDelivery od2 on od.OrderDeliveryID = od2.OrderDeliveryID



select @I_vOrderID as ID,'forward' As referenceType



GO
