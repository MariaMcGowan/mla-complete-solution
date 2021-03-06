USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Flock_LookupForIncubatorLoad]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Flock_LookupForIncubatorLoad]
GO
/****** Object:  StoredProcedure [dbo].[Flock_LookupForIncubatorLoad]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Flock_LookupForIncubatorLoad]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Flock_LookupForIncubatorLoad] AS' 
END
GO


ALTER proc [dbo].[Flock_LookupForIncubatorLoad]
	@OrderIncubatorID int
As

select distinct f.Flock, lpd.FlockID, f.SortOrder
from LoadPlanning lp
inner join LoadPlanning_Detail lpd on lp.LoadPLanningID = lpd.LoadPlanningID
inner join Flock f on lpd.FlockID = f.FlockID
where @OrderIncubatorID in (OrderIncubatorID1, OrderIncubatorID2, OrderIncubatorID3, OrderIncubatorID4,
							OrderIncubatorID5,  OrderIncubatorID6, OrderIncubatorID7, OrderIncubatorID8)
		and lpd.FlockQty > 0
order by f.SortOrder



GO
