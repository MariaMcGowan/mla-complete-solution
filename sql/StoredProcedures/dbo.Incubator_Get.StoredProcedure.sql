USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Incubator_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Incubator_Get]
GO
/****** Object:  StoredProcedure [dbo].[Incubator_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Incubator_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Incubator_Get] AS' 
END
GO


ALTER proc [dbo].[Incubator_Get]
@IncubatorID int = null
,@IncludeNew bit = 1
,@UserName nvarchar(255) = ''
As

select
	IncubatorID
	, Incubator
	, CartCapacity
	, Notes
	, SortOrder
	, IsActive
	, @UserName As UserName
	, Column_Count
	, Row_Count
from dbo.Incubator
where IsNull(@IncubatorID,IncubatorID) = IncubatorID
union all
select
	IncubatorID = convert(int,0)
	, Incubator = convert(varchar(255),null)
	, CartCapacity = convert(int,null)
	, Notes = convert(varchar(1000),null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,null)
	, @UserName As UserName
	, Column_Count = convert(int,null)
	, Row_Count = convert(int,null)
where @IncludeNew = 1



GO
