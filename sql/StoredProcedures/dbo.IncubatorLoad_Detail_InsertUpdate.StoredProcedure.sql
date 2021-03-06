USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_Detail_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorLoad_Detail_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_Detail_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorLoad_Detail_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorLoad_Detail_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[IncubatorLoad_Detail_InsertUpdate]
	@I_vLocationNumber int
	,@I_vActualQty int = 0
	,@I_vIncubatorID int
	,@I_vOrderID int
	,@I_vIncubatorCartID int = null
	,@I_vOrderIncubatorID int = null
	,@I_vOrderIncubatorCartID int = null
	,@I_vIncubatorLocationNumber int = null
	--,@I_vClutchID int = null
	,@I_vFlockID int = null
	,@I_vLayDate date = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

declare @I_vClutchID int
select @I_vClutchID = ClutchID from Clutch where LayDate = @I_vLayDate and FlockID = @I_vFlockID

-- Must document quantity coming out of cooler
declare @QtyChange int
declare @ClutchID_BeforeChange int
declare @Qty_BeforeChange int

--IncubatorLocationID is the stored value on the incubator cart
--LocationNumber is the number from the map
--so if incubatorlocationID is null then it is a new value

If IsNull(@I_vOrderIncubatorCartID,0) <> 0
begin
	select @ClutchID_BeforeChange = ClutchID, @Qty_BeforeChange = ActualQty
	from OrderIncubatorCart oic
				where oic.OrderIncubatorCartID = @I_vOrderIncubatorCartID

	-- did someone blank out the lay date
	-- if so, put it back in cooler
	if @I_vClutchID is null
	begin
		-- Put the original quantity of the original clutch back in the cooler (positive qty)
		set @QtyChange = @Qty_BeforeChange
		execute CoolerClutch_EggTransaction @ClutchID = @ClutchID_BeforeChange, @QtyChange = @QtyChange

		-- Clear out the Order Incubator Cart
		update oic
		set ActualQty = null
			,ClutchID = null
		from OrderIncubatorCart oic
			where oic.OrderIncubatorCartID = @I_vOrderIncubatorCartID
	end
	else
	begin
		-- did someone change the clutch for the cart?
		-- if so, give the cooler qty back to the original clutch
		-- and take it away from the new clutch
		if @I_vClutchID <> @ClutchID_BeforeChange
		begin
			-- Put the original quantity of the original clutch back in the cooler (positive qty)
			set @QtyChange = @Qty_BeforeChange
			execute CoolerClutch_EggTransaction @ClutchID = @ClutchID_BeforeChange, @QtyChange = @QtyChange

			-- Now take the entire amount of the cooler out from the new flock
			set @QtyChange = @I_vActualQty * -1
			execute CoolerClutch_EggTransaction @ClutchID = @I_vClutchID, @QtyChange = @QtyChange
		end
		else
		begin
			-- The flock is the same, but the amount must have changed
			-- Pull the new clutch from the cooler
			if @I_vActualQty = 0
			begin
				execute CoolerClutch_EggTransaction @ClutchID = @I_vClutchID, @QtyChange = @Qty_BeforeChange
			end
			else
			begin
				select @QtyChange = -1 * (@I_vActualQty - @Qty_BeforeChange)
				execute CoolerClutch_EggTransaction @ClutchID = @I_vClutchID, @QtyChange = @QtyChange
			end
		end

		update oic
		set ActualQty = @I_vActualQty
			,ClutchID = @I_vClutchID
		from OrderIncubatorCart oic
			where oic.OrderIncubatorCartID = @I_vOrderIncubatorCartID
	end
end
else
begin
	-- since this is not an existing order incubator cart, then it can't be a clutch change
	-- therefore, just pull the clutch from the cooler
	set @QtyChange = -1 * @I_vActualQty
	execute CoolerClutch_EggTransaction @ClutchID = @I_vClutchID, @QtyChange = @QtyChange


	If IsNull(@I_vIncubatorCartID,0) = 0
	begin
		declare @IncubatorCartID table (IncubatorCartID int)
		insert into IncubatorCart (IncubatorCart, SortOrder, IsActive, CartNumber, IncubatorLocationNumber, CoolerID, IncubatorID, LoadDateTime)
		output inserted.IncubatorCartID into @IncubatorCartID(IncubatorCartID)
		select ''
			,IsNull((select max(SortOrder) + 1 from IncubatorCart),1)
			,1
			,@I_vLocationNumber
			,@I_vLocationNumber
			,null
			,@I_vIncubatorID
			,null
		
		select @I_vIncubatorCartID = IncubatorCartID from @IncubatorCartID
	end


	--This should never happen, because the header has the OrderIncubator Information. But it's leftover code so it can't hurt
	If IsNull(@I_vOrderIncubatorID,0) = 0
	begin
		select @I_vOrderIncubatorID = OrderIncubatorID
		from OrderIncubator
		where OrderID = @I_vOrderID and IncubatorID = @I_vIncubatorID
	end 

	If IsNull(@I_vOrderIncubatorID,0) = 0
	begin
		declare @OrderIncubatorID table (OrderIncubatorID int)
		insert into OrderIncubator (OrderID, IncubatorID, PlannedQty, ActualQty, ProfileNumber, StartDateTime, ProgramBy, CheckedByPrimary, CheckedBySecondary)
		output inserted.OrderIncubatorID into @OrderIncubatorID(OrderIncubatorID)
		select
			@I_vOrderID
			,@I_vIncubatorID
			,0
			,@I_vActualQty
			,null
			,null
			,null
			,null
			,null

		select @I_vOrderIncubatorID = OrderIncubatorID from @OrderIncubatorID
	end
	
	If @I_vOrderIncubatorCartID is null
	begin
		insert into OrderIncubatorCart (OrderIncubatorID, IncubatorCartID, PlannedQty, ActualQty, ClutchID)
		select
			@I_vOrderIncubatorID
			,@I_vIncubatorCartID
			,0
			,@I_vActualQty
			,@I_vClutchID
	end
	else --I don't think this condition can happen
	begin
		Update OrderIncubatorCart
		set ActualQty = @I_vActualQty
			,ClutchID = @I_vClutchID
		where OrderIncubatorCartID = @I_vOrderIncubatorCartID
	end

	declare @OrderFlockID int, @FlockID int
	select @FlockID = FlockID from Clutch where ClutchID = @I_vClutchID
	select @OrderFlockID = OrderFlockID from OrderFlock where OrderID = @I_vOrderID and FlockID = @FlockID
	If @OrderFlockID is null
	begin
		declare @OrderFlockIDResults table (OrderFlockID int)
		insert into OrderFlock (OrderID, FlockID, PlannedQty, ActualQty, WgtPreConversion)
		output inserted.OrderFlockID into @OrderFlockIDResults (OrderFlockID)
		select
			@I_vOrderID
			,@FlockID
			,0
			,(select SUM(oic.ActualQty) from OrderIncubatorCart oic
									inner join OrderIncubator oi on oic.OrderIncubatorID = oi.OrderIncubatorID
									inner join Clutch c on oic.ClutchID = c.ClutchID
									where oi.OrderIncubatorID = @I_vOrderIncubatorID and c.FlockID = @FlockID)
			,null
		select @OrderFlockID = OrderFlockID from @OrderFlockIDResults

	end
	else
	begin
		update OrderFlock
		set ActualQty = (select SUM(oic.ActualQty) from OrderIncubatorCart oic
									inner join OrderIncubator oi on oic.OrderIncubatorID = oi.OrderIncubatorID
									inner join Clutch c on oic.ClutchID = c.ClutchID
									where oi.OrderIncubatorID = @I_vOrderIncubatorID and c.FlockID = @FlockID)
		where OrderFlockID = @OrderFlockID
	end

	
	declare @OrderFlockClutchID int
	select @OrderFlockClutchID = OrderFlockClutchID from OrderFlockClutch where OrderFlockID = @OrderFlockID
	if @OrderFlockClutchID is null
	begin
		insert into OrderFlockClutch (OrderFlockID, ClutchID, PlannedQty, ActualQty)
		select
			@OrderFlockID
			,@I_vClutchID
			,0
			,(select SUM(oic.ActualQty) from OrderIncubatorCart oic
								inner join OrderIncubator oi on oic.OrderIncubatorID = oi.OrderIncubatorID
								where oi.OrderIncubatorID = @I_vOrderIncubatorID and oic.ClutchID = @I_vClutchID)
			
	end
	else
	begin
		update OrderFlockClutch
		set ActualQty = (select SUM(oic.ActualQty) from OrderIncubatorCart oic
								inner join OrderIncubator oi on oic.OrderIncubatorID = oi.OrderIncubatorID
								where oi.OrderIncubatorID = @I_vOrderIncubatorID and oic.ClutchID = @I_vClutchID)
		where OrderFlockClutchID = @OrderFlockClutchID
	end
end




GO
