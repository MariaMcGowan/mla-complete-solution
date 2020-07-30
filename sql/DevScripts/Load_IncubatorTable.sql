insert into [dbo].[Incubator] (Incubator, CartCapacity, Notes, SortOrder, IsActive)
select Incubator, CartCapacity, Notes, SortOrder, 1
from [dbo].[Incubator_Template]