create function GetWeekNumber_ForFlock (@Date date)
returns int
as
begin
	return DATEPART(isowk, @Date)
end