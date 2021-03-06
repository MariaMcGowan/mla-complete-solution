USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[rptDeliverySlip]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[rptDeliverySlip]
GO
/****** Object:  StoredProcedure [dbo].[rptDeliverySlip]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rptDeliverySlip]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[rptDeliverySlip] AS' 
END
GO


ALTER proc [dbo].[rptDeliverySlip]
	@DeliveryDate date = null, @LotNbr varchar(100) = null
AS


declare @EggsPerRack int = 4320
declare @OrderID int
declare @OrderDeliveryID int

declare @OrderList table (OrderID int, Processed bit)
declare @FlockDetail table (OrderID int, LotNbr varchar(100), CustomerReferenceNbr varchar(100), 
ActualQty int, Flock varchar(100), DeliveryDate varchar(10), 
DestinationBuilding varchar(100), DeliveryID int, DeliverySlip varchar(100))
declare @MissingDeliverySlip table (OrderDeliveryID int, OrderID int, DeliveryID int, LotNbr varchar(20), Processed bit)

insert into @OrderList (OrderID, Processed)
select OrderID, 0
from [Order]
where OrderStatusID <> 5
and isnull(LotNbr, '') <> ''
and isnull(DeliveryDate, '01/01/1900') <> '01/01/1900'
and (DeliveryDate = isnull(@DeliveryDate, '01/01/1900') or LotNbr = isnull(@LotNbr, 'XXXXXXXX'))


if exists 
	(
		select 1 from OrderDelivery od
		inner join @OrderList o on od.OrderID = o.OrderID
		where isnull(od.DeliverySlip, '') = ''
	)
begin
	-- better update the delivery slip!
	insert into @MissingDeliverySlip (OrderDeliveryID, OrderID, DeliveryID, LotNbr, Processed)
	select OrderDeliveryID, od.OrderID, DeliveryID, LotNbr, 0
	from OrderDelivery od
	inner join @OrderList ol on od.OrderID = ol.OrderID
	inner join [Order] o on ol.OrderID = o.OrderID
	where isnull(od.DeliverySlip, '') = ''

	while exists (select 1 from @MissingDeliverySlip where Processed = 0)
	begin
		select top 1 @OrderDeliveryID = OrderDeliveryID from @MissingDeliverySlip where Processed = 0

		update OrderDelivery set DeliverySlip = 
			(
				select rtrim(m.LotNbr) + '.' + right('00' + 
					cast(((select count(1) from OrderDelivery od2 where od2.OrderID = m.OrderID and IsNull(DeliverySlip,'') <> '')+ 1) as varchar),2)
				from @MissingDeliverySlip m
				where OrderDeliveryID = @OrderDeliveryID
			)
		where OrderDeliveryID = @OrderDeliveryID

		update @MissingDeliverySlip set Processed = 1 where OrderDeliveryID = @OrderDeliveryID
	end
end


insert into @FlockDetail(OrderID, LotNbr, CustomerReferenceNbr, ActualQty, 
Flock, DeliveryDate, DestinationBuilding, DeliveryID, DeliverySlip)
select distinct o.OrderID, o.LotNbr, o.CustomerReferenceNbr, sum(dcf.ActualQty) as ActualQty, 
Flock, CONVERT(char(10), DeliveryDate,101) as DeliveryDate, DestinationBuilding, d.DeliveryID, DeliverySlip
from @OrderList ol 
inner join [Order] o  on ol.OrderID = o.OrderID
inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
inner join OrderDelivery od on o.OrderID = od.OrderID
inner join Delivery d on od.DeliveryID = d.DeliveryID
inner join DeliveryCart dc on d.DeliveryID = dc.DeliveryID
inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
inner join Flock fl on dcf.FlockID = fl.FlockID
where isnull(dcf.ActualQty,0) > 0
group by o.OrderID, o.LotNbr, o.CustomerReferenceNbr, d.DeliveryID, Flock, DeliveryDate, DestinationBuilding, DeliverySlip

select fd.OrderID, fd.LotNbr, fd.DeliverySlip, DeliveryDate, DestinationBuilding, 
DeliveryID, DeliverySlipQty as ActualQty,
RackCntPartCnt = 
dbo.FormatIntToVarcharWithComma(Racks) + '  Racks  ' + 
case
	when PartialRackEggCnt > 0 then '  +    ' + dbo.FormatIntToVarcharWithComma(PartialRackEggCnt) + '  Eggs on the part'
	else ''
end, Flock, CustomerReferenceNbr
from @FlockDetail fd
inner join 
(
	select OrderID, LotNbr, DeliverySlip, sum(ActualQty) as DeliverySlipQty,
	Round((sum(ActualQty) / @EggsPerRack),0,1) as Racks, sum(ActualQty) % @EggsPerRack as PartialRackEggCnt
	from @FlockDetail
	group by OrderID, LotNbr, DeliverySlip
) ds
on fd.OrderID = ds.OrderID and fd.LotNbr = ds.LotNbr and fd.DeliverySlip = ds.DeliverySlip
order by OrderID, DeliveryID, Flock

-- Now that you are printing the delivery slip, the actual quantity is official!
update d set d.ActualQty = ds.DeliverySlipQty
from Delivery d
inner join 
(
	select DeliveryID, sum(ActualQty) as DeliverySlipQty
	from @FlockDetail
	group by DeliveryID
) ds
on ds.DeliveryID = d.DeliveryID


update o set o.OrderQty = ds.SumDeliverySlipQty, OrderStatusID = 4
from [order] o
inner join 
(
	select OrderID, sum(ActualQty) as SumDeliverySlipQty
	from @FlockDetail
	group by OrderID
) ds
on o.OrderID = ds.OrderID



GO
