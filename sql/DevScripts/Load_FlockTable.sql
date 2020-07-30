insert into Flock(Flock, FarmID, HatchDate, Date_24Weeks, Date_65Weeks, Date_Deactivate, SortOrder, IsActive)
select FlockName, FarmID, HatchDate, Date_24Week, Date_65Week, 
Date_Deactivate = 
case
	when Date_Deactivate <> 'N/A' then Date_Deactivate
end, fl.SortOrder, 
IsActive = 
case
	when fl.IsActive = 'TRUE' then 1
	else 0
end
from Flock_Template fl
inner join Farm f on substring(fl.FlockName, 2, 3) = f.FarmNumber



select *
from Flock