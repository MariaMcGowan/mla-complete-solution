USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Clutch_LookupForOrder]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Clutch_LookupForOrder]
GO
/****** Object:  StoredProcedure [dbo].[Clutch_LookupForOrder]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Clutch_LookupForOrder]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Clutch_LookupForOrder] AS' 
END
GO


ALTER proc [dbo].[Clutch_LookupForOrder] 
	@OrderID int = null
	,@IncludeBlank bit = 1
	,@IncludeAll bit = 0
As

select @OrderID = nullif(@OrderID, '')
select @OrderID = isnull(@OrderID, 0)

create table #Data (Clutch varchar(100), ClutchID int, SortOrder int)

insert into #Data (Clutch, ClutchID, SortOrder)
select rtrim(f.Flock) + ' ' + convert(varchar,LayDate,101),ClutchID, 10
from dbo.Clutch c
inner join Flock f on c.FlockID = f.FlockID
where c.IsActive = 1
union all
select '','', 0
where @IncludeBlank = 1
union all
select 'All','', 0
where @IncludeAll = 1

update #Data set SortOrder = 1 where exists 
(
	select 1 
	from OrderFlock ofl 
	inner join OrderFlockClutch ofcl on ofl.OrderID = @OrderID and ofl.OrderFlockID = Ofcl.OrderFlockID
	where ClutchID = #Data.ClutchID
)


select Clutch, ClutchID
from #Data
Order by SortOrder, Clutch



GO
