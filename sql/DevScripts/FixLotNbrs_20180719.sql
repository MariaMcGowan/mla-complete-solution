select OrderID, DeliveryDate, db.DestinationBuilding, LotNbr
from [Order] o
inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
where DeliveryDate in ('07/22/2018', '07/23/2018')

update [Order] set LotNbr = '1859170' where OrderID = 1596

update [Order] set LotNbr = '1859171' where OrderID = 1597

update [Order] set LotNbr = '1837171' where OrderID = 1719

select *
into Order_Backup_20180718
from [Order]


select OrderID, DestinationBuilding, DeliveryDate, LotNbr as Current_LotNbr,
left(LotNbr, 4) + convert(varchar(3), convert(int, right(lotnbr, 3)) -1) as New_LotNbr
into Order_FixLotNbr_20180718_03
from [Order] o
inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
where LotNbr like '18%'
and convert(int, right(lotnbr, 3)) > 170
and OrderID not in (1596, 1597, 1719)
order by DeliveryDate

update o set o.LotNbr = fix.New_LotNbr
from [Order] o
inner join Order_FixLotNbr_20180718_03 fix on o.OrderID = fix.OrderID


select OrderID, DeliveryDate, LotNbr
from [Order] o
where exists 
(select 1 from Order_FixLotNbr_20180718 f where OrderID = o.OrderID)
order by DeliveryDate

select *
from Order_FixLotNbr_20180718_03
order by DeliveryDate