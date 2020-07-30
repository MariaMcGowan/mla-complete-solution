select *
from Destination

SET IDENTITY_INSERT dbo.Destination ON;  
insert into Destination (DestinationID, Destination, SortOrder, IsActive)
select 1, 'Sanofi', 1, 1
SET IDENTITY_INSERT dbo.Destination OFF;  