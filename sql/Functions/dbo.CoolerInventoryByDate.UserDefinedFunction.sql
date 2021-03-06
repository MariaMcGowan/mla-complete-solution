USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[CoolerInventoryByDate]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[CoolerInventoryByDate]
GO
/****** Object:  UserDefinedFunction [dbo].[CoolerInventoryByDate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoolerInventoryByDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create FUNCTION [dbo].[CoolerInventoryByDate] (@StartDate date, @EndDate date)
--alter FUNCTION CoolerInventoryByDate (@EndDate date)
RETURNS 
@CoolerInventory TABLE 
(
	-- Add the column definitions for the TABLE variable here
	Date Date, 
	EggCount int
)
AS
BEGIN
	declare @StartDateTime datetime,
		@EndDateTime datetime

	select @StartDateTime = convert(datetime, @StartDate),
		@EndDateTime = dateadd(second, -1, convert(datetime, dateadd(day, 1, @EndDate)))


	declare @LastTransactionOfDay table (ClutchID int index idxClutchID, Date date, LastChange datetime index idxLastChange)

	insert into @LastTransactionOfDay (ClutchID, Date, LastChange)
	select ClutchID, Date = Convert(date, QtyChangeActualDate), max(QtyChangeActualDate) as LastChange
	from EggTransaction
	where ClutchID is not null and QtyChangeActualDate between @StartDateTime and @EndDateTime
	--where ClutchID is not null and QtyChangeActualDate <= @EndDateTime
	group by ClutchID, Convert(date, QtyChangeActualDate)


	insert into @CoolerInventory (Date, EggCount)				
	select Date = convert(date, QtyChangeActualDate), sum(ClutchQtyAfterTransaction)
	from EggTransaction e
	inner join @LastTransactionOfDay l on e.ClutchID = l.ClutchID and e.QtyChangeActualDate = l.LastChange
	group by convert(date, QtyChangeActualDate)
	order by 1 desc

	RETURN 

END
' 
END

GO
