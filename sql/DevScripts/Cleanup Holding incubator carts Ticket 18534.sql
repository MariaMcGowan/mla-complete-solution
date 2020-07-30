declare @DeliveryID int = 2884


declare @DeleteMe table (IncubatorLocationNumber int, DeliveryCartID int)

declare @firstDeliveryCart table (DeliveryCartID int, DeliveryCartFlockID int)
insert into @firstDeliveryCart (DeliveryCartID)
select DeliveryCartID 
	from DeliveryCart dc
	inner join Delivery d on dc.DeliveryID = d.DeliveryID
	where d.DeliveryID = @DeliveryID

update fdc
set DeliveryCartFlockID = (select top 1 DeliveryCartFlockID from DeliveryCartFlock dcf where dcf.DeliveryCartID = fdc.DeliveryCartID)
from @firstDeliveryCart fdc


insert into @DeleteMe (IncubatorLocationNumber, DeliveryCartID)
select IncubatorLocationNumber, dcf1.DeliveryCartID
	from Delivery d
		--left outer join OrderHoldingIncubator ohi on o.OrderID = ohi.OrderID and ohi.HoldingIncubatorID = @HoldingIncubatorID
		left outer join DeliveryCart dc on d.DeliveryID = dc.DeliveryID
		left outer join @firstDeliveryCart fdc on fdc.DeliveryCartID = dc.DeliveryCartID
		left outer join DeliveryCartFlock dcf1 on fdc.DeliveryCartID = dcf1.DeliveryCartID and dcf1.DeliveryCartFlockID = fdc.DeliveryCartFlockID
		left outer join DeliveryCartFlock dcf2 on dcf2.DeliveryCartID = dc.DeliveryCartID and dcf2.DeliveryCartFlockID <> fdc.DeliveryCartFlockID
		where @DeliveryID = d.DeliveryID
			and dcf1.ActualQty = 0 
			and dcf2.ActualQty = 0
order by 1

select *
from @DeleteMe
order by 1


select *
into DeliveryCartFlock_20200318_2884
from DeliveryCartFlock
where DeliveryCartID in (select DeliveryCartID from @DeleteMe)


delete
from DeliveryCartFlock
where DeliveryCartID in (select DeliveryCartID from DeliveryCartFlock_20200318_2884)

select *
into DeliveryCart_20200318_2884
from DeliveryCart
where DeliveryCartID in (select DeliveryCartID from @DeleteMe)


delete
from DeliveryCart
where DeliveryCartID in (select DeliveryCartID from DeliveryCart_20200318_2884)