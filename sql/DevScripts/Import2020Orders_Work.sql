--update MapleLawn_2020_Bldg37Orders set Bldg_37 = replace(replace(bldg_37, '"', ''), ',', '')
--select * from MapleLawn_2020_Bldg37Orders
--59 = 6
--37 = 7
;with Orders (SetDate, DeliveryDate, Bldg_59, Bldg_37) as
(
	select 
	  SetDate = convert(varchar(10), convert(date, right(SetDate, len(SetDate) - 4)), 101)
	, DeliveryDate = convert(varchar(10), convert(date, right(DeliveryDate, len(DeliveryDate) - 4)), 101)
	, Bldg_59
	, Bldg_37
	from MapleLawn_2020_Bldg37Orders
)

select 'exec Order_InsertUpdate @I_vOrderID = 0, @I_vIncubationDayCnt = 11, @I_vDestinationID = 1, @I_vCustomerReferenceNbr = ''Order Entry'', @I_vPlannedQty = ' + Bldg_59 + ', @I_vDestinationBuildingID = 6, 
@I_vOrderStatusID = 1, @I_vDeliveryDate = ' + '''' + DeliveryDate + '''' + ', @I_vPlannedSetDate = ' + '''' + SetDate + '''' + ', @I_vUserName =' + '''' + 'THESUMMITGRP\mmcgowan' + ''''
from Orders
where Bldg_59 <> ''
union all
select 'exec Order_InsertUpdate @I_vOrderID = 0, @I_vIncubationDayCnt = 11, @I_vDestinationID = 1, @I_vCustomerReferenceNbr = ''Order Entry'', @I_vPlannedQty = ' + Bldg_37 + ', @I_vDestinationBuildingID = 7, 
@I_vOrderStatusID = 1, @I_vDeliveryDate = ' + '''' + DeliveryDate + '''' + ', @I_vPlannedSetDate = ' + '''' + SetDate + '''' + ', @I_vUserName =' + '''' + 'THESUMMITGRP\mmcgowan' + ''''
from Orders
where Bldg_37 <> ''