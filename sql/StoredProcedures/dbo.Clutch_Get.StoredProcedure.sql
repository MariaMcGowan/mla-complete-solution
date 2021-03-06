USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Clutch_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Clutch_Get]
GO
/****** Object:  StoredProcedure [dbo].[Clutch_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Clutch_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Clutch_Get] AS' 
END
GO


ALTER proc [dbo].[Clutch_Get]
@FlockID int = null
,@ClutchID int = null
,@IncludeNew bit = 0
,@UserName nvarchar(255) = ''
As

select
	ClutchID
	, Clutch
	, FlockID
	, LayDate
	, RackCnt
	, CaseCnt
	, PlannedQty
	, ActualQty
	, CalculatedQty
	, WgtPerDozen
	, ReasoningForPlannedQty
	, SortOrder
	, IsActive
	, @UserName As UserName
from dbo.Clutch
where IsNull(@ClutchID,ClutchID) = ClutchID
and IsNull(@FlockID,FlockID) = FlockID
union all
select
	ClutchID = convert(int,0)
	, Clutch = convert(nvarchar(255),null)
	, FlockID = convert(int,null)
	, LayDate = convert(date,null)
	, RackSpace = convert(decimal(15,10),null)
	, CaseCnt = convert(decimal(15,10),null)
	, PlannedQty = convert(int,null)
	, ActualQty = convert(int,null)
	, CalculatedQty = convert(int,null)
	, WgtPerDozen = convert(decimal(6,3),null)
	, ReasoningForPlannedQty = convert(varchar(1000),null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,null)
,@UserName As UserName
where @IncludeNew = 1



GO
