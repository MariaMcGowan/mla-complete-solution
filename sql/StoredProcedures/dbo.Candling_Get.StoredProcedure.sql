USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Candling_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Candling_Get]
GO
/****** Object:  StoredProcedure [dbo].[Candling_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Candling_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Candling_Get] AS' 
END
GO



ALTER proc [dbo].[Candling_Get]
@LoadPlanningID int
as


--This report runs based on Delivery Date
--However it is easier to get that from LoadPlanningID in the UI, so that's why I used that parameter
declare @DeliveryDate date
select @DeliveryDate = DeliveryDate
from LoadPLanning
where LoadPlanningID = @LoadPlanningID

declare @EggsPerIncubatorCart int = 4608
             ,@EggsPerHoldingIncubatorCart int = 4320
             ,@EggsPerShelf int = 1080
             ,@EggsPerTray int = 36
             ,@EggsPerCase int = 360


-- Confirm that holding incubator quantities are updated

update d
set d.ActualQty = (select SUM(dcf.ActualQty)
					from DeliveryCartFlock dcf
					inner join DeliveryCart dc on dcf.DeliveryCartID = dc.DeliveryCartID
					where dc.DeliveryID = d.DeliveryID
					)
from Delivery d
	inner join OrderDelivery od on od.DeliveryID = d.DeliveryID
	inner join [Order] o on od.OrderID = o.OrderID
where o.DeliveryDate = @DeliveryDate

--------------------------#FLOCKS--------------------------------------
--We aren't going to try to be smart anymore. Just load the flocks in order they were loaded
--Actually, we are now basing the flock order on how they're loaded in the incubator, based on incubator location number
if not exists (select 1 from LoadPlanning_Detail where LoadPlanningID = @LoadPlanningID and IsNull(candlingSortOrder,0) <> 0)
begin
	declare @tempFlockOrder table (FlockID int, SortOrder int)
	insert into @tempFlockOrder (FlockID, SortOrder)
	select c.FlockID, ROW_NUMBER() OVER (ORDER BY MIN(IncubatorLocationNumber) ASC) as SortOrder
	from IncubatorCart ic
	inner join OrderIncubatorCart oic on oic.IncubatorCartID = ic.IncubatorCartID
	inner join Clutch c on oic.ClutchID = c.ClutchID
	inner join OrderIncubator oi on oic.OrderIncubatorID = oi.OrderIncubatorID
	inner join [Order] o on oi.OrderID = o.OrderID
	where o.DeliveryDate = @DeliveryDate
	group by c.FlockID
	order by MIN(ic.IncubatorLocationNumber)

	update lpd
		set lpd.candlingSortOrder = tfo.SortOrder
	from LoadPlanning_Detail lpd
	inner join @tempFlockOrder tfo on lpd.FlockID = tfo.FlockID
	where lpd.LoadPlanningID = @LoadPlanningID
end

select
	lpd.FlockID, f.Flock, 0 as Processed, lpd.candlingSortOrder as SortOrder, convert(nvarchar(255),null) as HoldingIncubators, convert(nvarchar(255),null) as Deliveries
into #Flocks
from LoadPLanning_Detail lpd
	inner join Flock f on lpd.FlockID = f.FlockID
where lpd.LoadPlanningID = @LoadPlanningID and lpd.candlingSortOrder is not null

--select dcf.FlockID, f.Flock, MIN(dc.LoadDateTime) as StartLoadDateTime, 0 as Processed, ROW_NUMBER() OVER (ORDER BY MIN(dc.LoadDateTime) ASC) as SortOrder
--into #Flocks
--from
--DeliveryCartFlock dcf
--inner join DeliveryCart dc on dc.DeliveryCartID = dcf.DeliveryCartID
--inner join Delivery d on dc.DeliveryID = d.DeliveryID
--inner join Flock f on dcf.FlockID = f.FlockID
--inner join [Order] o on dc.OrderID = o.OrderID
--where --ohi.OrderID = @OrderID --and ohi.HoldingIncubatorID = @HoldingIncubatorID
--o.DeliveryDate = @DeliveryDate
--and dcf.FlockID is not null
--group by dcf.FlockID, f.Flock
--order by MIN(dc.LoadDateTime)


----First Flock. It's the earliest loaded flock that has only one partial cart
--select top 1 dcf.FlockID, f.Flock, LoadDateTime as StartLoadDateTime, 0 as Processed, 1 as SortOrder
--into #Flocks
--from 
--DeliveryCartFlock dcf
--inner join DeliveryCart dc on dc.DeliveryCartID = dcf.DeliveryCartID
--inner join Delivery d on dc.DeliveryID = d.DeliveryID
--inner join Flock f on dcf.FlockID = f.FlockID
--inner join [Order] o on dc.OrderID = o.OrderID
--where --ohi.OrderID = @OrderID --and ohi.HoldingIncubatorID = @HoldingIncubatorID
--o.DeliveryDate = @DeliveryDate
--and dcf.FlockID is not null
--and (select count(1) from DeliveryCartFlock firstPartial 
--                                 inner join DeliveryCart dc2 on dc2.DeliveryCartID = firstPartial.DeliveryCartID
--								 inner join Delivery d2 on dc2.DeliveryID = d2.DeliveryID
--                                 where 
--                                 dc2.OrderID = dc.OrderID and d2.HoldingIncubatorID = d.HoldingIncubatorID
--                                 and IsNull(firstPartial.FlockID,0) <> 0
--                                 and dcf.DeliveryCartID <> firstPartial.DeliveryCartID
--                                 and dcf.FlockID = firstPartial.FlockID
--                                 and firstPartial.ActualQty <> @EggsPerHoldingIncubatorCart
--                                 and dcf.ActualQty <> @EggsPerHoldingIncubatorCart)
--       =0

--and dcf.ActualQty <> @EggsPerHoldingIncubatorCart
--order by dc.LoadDateTime

----Let's get all the flocks from the order
--declare @flockID_temp table (FlockID int, processed smallint)
--insert into @flockID_temp select distinct FlockID, 0 
--from DeliveryCartFlock dcf
--             inner join DeliveryCart dc on dc.DeliveryCartID = dcf.DeliveryCartID
--			 inner join [Order] o on dc.OrderID = o.OrderID
--where --OrderID = @OrderID 
--o.DeliveryDate = @DeliveryDate
--and FlockID is not null
--update @flockID_temp set processed = 1 where flockID in (select FlockID from #Flocks)

----Loop through flocks in order, starting with first flock and proceeding to each subsequent flock, based on who the current flock
----shares a partial cart with

------count the loops. If we get stuck in an infinite loop, just go by load time

--declare @currentFlockID int, @currentDeliveryCartFlockID int
--while exists (select 1 from @flockID_temp where processed = 0)
--begin
--       select @currentFlockID = dcf.FlockID
--             ,@currentDeliveryCartFlockID = dcf.DeliveryCartFlockID
--       from DeliveryCartFlock dcf
--             inner join DeliveryCart dc on dc.DeliveryCartID = dcf.DeliveryCartID
--             inner join Flock f on dcf.FlockID = f.FlockID
--			 inner join [Order] o on dc.OrderID = o.OrderID
--       where --OrderID = @OrderID
--	   o.DeliveryDate = @DeliveryDate
--       and dcf.ActualQty <> @EggsPerHoldingIncubatorCart
--       and dcf.FlockID is not null
--       and exists (select 1 from DeliveryCartFlock dcf2
--                                 where dcf.DeliveryCartID = dcf2.DeliveryCartID
--                                        and dcf.FlockID <> dcf2.FlockID
--                                        and dcf2.FlockID = (select top 1 FlockID from @flockID_temp where Processed = 1))
--       and dcf.FlockID not in (select FlockID from @flockID_temp where Processed = 2)

--       insert into #Flocks (FlockID, Flock, StartLoadDateTime, Processed, SortOrder)
--       select
--             dcf.FlockID
--             ,f.Flock
--             ,dc.LoadDateTime
--             ,0
--             ,IsNull((Select MAX(SortOrder) from #Flocks),0) + 1
--       from 
--             DeliveryCartFlock dcf
--             inner join DeliveryCart dc on dc.DeliveryCartID = dcf.DeliveryCartID
--             inner join Flock f on dcf.FlockID = f.FlockID
--       where dcf.DeliveryCartFlockID = @currentDeliveryCartFlockID

--       update @flockID_temp
--       set Processed = 2 where Processed = 1

--       update @flockID_temp
--       set Processed = 1 where FlockID = @currentFlockID
       
--end

--Let's get the totals for our incubators from this order and the previous order
declare @incubatorFlockQuantities table (FlockID int, IncubatorQuantity int, 
HoldingIncubatorQuantity int, DeliveredQuantity int, SortOrder int)
insert into @incubatorFlockQuantities (FlockID, SortOrder)
select FlockID, SortOrder
from #Flocks


update ofq
		--incubator quantity should be what's actually in the carts. Any adjustments should be included in candleout conversion calculation
       set ofq.IncubatorQuantity = 
             (
                    select sum(IsNull(oic.ActualQty,0)) 
                    from OrderIncubatorCart oic
						inner join OrderIncubator oi on oic.OrderIncubatorID = oi.OrderIncubatorID
						inner join Clutch c on oic.ClutchID = c.ClutchID
						inner join [Order] o on oi.OrderID = o.OrderID
                    where c.FlockID = ofq.FlockID 
					--and oi.OrderID = @OrderID
					and o.DeliveryDate = @DeliveryDate
             )
		--holding incubator quantity should exclude any transaction changes, since breakage is irrelevant to our calculation and will throw off predictions
		--so we subtract out the change (so add back in breakage, subtract out any additions)
       ,ofq.HoldingIncubatorQuantity = 
             (
                    select 
					sum(ABS(isnull(dcf.ActualQty,0) - IsNull(et.QtyChange,0)))
                    from DeliveryCartFlock dcf
                    inner join DeliveryCart dc on dc.DeliveryCartID = dcf.DeliveryCartID
					inner join [Order] o on dc.OrderID = o.OrderID
					left outer join EggTransaction et on dcf.DeliveryCartFlockID = et.DeliveryCartFlockID
                    where --ohi.OrderID = @OrderID 
					o.DeliveryDate = @DeliveryDate
					and dcf.FlockID = ofq.FlockID
             )      
       ,ofq.DeliveredQuantity = 
             (
                    select 
					sum(isnull(dcf.ActualQty,0))
                    from DeliveryCartFlock dcf
                    inner join DeliveryCart dc on dc.DeliveryCartID = dcf.DeliveryCartID
					inner join [Order] o on dc.OrderID = o.OrderID
                    where --ohi.OrderID = @OrderID 
					o.OrderStatusID <> 5
					and o.DeliveryDate = @DeliveryDate
					and dcf.FlockID = ofq.FlockID
             )     
from @incubatorFlockQuantities ofq

declare @HoldingIncubators nvarchar(255), @Deliveries nvarchar(255), @currentID int

while exists (select 1 from #Flocks where HoldingIncubators is null)
begin
       select top 1 @HoldingIncubators = '', @Deliveries = '', @currentID = FlockID from #Flocks where HoldingIncubators is null
	   
	   select @HoldingIncubators = @HoldingIncubators + case when @HoldingIncubators = '' then '' else ', ' end + HoldingIncubator
	   from
			(select distinct hi.HoldingIncubator
			from
			HoldingIncubator hi
			inner join Delivery d on hi.HoldingIncubatorID = d.HoldingIncubatorID
			inner join DeliveryCart dc on d.DeliveryID = dc.DeliveryID
			inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
			inner join [Order] o on dc.OrderID = o.OrderID
			where dcf.FlockID = @currentID and o.DeliveryDate = @DeliveryDate) a

       --when we create a way for deliveries to link to holding incubators, load the deliveries list
	   select @Deliveries = @Deliveries + case when @Deliveries = '' then '' else ', ' end + DeliverySlip
	   from
			(select distinct od.DeliverySlip
			from
			OrderDelivery od
			inner join Delivery d on od.DeliveryID = d.DeliveryID
			inner join DeliveryCart dc on d.DeliveryID = dc.DeliveryID
			inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
			inner join [Order] o on dc.OrderID = o.OrderID
			where dcf.FlockID = @currentID and o.DeliveryDate = @DeliveryDate) a
			
       update #Flocks
       set HoldingIncubators = IsNull(@HoldingIncubators,''), Deliveries = IsNull(@Deliveries,'')
       where FlockID = @currentID
	   
end
create table #Display (DisplayID int identity(1,1), SortOrder int, Flock varchar(100), PlatRacksStarted numeric(19,2), EggsStarted int, NumberFullLabCarts int, 
Flock01 varchar(100), Flock02 varchar(100), DeliveryCartFlockID int, ShelvesAtEnd int, TraysAtEnd int, EggsAtEnd int, EggCntMixCart int, TotalEggs int,
TotalCandleOut varchar(10), PreviousCandleOut varchar(10), WgtPreCon numeric(5,2), ShowWgt varchar(1), Wgt_PostCon numeric(5,2), 
HoldingIncubators varchar(100), DeliveryNbrs varchar(100), CasesStarted numeric(5,1), EggsDelivered int, PickOut numeric(5,2),
rowClass varchar(50), LoadPlanning_DetailID int, FlockID int, candleoutClass varchar(50))

declare @SortOrder int
declare @FlockID01 int
declare @Flock01 varchar(100)
declare @FlockID02 int
declare @Flock02 varchar(100)
declare @FarmNbr01 varchar(10)
declare @FarmNbr02 varchar(10)
declare @MaxSortOrder int
declare @DeliveryCartFlockID_Partial01 int
declare @DeliveryCartFlockID_Partial02 int

select @MaxSortOrder = max(SortOrder) from #Flocks where Processed = 0

---Let's loop through each row we want to display, in order based on #flocks table
declare @isOdd bit = 1, @oddBackground varchar(20) = 'background100', @evenBackground varchar(20) = 'whiteBackground', @footerBackground varchar(20) = 'background200'

while exists (select 1 from #Flocks where Processed = 0)
begin
       select top 1 @SortOrder = SortOrder
       from #Flocks
       where Processed = 0
       order by SortOrder
       
	   select @FlockID01 = null
       select @Flock01 = Flock, @FlockID01 = FlockID
       from #Flocks 
       where SortOrder = @SortOrder

	   select @FlockID02 = null
       select @Flock02 = Flock, @FlockID02 = FlockID
       from #Flocks 
       where SortOrder = (select min(SortOrder) from #Flocks where SortOrder > @SortOrder)

       select @FarmNbr01 = FarmNumber
       from Farm f
       inner join Flock fl on f.FarmID = fl.FarmID
       where FlockID = @FlockID01

       select @FarmNbr02 = FarmNumber
       from Farm f
       inner join Flock fl on f.FarmID = fl.FarmID
       where FlockID = @FlockID02

       if @SortOrder = @MaxSortOrder 
       begin
             set @FarmNbr02 = 'PART'
       end

	   select @DeliveryCartFlockID_Partial01 = null, @DeliveryCartFlockID_Partial02 = null
	   select @DeliveryCartFlockID_Partial01 = dcf.DeliveryCartFlockID
	   from DeliveryCartFlock dcf
				inner join DeliveryCart dc on dcf.DeliveryCartID = dc.DeliveryCartID
				inner join [Order] o on dc.OrderID = o.OrderID

				inner join DeliveryCartFlock dcf2 on dcf2.DeliveryCartID = dcf.DeliveryCartID
													and dcf.DeliveryCartFlockID <> dcf2.DeliveryCartFlockID
													
				inner join DeliveryCart dc2 on dcf2.DeliveryCartID = dc2.DeliveryCartID
			where --ohi.OrderID = @OrderID
				o.DeliveryDate = @DeliveryDate
				and dcf.FlockID = @FlockID01
				and dcf.ActualQty <> @EggsPerHoldingIncubatorCart
				and (dcf2.FlockID = @FlockID02 or (@SortOrder = @MaxSortOrder and dcf2.FlockID is null))
	   select @DeliveryCartFlockID_Partial02 = dcf.DeliveryCartFlockID
	   from DeliveryCartFlock dcf
				inner join DeliveryCart dc on dcf.DeliveryCartID = dc.DeliveryCartID
				inner join [Order] o on dc.OrderID = o.OrderID

				inner join DeliveryCartFlock dcf2 on dcf2.DeliveryCartID = dcf.DeliveryCartID
													and dcf.DeliveryCartFlockID <> dcf2.DeliveryCartFlockID
													and dcf2.FlockID = @FlockID01
				inner join DeliveryCart dc2 on dcf2.DeliveryCartID = dc2.DeliveryCartID
			where --ohi.OrderID = @OrderID
				o.DeliveryDate = @DeliveryDate
				and dcf.FlockID = @FlockID02
				and dcf.ActualQty <> @EggsPerHoldingIncubatorCart

	   --print the first row
       if @SortOrder = 1
       begin
             -- since this is the first cart, there is no left over cart to start with
             insert into #Display (SortOrder, Flock, PlatRacksStarted, EggsStarted, NumberFullLabCarts, TotalEggs, TotalCandleOut, PreviousCandleOut, candleoutClass, WgtPreCon, ShowWgt, Wgt_PostCon, HoldingIncubators, DeliveryNbrs, CasesStarted, EggsDelivered, PickOut, rowClass, LoadPlanning_DetailID, FlockID)
             select f.SortOrder
			 ,@FarmNbr01
             ,PlatRacksStarted = Round(convert(numeric(19,2),ofq.IncubatorQuantity) / @EggsPerIncubatorCart,2)
             ,NumberEggsStarted = ofq.IncubatorQuantity
             ,NumberFullLabCarts = (select count(1) from DeliveryCartFlock dcf 
										inner join DeliveryCart dc on dcf.DeliveryCartID = dc.DeliveryCartID 
										inner join [Order] o on dc.OrderID = o.OrderID
										where --ohi.OrderID = @OrderID 
										o.DeliveryDate = @DeliveryDate
										and dcf.FlockID = @FlockID01 and dcf.ActualQty = @EggsPerHoldingIncubatorCart)
             ,TotalEggs = ofq.HoldingIncubatorQuantity
             ,TotalCandleOut = 
				case
					when round(isnull(ofq.IncubatorQuantity,0),2) = 0 then ''
					else convert(varchar,convert(numeric(5,2),ROUND(100 * (convert(numeric,ofq.HoldingIncubatorQuantity) / convert(numeric,ofq.IncubatorQuantity)),2))) + '%'
				end
             ,PreviousCandleOut = --ROUND(100 * (convert(numeric,ofq.PreviousOrderHoldingIncubatorQuantity) / convert(numeric,ofq.PreviousOrderIncubatorQuantity)),2)
					convert(varchar, convert(numeric(19,2),lpd.LastCandleoutPercent)) + '%'
			 ,candleoutClass = 
				case
					when round(isnull(ofq.IncubatorQuantity,0),2) = 0 then '' 
					when ABS(
									--PreviousCandleOut
									convert(numeric(19,2),lpd.LastCandleoutPercent)
									-
									--TotalCandleOut
									convert(numeric(5,2),ROUND(100 * (convert(numeric,ofq.HoldingIncubatorQuantity) / convert(numeric,ofq.IncubatorQuantity)),2))
									) > 5 then 'candleoutDifference' else ''
				end
             ,WgtPreCon = IsNull(lpd.weightPreConversion,convert(numeric(19,1),null))
			 ,ShowWgt = '1'
             ,Wgt_PostCon = lpd.weightPreConversion*16/30
             ,HoldingIncubators = f.HoldingIncubators
             ,DeliverNbrs = f.Deliveries
             ,CasesStarted = round(convert(numeric,ofq.IncubatorQuantity) / @EggsPerCase,2)
             ,EggsDelivered = ofq.DeliveredQuantity
             ,PickOut = ROUND(100 * (1 - convert(numeric,ofq.HoldingIncubatorQuantity) / convert(numeric,ofq.IncubatorQuantity)),2)
			 ,rowClass=@oddBackground
			 ,LoadPlanning_DetailID = LoadPlanning_DetailID
			 ,f.FlockID
			 from 
			 #Flocks f
			 left outer join @incubatorFlockQuantities ofq on f.FlockID = ofq.FlockID
			 left outer join LoadPlanning lp on lp.DeliveryDate = @DeliveryDate
			 left outer join LoadPLanning_Detail lpd on lp.LoadPlanningID = lpd.LoadPlanningID and lpd.FlockID = f.FlockID
			 where f.FlockID = @FlockID01
       end
	   
       -- This is for the eggs from the primary flock that were on the mixed cart
	   -- It is the second row for the flock, but the first row for a mixed cart
       insert into #Display (Flock, PlatRacksStarted, EggsStarted, NumberFullLabCarts, Flock01, Flock02, DeliveryCartFlockID, ShelvesAtEnd, TraysAtEnd, EggsAtEnd, EggCntMixCart, rowClass, FlockID)
       select 
			@Flock01
		   ,PlatRacksStarted = null
		   ,NumberEggsStarted = null
		   ,NumberFullLabCarts = null
		   ,@FarmNbr01, @FarmNbr02
		   ,@DeliveryCartFlockID_Partial01
		   --#Shelves @ End
		   --Quantities from Cart that has current flock and next flock
		   ,ShelvesAtEnd = Round((dcf.ActualQty % @EggsPerHoldingIncubatorCart) / @EggsPerShelf, 0, 1)
		   --#Trays @ End
		   ,TraysAtEnd = Round( (dcf.ActualQty % @EggsPerShelf) / @EggsPerTray,0,1)
		   --#Eggs @ End
		   ,EggsAtEnd = dcf.ActualQty % @EggsPerTray
		   --# Eggs on Mix Cart (this is the full holding incubator flock quantity minus the full carts)
		   ,MixedEggCnt = dcf.ActualQty
		   ,rowClass = case when @isOdd = 1 then @oddBackground else @evenBackground end
		   ,f.FlockID
		from #Flocks f
		left outer join DeliveryCartFlock dcf on dcf.DeliveryCartFlockID = @DeliveryCartFlockID_Partial01
		left outer join LoadPLanning_Detail lpd on f.FlockID = lpd.FlockID and lpd.LoadPlanningID = @LoadPlanningID
		where f.FlockID = @FlockID01

		select @isOdd = case when @isOdd = 1 then 0 else 1 end
	   
       if @SortOrder < @MaxSortOrder
	   --This is the next flock for the current partial cart
	   --It is the first row for a flock, but the second row for a partial cart
       begin
             -- This is for the eggs that are were pulled from the secondary flock to fill the cart
             insert into #Display (SortOrder, Flock, PlatRacksStarted, EggsStarted, NumberFullLabCarts, Flock01, Flock02, 
			 DeliveryCartFlockID, ShelvesAtEnd, TraysAtEnd, EggsAtEnd, EggCntMixCart,
             TotalEggs, TotalCandleOut, PreviousCandleOut, candleoutClass, WgtPreCon, ShowWgt, Wgt_PostCon, 
			 HoldingIncubators, DeliveryNbrs, CasesStarted, EggsDelivered, PickOut, rowClass, LoadPlanning_DetailID, FlockID)
             select distinct
				 f.SortOrder
				 ,@FarmNbr02
				 ,PlatRacksStarted = Round(convert(numeric(19,2),ofq.IncubatorQuantity) / @EggsPerIncubatorCart,2)
				 ,NumberEggsStarted = ofq.IncubatorQuantity
				 ,NumberFullLabCarts = (select count(1) from DeliveryCartFlock dcf 
										inner join DeliveryCart dc on dcf.DeliveryCartID = dc.DeliveryCartID 
										inner join [Order] o on dc.OrderID = o.OrderID
										where --ohi.OrderID = @OrderID 
										o.DeliveryDate = @DeliveryDate
										and dcf.FlockID = @FlockID02 and dcf.ActualQty = @EggsPerHoldingIncubatorCart)
				 ,@FarmNbr01, @FarmNbr02
				 ,@DeliveryCartFlockID_Partial02
				 ,ShelvesAtEnd = Round((dcf.ActualQty % @EggsPerHoldingIncubatorCart) / @EggsPerShelf, 0, 1)
				 ,TraysAtEnd = Round( (dcf.ActualQty % @EggsPerShelf) / @EggsPerTray,0,1)
				 ,EggsAtEnd = dcf.ActualQty % @EggsPerTray
				 --# Eggs on Mix Cart (this is the full holding incubator flock quantity minus the full carts)
				 ,MixedEggCnt = dcf.ActualQty
				 ,TotalEggs = ofq.HoldingIncubatorQuantity
				 ,TotalCandleOut = 
					case
						when round(isnull(ofq.IncubatorQuantity,0),2) = 0 then ''
						else convert(varchar,convert(numeric(19,2),ROUND(100 * (convert(numeric,ofq.HoldingIncubatorQuantity) / convert(numeric,ofq.IncubatorQuantity)),2))) + '%'
					end
				 ,PreviousCandleOut = --ROUND(100 * (convert(numeric,ofq.PreviousOrderHoldingIncubatorQuantity) / convert(numeric,ofq.PreviousOrderIncubatorQuantity)),2)
						convert(varchar,lpd.LastCandleoutPercent) + '%'
				 ,candleoutClass = 
					case
						when round(isnull(ofq.IncubatorQuantity,0),2) = 0 then '' 
						when ABS(
									--PreviousCandleOut
									convert(numeric(19,2),lpd.LastCandleoutPercent)
									-
									--TotalCandleOut
									convert(numeric(5,2),ROUND(100 * (convert(numeric,ofq.HoldingIncubatorQuantity) / convert(numeric,ofq.IncubatorQuantity)),2))
									) > 5 then 'candleoutDifference' else '' end
				 ,WgtPreCon = IsNull(lpd.weightPreConversion,convert(numeric(19,1),null))
				 ,ShowWgt = '1'
				 ,Wgt_PostCon = lpd.weightPreConversion*16/30
				 ,HoldingIncubators = f.HoldingIncubators
				 ,DeliverNbrs = f.Deliveries
				 ,CasesStarted = round(convert(numeric,ofq.IncubatorQuantity) / @EggsPerCase,2)
				 ,EggsDelivered = ofq.DeliveredQuantity
				 ,PickOut = 
					case
						when round(isnull(ofq.IncubatorQuantity,0),2) = 0 then null
						else ROUND(100 * (1 - convert(numeric,ofq.HoldingIncubatorQuantity) / convert(numeric,ofq.IncubatorQuantity)),2)
					end
				 ,rowClass = case when @isOdd = 1 then @oddBackground else @evenBackground end
				 ,LoadPlanning_DetailID = lpd.LoadPlanning_DetailID
				 ,f.FlockID
			from 
				 #Flocks f
				 left outer join @incubatorFlockQuantities ofq on f.FlockID = ofq.FlockID
				 left outer join DeliveryCartFlock dcf on dcf.DeliveryCartFlockID = @DeliveryCartFlockID_Partial02
				 left outer join LoadPlanning lp on lp.DeliveryDate = @DeliveryDate
				 left outer join LoadPLanning_Detail lpd on lp.LoadPlanningID = lpd.LoadPlanningID and lpd.FlockID = f.FlockID
				 where f.FlockID = @FlockID02
       end
	   

       update #Flocks set Processed = 1 where SortOrder = @SortOrder
end

SET IDENTITY_INSERT #Display ON
--footer info
insert into #Display (DisplayID,rowClass) values (100,@footerBackground)

insert into #Display (DisplayID, Flock, PlatRacksStarted, EggsStarted, NumberFullLabCarts, Flock01, Flock02, ShelvesAtEnd, TraysAtEnd, EggsAtEnd, EggCntMixCart, TotalEggs,TotalCandleOut,rowClass)
select 999 as DisplayID, 'TOTAL OF SAMPLED EMBRYOS' as Flock, 
sum(isnull(PlatRacksStarted, 0)) as PlatRacksStarted, 
sum(isnull(EggsStarted, 0)) as EggsStarted, 
sum(isnull(NumberFullLabCarts, 0)) as NumberFullLabCarts,
'' as Flock01, 
'' as Flock02, 
sum(isnull(ShelvesAtEnd, 0)) as ShelvesAtEnd, 
sum(isnull(TraysAtEnd, 0)) as TraysAtEnd, 
sum(isnull(EggsAtEnd, 0)) as EggsAtEnd, 
'' as EggCntMixCart, 
sum(isnull(TotalEggs,0)) as TotalEggs,
case when (sum(isnull(EggsStarted,0))) = 0 then convert(varchar,convert(numeric(5,2),0)) + '%' else 
convert(varchar,convert(numeric(5,2),(sum(isnull(TotalEggs, 0)) / (sum(isnull(EggsStarted,0)) * 1.00)) * 100)) + '%' end,
@footerBackground
from #Display

SET IDENTITY_INSERT #Display OFF

--select distinct Flock, PlatRacksStarted, EggsStarted, NumberFullLabCarts, Flock01, Flock02, DeliveryCartFlockID, ShelvesAtEnd
--	,TraysAtEnd, EggsAtEnd, EggCntMixCart, TotalEggs, TotalCandleOut, PreviousCandleOut, WgtPreCon, Wgt_PostCon, HoldingIncubators
--	,DeliveryNbrs, CasesStarted, EggsDelivered, PickOut




select DisplayID, SortOrder, Flock, PlatRacksStarted,
EggsStarted = dbo.FormatIntComma(EggsStarted), NumberFullLabCarts,
Flock01, Flock02, DeliveryCartFlockID, ShelvesAtEnd, TraysAtEnd, 
EggsAtEnd = dbo.FormatIntComma(EggsAtEnd), EggCntMixCart = dbo.FormatIntComma(EggCntMixCart), 
TotalEggs = dbo.FormatIntComma(TotalEggs), TotalCandleOut, PreviousCandleOut, WgtPreCon, 
ShowWgt, Wgt_PostCon, HoldingIncubators, DeliveryNbrs, CasesStarted, 
EggsDelivered = dbo.FormatIntComma(EggsDelivered), PickOut, 
rowClass, LoadPlanning_DetailID, FlockID, candleoutClass,@LoadPlanningID as LoadPlanningID,
candleoutWeightClass = 
	case
		when IsNull(WgtPreCon,convert(numeric(19,1),null)) is null then ''
		when IsNull(WgtPreCon,convert(numeric(19,1),null)) = 0 then ''
		when IsNull(WgtPreCon,convert(numeric(19,1),null)) between 41.23 and 60.0 then ''
		else 'candleoutWeightDifference'
	end
from #Display
order by DisplayID

drop table #Flocks
drop table #Display







GO
