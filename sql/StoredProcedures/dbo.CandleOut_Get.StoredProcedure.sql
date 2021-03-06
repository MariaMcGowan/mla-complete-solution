USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CandleOut_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CandleOut_Get]
GO
/****** Object:  StoredProcedure [dbo].[CandleOut_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CandleOut_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CandleOut_Get] AS' 
END
GO



ALTER proc [dbo].[CandleOut_Get] @LoadPlanningID int
as


--This report runs based on Delivery Date
--However it is easier to get that from LoadPlanningID in the UI, so that's why I used that parameter
--declare @DeliveryDate date
--select @DeliveryDate = DeliveryDate
--from LoadPLanning
--where LoadPlanningID = @LoadPlanningID

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
--where o.DeliveryDate = @DeliveryDate
where o.LoadPlanningID = @LoadPlanningID


--if not exists (select 1 from LoadPlanning_Detail where LoadPlanningID = @LoadPlanningID and IsNull(candlingSortOrder,0) <> 0)
--begin
	declare @tempFlockOrder table (FarmNumber varchar(4), FlockID int, SortOrder int)
	insert into @tempFlockOrder (FarmNumber, FlockID, SortOrder)
	select FarmNumber, fl.FlockID, ROW_NUMBER() OVER (ORDER BY FarmNumber ASC) as SortOrder
	from [Order] o 
	inner join OrderIncubator oi on o.OrderID = oi.OrderID
	inner join OrderIncubatorCart oic on oi.OrderIncubatorID = oic.OrderIncubatorID
	inner join Clutch c on c.ClutchID = oic.ClutchID
	inner join Flock fl on c.FlockID = fl.FlockID
	inner join Farm f on fl.FarmID = f.FarmID
	--where o.DeliveryDate = @DeliveryDate
	where OrderStatusID <> 5
	and o.LoadPlanningID = @LoadPlanningID
	group by FarmNumber, fl.FlockID

	update lpd
		set lpd.candlingSortOrder = tfo.SortOrder
	from LoadPlanning_Detail lpd
	inner join @tempFlockOrder tfo on lpd.FlockID = tfo.FlockID
	where lpd.LoadPlanningID = @LoadPlanningID
--end

select
	lpd.FlockID, f.Flock, 0 as Processed, lpd.candlingSortOrder as SortOrder, convert(nvarchar(255),null) as HoldingIncubators, convert(nvarchar(255),null) as Deliveries
into #Flocks
from LoadPLanning_Detail lpd
	inner join Flock f on lpd.FlockID = f.FlockID
where lpd.LoadPlanningID = @LoadPlanningID and lpd.candlingSortOrder is not null

--select *
--from LoadPLanning_Detail lpd
--	inner join Flock f on lpd.FlockID = f.FlockID
--	where lpd.LoadPlanningID = 1138

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
					--and o.DeliveryDate = @DeliveryDate
					and o.LoadPlanningID = @LoadPlanningID
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
					--o.DeliveryDate = @DeliveryDate
					o.LoadPlanningID = @LoadPlanningID
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
					--and o.DeliveryDate = @DeliveryDate
					and o.LoadPlanningID = @LoadPlanningID
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
			where o.OrderStatusID <> 5
			and dcf.FlockID = @currentID 
			and o.LoadPlanningID = @LoadPlanningID
			--o.DeliveryDate = @DeliveryDate
			) a

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
			where o.OrderStatusID <> 5
			and dcf.FlockID = @currentID 
			--and o.DeliveryDate = @DeliveryDate
			and o.LoadPlanningID = @LoadPlanningID
			) a
			
       update #Flocks
       set HoldingIncubators = IsNull(@HoldingIncubators,''), Deliveries = IsNull(@Deliveries,'')
       where FlockID = @currentID
	   
end


create table #Display (DisplayID int identity(1,1), SortOrder int, FlockNbr varchar(50), 
Flock varchar(50), PlatRacksStarted numeric(19,2), EggsStarted int, DeliveryCartFlockID int, 
CartsAtEnd int, ShelvesAtEnd int, TraysAtEnd int, EggsAtEnd int, TotalEggs int,
TotalCandleOut varchar(10), PreviousCandleOut varchar(10), WgtPreCon numeric(5,2), ShowWgt varchar(1), Wgt_PostCon numeric(5,2), 
HoldingIncubators varchar(100), DeliveryNbrs varchar(100), CasesStarted numeric(5,1), EggsDelivered int, PickOut numeric(5,2),
rowClass varchar(50), LoadPlanning_DetailID int, FlockID int, candleoutClass varchar(50))

declare @SortOrder int
declare @FlockID int
declare @FlockNbr int
declare @Flock varchar(100)
declare @MaxSortOrder int
select @MaxSortOrder = max(SortOrder) from #Flocks where Processed = 0


--Let's loop through each row we want to display, in order based on #flocks table
declare @isOdd bit = 1, @oddBackground varchar(20) = 'background100', @evenBackground varchar(20) = 'whiteBackground', @footerBackground varchar(20) = 'background200'

while exists (select 1 from #Flocks where Processed = 0)
begin
	select top 1 @FlockID = FlockID, @SortOrder = SortOrder
    from #Flocks
    where Processed = 0
    order by SortOrder

	update #Flocks set Processed = 1 where SortOrder = @SortOrder
    
	select @FlockNbr = FarmNumber, @Flock = Flock
	from Farm f 
	inner join Flock fl on f.FarmID = fl.FarmID
	where FlockID = @FlockID
	
	insert into #Display (SortOrder, FlockNbr, Flock, PlatRacksStarted, EggsStarted, TotalEggs, TotalCandleOut, 
	PreviousCandleOut, candleoutClass, WgtPreCon, ShowWgt, Wgt_PostCon, HoldingIncubators, DeliveryNbrs, CasesStarted, EggsDelivered, 
	PickOut, rowClass, LoadPlanning_DetailID, FlockID)
    select f.SortOrder, @FlockNbr, @Flock
    ,PlatRacksStarted = Round(convert(numeric(19,2),ofq.IncubatorQuantity) / @EggsPerIncubatorCart,2)
    ,NumberEggsStarted = ofq.IncubatorQuantity
    ,TotalEggs = ofq.HoldingIncubatorQuantity
    ,TotalCandleOut = 
	case
		when round(isnull(ofq.IncubatorQuantity,0),2) = 0 then ''
		else convert(varchar,convert(numeric(5,2),ROUND(100 * (convert(numeric,ofq.HoldingIncubatorQuantity) / convert(numeric,ofq.IncubatorQuantity)),2))) + '%'
	end
    ,PreviousCandleOut = convert(varchar, convert(numeric(19,2),lpd.LastCandleoutPercent)) + '%'
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
	,rowClass=
	case
		when @isOdd = 1 then @oddBackground
		else @evenBackground
	end,LoadPlanning_DetailID = LoadPlanning_DetailID
	,f.FlockID
	from 
	#Flocks f
	left outer join @incubatorFlockQuantities ofq on f.FlockID = ofq.FlockID
	left outer join LoadPlanning lp on lp.LoadPlanningID = @LoadPlanningID
	left outer join LoadPLanning_Detail lpd on lp.LoadPlanningID = lpd.LoadPlanningID and lpd.FlockID = f.FlockID
	where f.FlockID = @FlockID

	select @isOdd =  (@isOdd ^ 1)

end

update #Display set CartsAtEnd = TotalEggs / @EggsPerHoldingIncubatorCart
update #Display set ShelvesAtEnd = (TotalEggs - (@EggsPerHoldingIncubatorCart * CartsAtEnd))/@EggsPerShelf
update #Display set TraysAtEnd = (TotalEggs - (@EggsPerHoldingIncubatorCart * CartsAtEnd) - (@EggsPerShelf * ShelvesAtEnd))/@EggsPerTray
update #Display set EggsAtEnd = (TotalEggs - (@EggsPerHoldingIncubatorCart * CartsAtEnd) - (@EggsPerShelf * ShelvesAtEnd) - (@EggsPerTray * TraysAtEnd))


SET IDENTITY_INSERT #Display ON
--footer info
insert into #Display (DisplayID,rowClass) values (100,@footerBackground)

insert into #Display (DisplayID, FlockNbr, Flock, PlatRacksStarted, EggsStarted, CartsAtEnd, ShelvesAtEnd, TraysAtEnd, EggsAtEnd, TotalEggs,TotalCandleOut,rowClass)
select 999 as DisplayID, 'TOTAL OF SAMPLED EMBRYOS' as FlockNbr, 
'TOTAL OF SAMPLED EMBRYOS' as Flock, 
sum(isnull(PlatRacksStarted, 0)) as PlatRacksStarted, 
sum(isnull(EggsStarted, 0)) as EggsStarted, 
sum(isnull(CartsAtEnd, 0)) as CartsAtEnd, 
sum(isnull(ShelvesAtEnd, 0)) as ShelvesAtEnd, 
sum(isnull(TraysAtEnd, 0)) as TraysAtEnd, 
sum(isnull(EggsAtEnd, 0)) as EggsAtEnd, 
sum(isnull(TotalEggs,0)) as TotalEggs,

case when (sum(isnull(EggsStarted,0))) = 0 then convert(varchar,convert(numeric(5,2),0)) + '%' else 
convert(varchar,convert(numeric(5,2),(sum(isnull(TotalEggs, 0)) / (sum(isnull(EggsStarted,0)) * 1.00)) * 100)) + '%' end,
@footerBackground
from #Display

SET IDENTITY_INSERT #Display OFF

select DisplayID, SortOrder, 
--FlockNbr, 
Flock, 
PlatRacksStarted,
EggsStarted = dbo.FormatIntComma(EggsStarted), 
TotalEggs = dbo.FormatIntComma(TotalEggs), 
CartsAtEnd = dbo.FormatIntComma(CartsAtEnd), 
ShelvesAtEnd = dbo.FormatIntComma(ShelvesAtEnd), 
TraysAtEnd = dbo.FormatIntComma(TraysAtEnd), 
EggsAtEnd = dbo.FormatIntComma(EggsAtEnd), 
TotalEggs = dbo.FormatIntComma(TotalEggs), 

TotalCandleOut, PreviousCandleOut, WgtPreCon, 
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
