USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorLoad_GetList]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_GetList]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorLoad_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorLoad_GetList] AS' 
END
GO
ALTER proc [dbo].[IncubatorLoad_GetList]
--@DeliveryDate date = null
@LoadPlanningID int = null
,@UserName nvarchar(255) = ''
AS

Select
	lp.LoadPlanningID
	,lp.DeliveryDate
	,lp.SetDate
	, STUFF((    SELECT ',' + LotNbr
            FROM [Order] 
            WHERE OrderStatusID <> 5 and LoadPlanningID = lp.LoadPlanningID
            FOR XML PATH('')
            ), 1, 1, '' )
        AS LotNumbers
	,lp.TargetQty
	,o1.LotNbr as LotNbr1
	,o2.LotNbr as LotNbr2
	,o3.LotNbr as LotNbr3
	,o4.LotNbr as LotNbr4
	,o5.LotNbr as LotNbr5
	,o6.LotNbr as LotNbr6
	,o7.LotNbr as LotNbr7
	,o8.LotNbr as LotNbr8
	,IsNull(oi1.OrderIncubatorID,0) as OrderIncubatorID1
	,IsNull(oi2.OrderIncubatorID,0) as OrderIncubatorID2
	,IsNull(oi3.OrderIncubatorID,0) as OrderIncubatorID3
	,IsNull(oi4.OrderIncubatorID,0) as OrderIncubatorID4
	,IsNull(oi5.OrderIncubatorID,0) as OrderIncubatorID5
	,IsNull(oi6.OrderIncubatorID,0) as OrderIncubatorID6
	,IsNull(oi7.OrderIncubatorID,0) as OrderIncubatorID7
	,IsNull(oi8.OrderIncubatorID,0) as OrderIncubatorID8
	,i1.Incubator as Incubator1
	,i2.Incubator as Incubator2
	,i3.Incubator as Incubator3
	,i4.Incubator as Incubator4
	,i5.Incubator as Incubator5
	,i6.Incubator as Incubator6
	,i7.Incubator as Incubator7
	,i8.Incubator as Incubator8
from LoadPlanning lp

	left outer join OrderIncubator oi1 on oi1.OrderIncubatorID = lp.OrderIncubatorID1
	left outer join [Order] o1 on oi1.OrderID = o1.OrderID
	left outer join Incubator i1 on oi1.IncubatorID = i1.IncubatorID

	left outer join OrderIncubator oi2 on oi2.OrderIncubatorID = lp.OrderIncubatorID2
	left outer join [Order] o2 on oi2.OrderID = o2.OrderID
	left outer join Incubator i2 on oi2.IncubatorID = i2.IncubatorID

	left outer join OrderIncubator oi3 on oi3.OrderIncubatorID = lp.OrderIncubatorID3
	left outer join [Order] o3 on oi3.OrderID = o3.OrderID
	left outer join Incubator i3 on oi3.IncubatorID = i3.IncubatorID

	left outer join OrderIncubator oi4 on oi4.OrderIncubatorID = lp.OrderIncubatorID4
	left outer join [Order] o4 on oi4.OrderID = o4.OrderID
	left outer join Incubator i4 on oi4.IncubatorID = i4.IncubatorID

	left outer join OrderIncubator oi5 on oi5.OrderIncubatorID = lp.OrderIncubatorID5
	left outer join [Order] o5 on oi5.OrderID = o5.OrderID
	left outer join Incubator i5 on oi5.IncubatorID = i5.IncubatorID

	left outer join OrderIncubator oi6 on oi6.OrderIncubatorID = lp.OrderIncubatorID6
	left outer join [Order] o6 on oi6.OrderID = o6.OrderID
	left outer join Incubator i6 on oi6.IncubatorID = i6.IncubatorID

	left outer join OrderIncubator oi7 on oi7.OrderIncubatorID = lp.OrderIncubatorID7
	left outer join [Order] o7 on oi7.OrderID = o7.OrderID
	left outer join Incubator i7 on oi7.IncubatorID = i7.IncubatorID

	left outer join OrderIncubator oi8 on oi8.OrderIncubatorID = lp.OrderIncubatorID8
	left outer join [Order] o8 on oi8.OrderID = o8.OrderID
	left outer join Incubator i8 on oi8.IncubatorID = i8.IncubatorID

where lp.LoadPlanningID = isnull(@LoadPlanningID, lp.LoadPlanningID)
order by lp.DeliveryDate desc, lp.SetDate desc
GO
