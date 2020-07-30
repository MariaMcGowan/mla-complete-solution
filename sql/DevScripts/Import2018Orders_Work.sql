--select *
--from MLA.[dbo].[MapleLawn_2018 Delivery Schedule]

--exec Order_InsertUpdate @I_vOrderID = 0, @I_vIncubationDayCnt = 11, @I_vDestinationID = 1, @I_vCustomerReferenceNbr = 'Order Entry', @I_vUserName ='|UserName|'">


--59 = 6
--37 = 7


select 'exec Order_InsertUpdate @I_vOrderID = 0, @I_vIncubationDayCnt = 11, @I_vDestinationID = 1, @I_vCustomerReferenceNbr = ''Order Entry'', @I_vPlannedQty = ' + Bldg_59 + ', @I_vDestinationBuildingID = 6, 
@I_vOrderStatusID = 1, @I_vDeliveryDate = ' + '''' + DeliveryDate + '''' + ', @I_vPlannedSetDate = ' + '''' + SetDate + '''' + ', @I_vUserName =' + '''' + 'THESUMMITGRP\mmcgowan' + ''''
from MLA.[dbo].[MapleLawn_2018 Delivery Schedule]
where Bldg_59 <> ''
union all
select 'exec Order_InsertUpdate @I_vOrderID = 0, @I_vIncubationDayCnt = 11, @I_vDestinationID = 1, @I_vCustomerReferenceNbr = ''Order Entry'', @I_vPlannedQty = ' + Bldg_37 + ', @I_vDestinationBuildingID = 7, 
@I_vOrderStatusID = 1, @I_vDeliveryDate = ' + '''' + DeliveryDate + '''' + ', @I_vPlannedSetDate = ' + '''' + SetDate + '''' + ', @I_vUserName =' + '''' + 'THESUMMITGRP\mmcgowan' + ''''
from MLA.[dbo].[MapleLawn_2018 Delivery Schedule]
where Bldg_37 <> ''