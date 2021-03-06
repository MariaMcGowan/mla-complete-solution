USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Candling_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Candling_GetList]
GO
/****** Object:  StoredProcedure [dbo].[Candling_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Candling_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Candling_GetList] AS' 
END
GO



ALTER proc [dbo].[Candling_GetList]
AS

Select
	LoadPlanningID
	,DeliveryDate
	,SetDate
	, LotNumbers = 
		STUFF((
				Select  N', ' + LotNbr 
				from [Order] 
				where OrderStatusID <> 5 
				and LoadPlanningID = lp.LoadPlanningID
				order by LotNbr
				FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N'')
from LoadPlanning lp
where exists (select 1 from [Order] where OrderStatusID <> 5 and LoadPlanningID = lp.LoadPlanningID)
order by DeliveryDate desc, SetDate desc


GO
