insert into Farm (Farm, --PrimaryContactID, SecondaryContactID, 
Address1, Address2, City, State, Zip, 
SortOrder, IsActive, FarmNumber, MLA_MainProperty, MLA_ContractFarm, BirdsOwnedBy)
select FarmName, 
--PrimaryContact , SecondaryContact, 
Address1, Address2, City, State, Zip, 
SortOrder, 
IsActive = 
case
	when IsActive = 'TRUE' then 1
	else 0
end, 
FarmNumber, 
MLA_MainProperty = 
case
	when MLA_MainProperty = 'TRUE' then 1
	else 20
end, 
case
	when Contract_MLAOwnsBirds = 'TRUE' or [Contract] = 'TRUE' then 1
	else 0
end, 
BirdsOwnedBy
from Farm_Template