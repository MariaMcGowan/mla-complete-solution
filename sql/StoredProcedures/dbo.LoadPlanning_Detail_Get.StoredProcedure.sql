USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_Detail_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[LoadPlanning_Detail_Get]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_Detail_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning_Detail_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[LoadPlanning_Detail_Get] AS' 
END
GO

ALTER proc [dbo].[LoadPlanning_Detail_Get] @LoadPlanningID int
As

declare @DeliveryDate date
select @DeliveryDate = DeliveryDate 
	from LoadPlanning 
	where LoadPlanningID = @LoadPlanningID

declare @defaultOverflowFlockID int
select top 1 @defaultOverflowFlockID = OverflowFlockID 
	from LoadPlanning
	where DeliveryDate <= @DeliveryDate
	order by DeliveryDate desc

--Get the flocks
declare @candleoutPercent table (FlockID int, Delivery1 date, Delivery2 date, Delivery3 date
											, IncubatorQty1 int, IncubatorQty2 int, IncubatorQty3 int
											, HoldingIncubatorQty1 int, HoldingIncubatorQty2 int, HoldingIncubatorQty3 int)
insert into @candleoutPercent (FlockID)
select FlockID from Flock where IsActive = 1

--grab the previous 3 delivery dates per flock
Update cp
	set Delivery1 = (select top 1 DeliveryDate
						from [Order] o
						inner join OrderDelivery od on o.OrderID = od.OrderID
						inner join DeliveryCart dc on od.DeliveryID = dc.DeliveryID
						inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
						where dcf.FlockID = cp.FlockID 
						and isnull(dcf.ActualQty,0) > 0
						order by DeliveryDate desc
					)
from @candleoutPercent cp


Update cp
	set Delivery2 = (select top 1 DeliveryDate
						from [Order] o
						inner join OrderDelivery od on o.OrderID = od.OrderID
						inner join DeliveryCart dc on od.DeliveryID = dc.DeliveryID
						inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
						where dcf.FlockID = cp.FlockID 
						and isnull(dcf.ActualQty,0) > 0
						and o.DeliveryDate < IsNull(cp.Delivery1,'1/1/1900')
						order by DeliveryDate desc
					)
from @candleoutPercent cp

Update cp
	set Delivery3 = (select top 1 DeliveryDate
						from [Order] o
						inner join OrderDelivery od on o.OrderID = od.OrderID
						inner join DeliveryCart dc on od.DeliveryID = dc.DeliveryID
						inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
						where dcf.FlockID = cp.FlockID 
						and isnull(dcf.ActualQty,0) > 0
						and o.DeliveryDate < IsNull(cp.Delivery2,'1/1/1900')
						order by DeliveryDate desc
					)
from @candleoutPercent cp

--get the total incubated for that delivery date per flock
update cp
	set IncubatorQty1 = (select SUM(IsNull(oic.ActualQty,0))
							from OrderIncubatorCart oic
							inner join Clutch c on oic.ClutchID = c.ClutchID
							inner join OrderIncubator oi on oic.OrderIncubatorID = oi.OrderIncubatorID
							inner join [Order] o on oi.OrderID = o.OrderID							
							where c.FlockID = cp.FlockID
							and oic.ActualQty > 0
							and o.DeliveryDate = cp.Delivery1)
		,IncubatorQty2 = (select SUM(IsNull(oic.ActualQty,0))
							from OrderIncubatorCart oic
							inner join Clutch c on oic.ClutchID = c.ClutchID
							inner join OrderIncubator oi on oic.OrderIncubatorID = oi.OrderIncubatorID
							inner join [Order] o on oi.OrderID = o.OrderID							
							where c.FlockID = cp.FlockID
							and oic.ActualQty > 0
							and o.DeliveryDate = cp.Delivery2)
		,IncubatorQty3 = (select SUM(IsNull(oic.ActualQty,0))
							from OrderIncubatorCart oic
							inner join Clutch c on oic.ClutchID = c.ClutchID
							inner join OrderIncubator oi on oic.OrderIncubatorID = oi.OrderIncubatorID
							inner join [Order] o on oi.OrderID = o.OrderID							
							where c.FlockID = cp.FlockID
							and oic.ActualQty > 0
							and o.DeliveryDate = cp.Delivery3)




		,HoldingIncubatorQty1 = (select sum(ABS(isnull(dcf.ActualQty,0) - IsNull(et.QtyChange,0)))
							from DeliveryCartFlock dcf
							inner join DeliveryCart dc on dc.DeliveryCartID = dcf.DeliveryCartID
							inner join [Order] o on dc.OrderID = o.OrderID
							left outer join EggTransaction et on dcf.DeliveryCartFlockID = et.DeliveryCartFlockID
							where o.DeliveryDate =  cp.Delivery1
							--and dcf.ActualQty > 0
							and dcf.FlockID =  cp.FlockID)
		,HoldingIncubatorQty2 = (select sum(ABS(isnull(dcf.ActualQty,0) - IsNull(et.QtyChange,0)))
							from DeliveryCartFlock dcf
							inner join DeliveryCart dc on dc.DeliveryCartID = dcf.DeliveryCartID
							inner join [Order] o on dc.OrderID = o.OrderID
							left outer join EggTransaction et on dcf.DeliveryCartFlockID = et.DeliveryCartFlockID
							where o.DeliveryDate =  cp.Delivery2
							--and dcf.ActualQty > 0
							and dcf.FlockID =  cp.FlockID)
		,HoldingIncubatorQty3 = (select sum(ABS(isnull(dcf.ActualQty,0) - IsNull(et.QtyChange,0)))
							from DeliveryCartFlock dcf
							inner join DeliveryCart dc on dc.DeliveryCartID = dcf.DeliveryCartID
							inner join [Order] o on dc.OrderID = o.OrderID
							left outer join EggTransaction et on dcf.DeliveryCartFlockID = et.DeliveryCartFlockID
							where o.DeliveryDate =  cp.Delivery3
							--and dcf.ActualQty > 0
							and dcf.FlockID =  cp.FlockID)
from @candleoutPercent cp

declare @totalQuantity int, @overflowFlockID int, @PercentCushion numeric(5,3)
select @overflowFlockID = overflowFlockID, @PercentCushion = PercentCushion from LoadPlanning where LoadPlanningID = @LoadPlanningID
select @totalQuantity = SUM(IsNull(FlockQty,0) * (LastCandleoutPercent / 100)) from LoadPLanning_Detail where LoadPLanningID = @LoadPlanningID and FlockID <> @overflowFlockID
select @totalQuantity = IsNull(@totalQuantity,0)

declare @coolerClutch table (FlockID int, LayDateQuantity nvarchar(500))
insert into @coolerClutch (FlockID)
select FlockID
from Flock
where IsActive = 1

declare @currentFlockID int, @currentLayDateQuantity nvarchar(500)
while exists (select 1 from @coolerClutch where LayDateQuantity is null)
begin
	select top 1 @currentFlockID = FlockID, @currentLayDateQuantity = '' from @coolerClutch where LayDateQuantity is null

	select @currentLayDateQuantity = @currentLayDateQuantity 
		-- + case when @currentLayDateQuantity = '' then '' else '<br/>' end
		+ convert(nvarchar,c.LayDate,22) + ': '
		+ convert(nvarchar,convert(numeric(19,2),Round(dbo.ConvertEggsToIncubatorCarts(IsNull(cc.ActualQty,0)),2))) + ' carts'
		-- <br>'
		+ ' (' + dbo.FormatIntComma(IsNull(cc.ActualQty,0)) + ' eggs) <br>'
	from CoolerClutch cc
	inner join Clutch c on cc.ClutchID = c.ClutchID
	where c.FlockID = @currentFlockID and isnull(cc.ActualQty,0) > 0
	order by c.LayDate

	if @currentLayDateQuantity = '' set @currentLayDateQuantity = null

	update @coolerClutch set LayDateQuantity = IsNull(@currentLayDateQuantity,'none') where FlockID = @currentFlockID
end


declare @results table (
	LoadPlanning_DetailID	int
	,LoadPlanningID	int
	,IsOverflow	bit
	,OverflowFlockID	int
	,FarmNumber	nvarchar(20)
	,FlockID	int
	,FlockIncubatorCartQty	numeric(19,5)
	,FlockQty	numeric(38,10)
	,LayDateQuantity	nvarchar(500)
	,LastCandleoutPercent	numeric(5,2)
	,Delivery1	nvarchar(30)
	,Delivery2	nvarchar(30)
	,Delivery3	nvarchar(30)
	,CandleoutPercent1	numeric(38,16)
	,CandleoutPercent2	numeric(38,16)
	,CandleoutPercent3	numeric(38,16)
	,ProjectedOutcome	numeric(20,6)
	,ProjectedOutcomeDeliveryCarts	numeric(19,5)
	,FarmID	int
	--,AssociatedToOrder bit
)


insert into @results (LoadPlanning_DetailID
	,LoadPlanningID
	,IsOverflow
	,OverflowFlockID
	,FarmNumber
	,FlockID
	,FlockIncubatorCartQty
	,FlockQty
	,LayDateQuantity
	,LastCandleoutPercent
	,Delivery1
	,Delivery2
	,Delivery3
	,CandleoutPercent1
	,CandleoutPercent2
	,CandleoutPercent3
	,ProjectedOutcome
	,ProjectedOutcomeDeliveryCarts
	--,AssociatedToOrder
	)
select
	IsNull(lpd.LoadPlanning_DetailID,0) as LoadPlanning_DetailID
	,@LoadPlanningID as LoadPlanningID
	,case when f.FlockID = lp.OverflowFlockID then convert(bit,1) else convert(bit,0) end as IsOverflow
	,IsNull(lp.OverflowFlockID,@defaultOverflowFlockID) as OverflowFlockID
	,convert(varchar,fm.FarmNumber)
	,f.FlockID
	,case 
		when f.FlockID = lp.OverflowFlockID  and isnull(lpd.FlockQty,0) > 0 then Round(dbo.ConvertEggsToIncubatorCarts(lpd.FlockQty),2)
		when f.FlockID = lp.OverflowFlockID  and isnull(lpd.LastCandleOutPercent,0) = 0 then null
		when f.FlockID = lp.OverflowFlockID then
			dbo.ConvertEggsToIncubatorCarts(Round(((lp.TargetQty / (1 - (@PercentCushion/100)) - @totalQuantity) / (lpd.LastCandleoutPercent / 100))/144,0) * 144 )
		else Round(dbo.ConvertEggsToIncubatorCarts(lpd.FlockQty),2)
		end as FlockIncubatorCartQty
	,case 
		when f.FlockID = lp.OverflowFlockID and isnull(lpd.FlockQty,0) > 0 then lpd.FlockQty
		when f.FlockID = lp.OverflowFlockID and isnull(lpd.LastCandleoutPercent,0) = 0 then null
		when f.FlockID = lp.OverflowFlockID then
			Round(((lp.TargetQty / (1 - (@PercentCushion/100)) - @totalQuantity) / (lpd.LastCandleoutPercent / 100))/144,0) * 144
		else lpd.FlockQty
		end as FlockQty
	,cc.LayDateQuantity
	,lpd.LastCandleoutPercent
	,convert(nvarchar,cp.Delivery1,22) As Delivery1
	,convert(nvarchar,cp.Delivery2,22) As Delivery2
	,convert(nvarchar,cp.Delivery3,22) As Delivery3
	,case when cp.HoldingIncubatorQty1 = 0 or cp.IncubatorQty1 = 0 then 0 
		else ROUND(100 * (convert(numeric,cp.HoldingIncubatorQty1) / convert(numeric,cp.IncubatorQty1)),2) end As CandleoutPercent1
	,case when cp.HoldingIncubatorQty1 = 0 or cp.IncubatorQty1 = 0 then 0 
		else ROUND(100 * (convert(numeric,cp.HoldingIncubatorQty2) / convert(numeric,cp.IncubatorQty2)),2) end As CandleoutPercent2
	,case when cp.HoldingIncubatorQty1 = 0 or cp.IncubatorQty1 = 0 then 0 
		else ROUND(100 * (convert(numeric,cp.HoldingIncubatorQty3) / convert(numeric,cp.IncubatorQty3)),2) end As CandleoutPercent3
	,Round(FlockQty * (lpd.LastCandleoutPercent / 100),0) As ProjectedOutcome
	,Round(dbo.ConvertEggsToHoldingIncubatorCarts(Round(lpd.FlockQty * (lpd.LastCandleoutPercent / 100),0)),1) As ProjectedOutcomeDeliveryCarts
	--,AssociatedToOrder = 
	--	case
	--		when exists (select 1 from [Order] o inner join OrderFlock ofl on o.OrderID = ofl.OrderID where DeliveryDate = @DeliveryDate and FlockID = f.FlockID) then 1
	--		else 0
	--	end
from
Flock f
inner join Farm fm on f.FarmID = fm.FarmID
inner join LoadPlanning lp on lp.LoadPlanningID = @LoadPlanningID
left outer join @coolerClutch cc on f.FlockID = cc.FlockID
left outer join LoadPlanning_Detail lpd on lp.LoadPlanningID = lpd.LoadPLanningID and lpd.FlockID = f.FlockID
left outer join @candleoutPercent cp on f.FlockID = cp.FlockID
where f.IsActive = 1 or isnull(lpd.FlockQty,0) > 0

insert into @results (LoadPlanning_DetailID
	,LoadPlanningID
	,IsOverflow
	,OverflowFlockID
	,FarmNumber
	,FlockID
	,FlockIncubatorCartQty
	,FlockQty
	,LayDateQuantity
	,LastCandleoutPercent
	,Delivery1
	,Delivery2
	,Delivery3
	,CandleoutPercent1
	,CandleoutPercent2
	,CandleoutPercent3
	,ProjectedOutcome
	,ProjectedOutcomeDeliveryCarts
	--,AssociatedToOrder
	)
select
	LoadPlanning_DetailID = -1
	,LoadPlanningID = @LoadPlanningID
	,IsOverflow = null
	,OverflowFlockID = @overflowFlockID
	,FarmNumber = 'TOTALS'
	,FlockID = null
	,FlockIncubatorCartQty = SUM(FlockIncubatorCartQty)
	,FlockQty = SUM(FlockQty)
	,LayDateQuantity = ''
	,LastCandleoutPercent = AVG(LastCandleoutPercent)
	,Delivery1 = ''
	,Delivery2 = ''
	,Delivery3 = ''
	,CandleoutPercent1 = 0
	,CandleoutPercent2 = 0
	,CandleoutPercent3 = 0
	,ProjectedOutcome = SUM(ProjectedOutcome)
	,ProjectedOutcomeDeliveryCarts = SUM(ProjectedOutcomeDeliveryCarts)
	--,0
from @results

select LoadPlanning_DetailID, LoadPlanningID, IsOverflow, OverflowFlockID, FarmNumber, FlockID,
FlockIncubatorCartQty, FlockQty = dbo.FormatIntComma(FlockQty), LayDateQuantity,
LastCandleoutPercent, Delivery1, Delivery2, Delivery3, 
CandleoutPercent1, CandleoutPercent2, CandleoutPercent3,
ProjectedOutcome = dbo.FormatIntComma(ProjectedOutcome), ProjectedOutcomeDeliveryCarts, FarmID
from @results order by FarmNumber
GO
