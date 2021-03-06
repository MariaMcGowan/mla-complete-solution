USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubator_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HoldingIncubator_Get]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubator_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldingIncubator_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HoldingIncubator_Get] AS' 
END
GO


ALTER proc [dbo].[HoldingIncubator_Get]
@HoldingIncubatorID int = null
,@IncludeNew bit = 1
,@UserName nvarchar(255) = ''
As

select
	HoldingIncubatorID
	, HoldingIncubator
	, CartCapacity
	, Row_Count
	, Column_Count
	, Notes
	, SortOrder
	, IsActive
	, @UserName As UserName
from dbo.HoldingIncubator
where IsNull(@HoldingIncubatorID,HoldingIncubatorID) = HoldingIncubatorID
union all
select
	HoldingIncubatorID = convert(int,0)
	, HoldingIncubator = convert(varchar(255),null)
	, CartCapacity = convert(int,null)
	, Row_Count = convert(int,null)
	, Column_Count = convert(int,null)
	, Notes = convert(varchar(1000),null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,null)
,@UserName As UserName
where @IncludeNew = 1



GO
