create function GetFlockNumber (@Date date, @FarmID int) returns varchar(20) as
begin

	declare @WeekNumber int 
		, @YearNumber int
		, @FarmNumber varchar(4)

	select @WeekNumber = DATEPART(isowk, @Date)
	select @YearNumber = datepart(year,@Date)

	if datepart(month,@Date) = 1 and @WeekNumber = 53
	begin
		select @YearNumber = @YearNumber - 1
	end
	
	select @FarmNumber = FarmNumber from Farm where FarmID = @FarmID

	return 'M' + @FarmNumber + '-' + right('00' + convert(varchar(2),@WeekNumber),2) + '-' + right(convert(varchar(4),@YearNumber),2)

end