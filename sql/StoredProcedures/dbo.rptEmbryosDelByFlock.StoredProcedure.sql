USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[rptEmbryosDelByFlock]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[rptEmbryosDelByFlock]
GO
/****** Object:  StoredProcedure [dbo].[rptEmbryosDelByFlock]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rptEmbryosDelByFlock]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[rptEmbryosDelByFlock] AS' 
END
GO


ALTER proc [dbo].[rptEmbryosDelByFlock] @DeliveryDate date = null, @LotNbr varchar(100)
as

--declare @DeliveryDate date = null, @LotNbr varchar(100)
--select @DeliveryDate = '02/09/2017'

create table #OrderList (OrderID int)

insert into #OrderList (OrderID)
select OrderID 
from [Order]
where OrderStatusID <> 5
and isnull(LotNbr, '') <> ''
and isnull(DeliveryDate, '01/01/1900') <> '01/01/1900'
and (DeliveryDate = isnull(@DeliveryDate, '01/01/1900') or LotNbr = isnull(@LotNbr, 'XXXXXXXX'))

if IsNull(@DeliveryDate, '1/1/1900') = '1/1/1900'
	select @DeliveryDate = DeliveryDate
	from [Order] where LotNbr = @LotNbr

--Let's get the totals for our incubators from this order and the previous order
--I'm pulling from the Delivery Cart Eggs to get the exact FlockID's. In theory OrderFlock should have all the flocks
declare @incubatorFlockQuantities table (FlockID int, IncubatorQuantity int, 
HoldingIncubatorQuantity int)
insert into @incubatorFlockQuantities (FlockID)
select distinct FlockID
from #OrderList ol
inner join OrderDelivery od on ol.OrderID = od.OrderID
inner join Delivery d on od.DeliveryID = d.DeliveryID
inner join DeliveryCart dc on d.DeliveryID = dc.DeliveryID
inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
where FlockID is not null

--PRC- I have done this based on delivery date and it is exactly the same as the Candling Screen. This is because the candleout can only be
--based on Flock and Delivery Date- we don't have the data connection between Incubator and Holding Incubator to actually calculate a specific
--order-based candleout percent
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
					--sum(isnull(dcf.ActualQty,0) - IsNull(et.QtyChange,0))
					sum(ABS(isnull(dcf.ActualQty,0) - IsNull(et.QtyChange,0)))
                    from DeliveryCartFlock dcf
                    inner join DeliveryCart dc on dc.DeliveryCartID = dcf.DeliveryCartID
					inner join [Order] o on dc.OrderID = o.OrderID
					left outer join EggTransaction et on dcf.DeliveryCartFlockID = et.DeliveryCartFlockID
                    where --ohi.OrderID = @OrderID 
					o.DeliveryDate = @DeliveryDate
					and dcf.FlockID = ofq.FlockID
             )      
from @incubatorFlockQuantities ofq


select 
	o.OrderID
	, o.LotNbr
	,DATENAME(MONTH, o.DeliveryDate) 
			 + RIGHT(CONVERT(VARCHAR(12), o.DeliveryDate, 107), 9) AS DeliveryDate
	,CustomerReferenceNbr as PONbr
	,'Bldg ' + db.DestinationBuilding as Bldg
	,f.Flock
	,sum(dcf.ActualQty) as EmbryosDel 
	--case
	--	when sum(isnull(et.QtyChange,0)) = 0 then '%'
	--	else cast(cast((sum(isnull(et.QtyChange,0)) / ((sum(ofcl.ActualQty) + sum(isnull(et.QtyChange,0))) * 1.00)) *100 as numeric(4,2)) as varchar) + '%'
	--end as Candleout
	,
	case
		when isnull(ofq.IncubatorQuantity, 0) = 0 then ''
		when round(ofq.IncubatorQuantity, 2) = 0 then ''
		else 
			convert(varchar, 100 - 
			convert(numeric(5,2),ROUND(100 * (convert(numeric,ofq.HoldingIncubatorQuantity) / convert(numeric,ofq.IncubatorQuantity)),2))
			) + '%'
	end as Candleout
from #OrderList ol
inner join [Order] o on ol.OrderID = o.OrderID

inner join OrderDelivery od on ol.OrderID = od.OrderID
inner join Delivery d on od.DeliveryID = d.DeliveryID
inner join DeliveryCart dc on d.DeliveryID = dc.DeliveryID
inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
inner join Flock f on dcf.FlockID = f.FlockID

inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
left outer join @incubatorFlockQuantities ofq on ofq.FlockID = dcf.FlockID
group by o.OrderID, o.LotNbr, o.DeliveryDate, o.CustomerReferenceNbr, db.DestinationBuilding,
f.Flock,ofq.HoldingIncubatorQuantity, ofq.IncubatorQuantity
having sum(dcf.ActualQty) > 0
Order by o.LotNbr, f.Flock

drop table #OrderList



GO
