USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_CoolerClutch]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorLoad_CoolerClutch]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_CoolerClutch]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorLoad_CoolerClutch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorLoad_CoolerClutch] AS' 
END
GO



ALTER proc [dbo].[IncubatorLoad_CoolerClutch]
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

declare @flockTotals table (FlockID int, ClutchID int, IncubatorQty int, CoolerQty int)
insert into @flockTotals (FlockID, ClutchID)
select lpd.FlockID, c.ClutchID
from LoadPLanning_Detail lpd
	inner join Clutch c on lpd.FlockID = c.FlockID
where LoadPlanningID = @LoadPlanningID
and FlockQty > 0

update ft
	set ft.IncubatorQty = IsNull((
		select
			SUM(IsNull(oic.ActualQty,0)) IncubatorSum
		from OrderIncubatorCart oic
			inner join Clutch c on oic.ClutchID = c.ClutchID
			inner join OrderIncubator oi on oic.OrderIncubatorID = oi.OrderIncubatorID
			inner join [Order] o on oi.OrderID = o.OrderID
		where o.DeliveryDate = @DeliveryDate
			and c.ClutchID = ft.ClutchID
		group by c.ClutchID
	),0)
	,ft.CoolerQty = IsNull((
		select
			sum(cc.ActualQty)
		from CoolerClutch cc
		inner join Clutch c on cc.ClutchID = c.ClutchID
		where c.ClutchID = ft.ClutchID
	),0)
from @flockTotals ft

select
c.FlockID
,f.SortOrder
,c.LayDate
,c.ClutchID
,ft.IncubatorQty
,Round(dbo.ConvertEggsToIncubatorCarts(ft.IncubatorQty),0,1) as IncubatorQtyRacks
,Round(dbo.ConvertEggsToIncubatorCartColumns(ft.IncubatorQty - 
		dbo.ConvertIncubatorCartsToEggs(
			Round(dbo.ConvertEggsToIncubatorCarts(ft.IncubatorQty),0,1)
			)
		),0,1) as IncubatorQtyColumns
,dbo.ConvertEggsToShelves(ft.IncubatorQty -
	dbo.ConvertIncubatorCartColumnsToEggs(
		Round(dbo.ConvertEggsToIncubatorCartColumns(ft.IncubatorQty),0,1)
		)) as IncubatorQtyShelves
,ft.IncubatorQty -
	dbo.ConvertShelvesToEggs(
		Round(dbo.ConvertEggsToShelves(ft.IncubatorQty),0,1)
		) as IncubatorQtyEggs

,ft.CoolerQty
,Round(dbo.ConvertEggsToIncubatorCarts(ft.CoolerQty),0,1) as CoolerQtyRacks
,Round(dbo.ConvertEggsToIncubatorCartColumns(ft.CoolerQty - 
		dbo.ConvertIncubatorCartsToEggs(
			Round(dbo.ConvertEggsToIncubatorCarts(ft.CoolerQty),0,1)
			)
		),0,1) as CoolerQtyColumns
,dbo.ConvertEggsToShelves(ft.CoolerQty -
	dbo.ConvertIncubatorCartColumnsToEggs(
		Round(dbo.ConvertEggsToIncubatorCartColumns(ft.CoolerQty),0,1)
		)) as CoolerQtyShelves
,ft.CoolerQty -
	dbo.ConvertShelvesToEggs(
		Round(dbo.ConvertEggsToShelves(ft.CoolerQty),0,1)
		) as CoolerQtyEggs

from @flockTotals ft
inner join Clutch c on ft.ClutchID = c.ClutchID
inner join Flock f on c.FlockID = f.FlockID
where ft.IncubatorQty > 0 or ft.CoolerQty > 0
order by f.SortOrder, f.Flock, c.LayDate

--IncubatorLoad_CoolerClutch 2



GO
