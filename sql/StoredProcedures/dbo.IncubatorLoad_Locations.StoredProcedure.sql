USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_Locations]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorLoad_Locations]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_Locations]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorLoad_Locations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorLoad_Locations] AS' 
END
GO


ALTER proc [dbo].[IncubatorLoad_Locations] 
	@OrderIncubatorID int
	,@IncubatorNumber int
	,@UserName nvarchar(255) = ''
as

declare 
	@Row_Count int
	, @Column_Count int
	, @FanColumn int
	, @LocationOffset int
	, @RowCounter int 
	, @ColumnSetCounter int
	, @LocationNumber int
	, @Column1 int
	, @Column2 int
	, @IncubatorID int
	, @OrderID int

select @IncubatorID = IncubatorID, @OrderID = OrderID from OrderIncubator where OrderIncubatorID = @OrderIncubatorID

select @Row_Count = row_count, @Column_Count = column_count from Incubator where IncubatorID = @IncubatorID

select @RowCounter = @Row_Count
	, @ColumnSetCounter = floor (@Column_Count / 2)
	, @Column1 = @ColumnSetCounter
	, @Column2 = @ColumnSetCounter + 2
	, @LocationOffset = (@Row_Count * @Column_Count) * (@IncubatorNumber - 1)

select @LocationNumber = 1 + @LocationOffset

declare @LocationCoordinates table (RowNumber int, ColumnNumber int, LocationNumber int)

while @RowCounter > 0
begin
	while @ColumnSetCounter > 0
	begin
		
		
		insert into @LocationCoordinates (RowNumber, ColumnNumber, LocationNumber)
		select @RowCounter, @Column1, @LocationNumber
		union all
		select @RowCounter, @Column2, @LocationNumber + 1

		select @LocationNumber = @LocationNumber + 2
		select @ColumnSetCounter = @ColumnSetCounter - 1
		select @Column1 = @Column1 - 1
		select @Column2 = @Column2 + 1
	end

	-- Insert the Fan Column for the row
	insert into @LocationCoordinates (RowNumber, ColumnNumber, LocationNumber)
	select @RowCounter, floor (@Column_Count / 2) + 1, -1


	select @RowCounter = @RowCounter - 1
	select @ColumnSetCounter = floor (@Column_Count / 2)
	select @Column1 = @ColumnSetCounter
	select @Column2 = @ColumnSetCounter + 2
end


select SortOrder =ROW_NUMBER () Over (Order by RowNumber, ColumnNumber), LocationNumber, 
RowNumber, --ColumnNumber, 
className = 
case
	when LocationNumber = -1 then ' incubatorColumnEmpty incubatorColumnFans'
	else 'incubatorColumn_' + right('00' + convert(varchar, @column_count),2)
end, 
displayOverride = 
case
	when LocationNumber = -1 then 'FANS'
	else ''
end,
DoorColumnCount = @ColumnSetCounter 
from @LocationCoordinates
order by RowNumber, ColumnNumber




GO
