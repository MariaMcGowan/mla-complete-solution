USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CoolerClutch_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CoolerClutch_GetList]
GO
/****** Object:  StoredProcedure [dbo].[CoolerClutch_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoolerClutch_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CoolerClutch_GetList] AS' 
END
GO



ALTER proc [dbo].[CoolerClutch_GetList]
--declare
@CoolerID int
,@FlockID int = null
,@LayDate date = null
,@HistoricalLayDates bit = 0
,@UserName varchar(100) = ''
,@IncludeNew bit = 0
As

--select @CoolerID='6', @HistoricalLayDates='1', @FlockID='0', @LayDate='', @IncludeNew = 0, @UserName = 'THESUMMITGRP\mmcgowan'

select @FlockID = nullif(nullif(@FlockID, ''), 0)

select @LayDate =nullif(@LayDate, '')
	
declare @flocks table (FlockID int, isOdd bit, SortOrder int)
insert into @flocks
select distinct f.FlockID, null, f.SortOrder
from CoolerClutch cc
inner join Clutch c on cc.ClutchID = c.ClutchID
inner join Flock f on c.FlockID = f.FlockID
where @CoolerID = cc.CoolerID and (@HistoricalLayDates = 1 or cc.ActualQty > 0)
and f.FlockID = isnull(@FlockID, f.FlockID) 
and c.LayDate = isnull(@LayDate, c.LayDate)
order by f.SortOrder

declare @FlockCount int

select @FlockCount = count(*) from @flocks

if @FlockCount = 0
	select @IncludeNew = 1

declare @currentID int, @isOdd bit = 1
while exists (select 1 from @flocks where isOdd is null)
begin
	select top 1 @currentID = FlockID from @flocks where isOdd is null order by SortOrder
	update @flocks set isOdd = @isOdd where FlockID = @currentID
	select @isOdd = case when @isOdd = 1 then 0 else 1 end
end

if @IncludeNew = 0
begin
	select
		CoolerClutchID
		, CoolerID
		, cc.ClutchID
		, c.FlockID
		, f.Flock
		, c.LayDate
		, ReceivedDate = convert(date,null)
		, cc.InitialQty
		, dbo.ConvertEggsToIncubatorCarts(cc.InitialQty) As InitialQtyCarts
		, cc.ActualQty
		, dbo.ConvertEggsToIncubatorCarts(cc.ActualQty) As ActualQtyCarts
		, case when fl.isOdd = 1 then 'background100' else 'background200' end as className
	from CoolerClutch cc
		inner join Clutch c on cc.ClutchID = c.ClutchID
		inner join Flock f on c.FlockID = f.FlockID
		left outer join @flocks fl on f.FlockID = fl.FlockID
	where @CoolerID = cc.CoolerID and (@HistoricalLayDates = 1 or cc.ActualQty > 0)
	and f.FlockID = isnull(@FlockID, f.FlockID) 
	and c.LayDate = isnull(@LayDate, c.LayDate)
	order by f.SortOrder, c.LayDate
end
else
begin
	select
		CoolerClutchID = convert(int,0)
		, CoolerID = @CoolerID
		, ClutchID = convert(int,null)
		, FlockID = convert(int,null)
		, Flock = convert(varchar(20), null)
		, LayDate = convert(date,null)
		, ReceivedDate = convert(date,getdate())
		, InitialQty = convert(int,null)
		, InitialQtyCarts = convert(numeric(19,5),0)
		, ActualQty = convert(int,null)
		, ActualQtyCarts = convert(numeric(19,5),0)
	where @IncludeNew = 1 and @CoolerID > 0
end


GO
