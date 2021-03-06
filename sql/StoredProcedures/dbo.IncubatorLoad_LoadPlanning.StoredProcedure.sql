USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_LoadPlanning]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorLoad_LoadPlanning]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_LoadPlanning]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorLoad_LoadPlanning]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorLoad_LoadPlanning] AS' 
END
GO



ALTER proc [dbo].[IncubatorLoad_LoadPlanning]
@OrderIncubatorID int
AS

declare @LoadPlanningID int
select @LoadPlanningID = LoadPlanningID
from LoadPlanning
where @OrderIncubatorID in (OrderIncubatorID1, OrderIncubatorID2, OrderIncubatorID3, OrderIncubatorID4,
							OrderIncubatorID5,  OrderIncubatorID6, OrderIncubatorID7, OrderIncubatorID8)


declare @DeliveryDate date
select @DeliveryDate = DeliveryDate
from LoadPlanning where LoadPlanningID = @LoadPlanningID

declare @flockTotals table (FlockID int, IncubatorQty int, LoadPlanQty int)
insert into @flockTotals (FlockID, LoadPlanQty)
select FlockID, FlockQty
from LoadPLanning_Detail 
where LoadPlanningID = @LoadPlanningID
and FlockQty > 0

update ft
	set ft.IncubatorQty = incubatorSum
from @flockTotals ft
inner join (
	select
	c.FlockID
	,SUM(IsNull(oic.ActualQty,0)) IncubatorSum
	from OrderIncubatorCart oic
	inner join Clutch c on oic.ClutchID = c.ClutchID
	inner join OrderIncubator oi on oic.OrderIncubatorID = oi.OrderIncubatorID
	inner join [Order] o on oi.OrderID = o.OrderID
	where o.DeliveryDate = @DeliveryDate
	group by FlockID
	) sumTable on sumTable.FlockID = ft.FlockID

select 
fpd.FlockID
,f.Flock
,fpd.FlockQty as LoadPlanQty
,Round(dbo.ConvertEggsToIncubatorCarts(fpd.FlockQty),0,1) as LoadPlanQtyRacks
,Round(dbo.ConvertEggsToIncubatorCartColumns(fpd.FlockQty - 
		dbo.ConvertIncubatorCartsToEggs(
			Round(dbo.ConvertEggsToIncubatorCarts(fpd.FlockQty),0,1)
			)
		),0,1) as LoadPlanQtyColumns
,dbo.ConvertEggsToShelves(fpd.FlockQty -
	dbo.ConvertIncubatorCartColumnsToEggs(
		Round(dbo.ConvertEggsToIncubatorCartColumns(fpd.FlockQty),0,1)
		)) as LoadPlanQtyShelves
,fpd.FlockQty -
	dbo.ConvertShelvesToEggs(
		Round(dbo.ConvertEggsToShelves(fpd.FlockQty),0,1)
		) as LoadPlanQtyEggs
, FontColor = 
	case
		when ft.IncubatorQty = LoadPlanQty then ''
		else 'redFont'
	end
from LoadPLanning_Detail fpd
inner join Flock f on fpd.FlockID = f.FlockID
inner join @flockTotals ft on fpd.FlockID = ft.FlockID
where LoadPlanningID = @LoadPlanningID
and FlockQty > 0
order by f.SortOrder, f.Flock

-- exec  IncubatorLoad_LoadPlanning 2



GO
