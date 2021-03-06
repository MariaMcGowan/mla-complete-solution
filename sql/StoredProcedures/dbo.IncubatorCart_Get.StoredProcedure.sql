USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorCart_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorCart_Get]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorCart_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorCart_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorCart_Get] AS' 
END
GO
ALTER proc [dbo].[IncubatorCart_Get]
@IncubatorCartID int = null
,@IncludeNew bit = 1
,@UserName nvarchar(255) = ''
As

select
	IncubatorCartID
	, IncubatorCart
	, ShelfCount
	, EggCapacityPerShelf
	, EggCapacity
	, Notes
	, SortOrder
	, IsActive
	, @UserName As UserName
from dbo.IncubatorCart
where IsNull(@IncubatorCartID,IncubatorCartID) = IncubatorCartID
union all
select
	IncubatorCartID = convert(int,0)
	, IncubatorCart = convert(varchar(255),null)
	, ShelfCount = convert(int,null)
	, EggCapacityPerShelf = convert(int,null)
	, EggCapacity = convert(int,null)
	, Notes = convert(varchar(1000),null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,null)
,@UserName As UserName
where @IncludeNew = 1

GO
