insert into DestinationBuilding (DestinationBuilding, DestinationID, SortOrder, IsActive, Address1, Address2, City, State, Zip)
select DestinationBuildingNbr, 1, SortOrder, IsActive, Address1, Address2, City, State, Zip
from [dbo].[DeliveryBuilding_Template]