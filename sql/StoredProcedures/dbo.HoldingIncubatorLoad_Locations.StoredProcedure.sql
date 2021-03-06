USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_Locations]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HoldingIncubatorLoad_Locations]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_Locations]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldingIncubatorLoad_Locations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HoldingIncubatorLoad_Locations] AS' 
END
GO


ALTER proc [dbo].[HoldingIncubatorLoad_Locations] @DeliveryID int
AS
--declare @DeliveryID int = 956

declare 
	@HoldingIncubatorID int
	, @Row_Count int
	, @Column_Count int
	, @FanRow int
	, @CartCapacity int
	, @BlankCount int = 0
	, @LocationOffset int
	, @RowCounter int 
	, @ColumnCounter int
	, @LocationNumber int
	, @Column1 int
	, @Column2 int
	, @IncubatorID int
	, @OrderID int
	, @Row int
	, @Column int
	, @EvenOdd int
	, @nRow int
	, @nCol int
	, @X int
	, @DoorColumn int

select top 1 @HoldingIncubatorID = hi.HoldingIncubatorID
from Delivery d
inner join HoldingIncubator hi on d.HoldingIncubatorID = hi.HoldingIncubatorID
inner join OrderDelivery od on d.DeliveryID = od.DeliveryID
inner join [Order] o on od.OrderID = o.OrderID
where d.DeliveryID = @DeliveryID

select 
	@Row_Count = row_count,
	@Column_Count = column_count,
	@CartCapacity = CartCapacity
from HoldingIncubator where HoldingIncubatorID = @HoldingIncubatorID

select @FanRow = floor(@Row_Count / 2) + 1

declare @BlankLocations table (ColumnNbr int, RowNbr int, FromTop int, FromBottom int, SortOrder int)


select @RowCounter = @Row_Count + 1
	,@ColumnCounter = @Column_Count + 1
	, @LocationNumber = 0
	, @DoorColumn = @Column_Count + 1

-- Are there any blank locations
if @Row_Count * @Column_Count <> @CartCapacity
begin

	select @nCol = 0
	while @nCol < @Column_Count
	begin
		select @nCol = @nCol + 1
		select @nRow = 0
		while @nRow < @RowCounter
		begin
			select @nRow = @nRow + 1

			if @nRow <> @FanRow
			begin
				insert into @BlankLocations(ColumnNbr, RowNbr, FromTop, FromBottom)
				select @nCol, @nRow, @nRow - 1, @RowCounter - @nRow
			end
		end
	end

	update @BlankLocations set  SortOrder = (iif(FromTop < FromBottom, FromTop, FromBottom) + 1) --* (@ColumnCounter - ColumnNbr + 1) * 10

	update b set b.SortOrder = ns.NewSortOrder
	from @BlankLocations b
	inner join 
	(
		select NewSortOrder =ROW_NUMBER () Over (Order by ColumnNbr desc, SortOrder, FromTop), ColumnNbr, RowNbr
		from @BlankLocations
	) ns
	on b.RowNbr = ns.RowNbr and b.ColumnNbr = ns.ColumnNbr

	delete from @BlankLocations where SortOrder > ((@Row_Count * @Column_Count) - @CartCapacity)
end


declare @LocationCoordinates table (RowNumber int, ColumnNumber int, LocationNumber int)

-- The highest column is the right most column
-- The row number starts on the right most column
-- On odd columns, the row number is lowest to highest from top to bottom
-- On even columns, the row number is highest to lowest from top to bottom
-- If there are blank locations, evenly spread them in the first column

	/*
					Column 1		Column 2		Column 3		Column 4		Column 5
row 1		|		23		|		22		|		11		|		10		|		{blank}		|
row 2		|		24		|		21		|		12		|		9		|			1		|
row 3		|		25		|		20		|		13		|		8		|			2		|
row 4		|		Fans	|		Fans	|		Fans	|		Fans	|		Fans		|
row 5		|		26		|		19		|		14		|		7		|			3		|
row 5		|		27		|		18		|		15		|		6		|			4		|
row 6		|		28		|		17		|		16		|		5		|		{blank}		|

	*/


select @Column = @ColumnCounter
select @EvenOdd = @Column % 2


while @Column >= 1
begin
	if @Column % 2 = @EvenOdd -- Odd
	begin
		select @Row = 0
		while @Row < @RowCounter
		begin
			select @Row = @Row + 1
			-- Is it anything weird, like a fan, a door, or a blank
			if @Column = @DoorColumn and @Row = @FanRow
			begin	-- Its a door and a fan; 
				insert into @LocationCoordinates (RowNumber, ColumnNumber, LocationNumber)
				select @Row, @Column, -3				
			end
			else if @Column = @DoorColumn
			begin	-- Its a door
				insert into @LocationCoordinates (RowNumber, ColumnNumber, LocationNumber)
				select @Row, @Column, -2
			end
			else if @Row = @FanRow 
			begin	-- Its a fan
				insert into @LocationCoordinates (RowNumber, ColumnNumber, LocationNumber)
				select @Row, @Column, -1
			end
			else if exists (select 1 from @BlankLocations where RowNbr = @Row and ColumnNbr = @Column)
			begin	-- Its a blank
				insert into @LocationCoordinates (RowNumber, ColumnNumber, LocationNumber)
				select @Row, @Column, 0
			end
			else
			begin	-- Nope, its a normal location
				select @LocationNumber = @LocationNumber + 1
				insert into @LocationCoordinates (RowNumber, ColumnNumber, LocationNumber)
				select @Row, @Column, @LocationNumber
			end
		end
	end
	else
	begin
		select @Row = @RowCounter
		while @Row >= 1
		begin
			-- Is it anything weird, like a fan, a door, or a blank
			if @Column = @DoorColumn and @Row = @FanRow
			begin	-- Its a door and a fan; 
				insert into @LocationCoordinates (RowNumber, ColumnNumber, LocationNumber)
				select @Row, @Column, -3				
			end
			else if @Column = @DoorColumn
			begin	-- Its a door
				insert into @LocationCoordinates (RowNumber, ColumnNumber, LocationNumber)
				select @Row, @Column, -2
			end
			else if @Row = @FanRow 
			begin	-- Its a fan
				insert into @LocationCoordinates (RowNumber, ColumnNumber, LocationNumber)
				select @Row, @Column, -1
			end
			else if exists (select 1 from @BlankLocations where RowNbr = @Row and ColumnNbr = @Column)
			begin	-- Its a blank
				insert into @LocationCoordinates (RowNumber, ColumnNumber, LocationNumber)
				select @Row, @Column, 0
			end
			else
			begin	-- Its a normal location
				select @LocationNumber = @LocationNumber + 1
				insert into @LocationCoordinates (RowNumber, ColumnNumber, LocationNumber)
				select @Row, @Column, @LocationNumber
			end
			select @Row = @Row - 1
		end
	end
	
	select @Column= @Column - 1
end

select SortOrder =ROW_NUMBER () Over (Order by RowNumber, ColumnNumber), LocationNumber, 
RowNumber, ColumnNumber, 
className = 
case
	when LocationNumber = 0 then ' holdingIncubatorColumnEmpty'
	when LocationNumber = -1 then ' holdingIncubatorColumnEmpty holdingIncubatorRowFans'
	when LocationNumber = -2 then ' holdingIncubatorLoadDoors'
	when LocationNumber = -3 then ' holdingIncubatorColumnEmpty'
	else 'holdingIncubatorColumn_' + right('00' + convert(varchar, @column_count),2)
end, 
displayOverride = 
case
	when LocationNumber = -1 then 'FANS'
	else ''
end
--,
--DoorColumnCount = @ColumnSetCounter 
from @LocationCoordinates
order by RowNumber, ColumnNumber





GO
