USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Flock_Lookup_byDeliveryID]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Flock_Lookup_byDeliveryID]
GO
/****** Object:  StoredProcedure [dbo].[Flock_Lookup_byDeliveryID]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Flock_Lookup_byDeliveryID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Flock_Lookup_byDeliveryID] AS' 
END
GO



ALTER proc [dbo].[Flock_Lookup_byDeliveryID] 
	@DeliveryID int
As

select '' as Flock, null as FlockID, DeliveryID = @DeliveryID
union all
select Flock, f.FlockID, od.DeliveryID
from [Order] o
inner join OrderDelivery od on o.OrderID = od.OrderID
--inner join LoadPlanning lp on o.DeliveryDate = lp.DeliveryDate
inner join LoadPlanning lp on o.LoadPlanningID = lp.LoadPlanningID
inner join LoadPLanning_Detail lpd on lp.LoadPlanningID = lpd.LoadPlanningID
inner join Flock f on lpd.FlockID = f.FlockID
where lpd.FlockQty > 0 and od.DeliveryID = @DeliveryID
group by Flock, f.FlockID, od.DeliveryID
order by DeliveryID, Flock



GO
