USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Cooler_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Cooler_Get]
GO
/****** Object:  StoredProcedure [dbo].[Cooler_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cooler_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cooler_Get] AS' 
END
GO


ALTER proc [dbo].[Cooler_Get]
@CoolerID int = null
,@IncludeNew bit = 1
,@UserName nvarchar(255) = ''
As

select
	CoolerID
	, Cooler
	, CartCapacity
	, Notes
	, SortOrder
	, IsActive
	, @UserName As UserName
from dbo.Cooler
where IsNull(@CoolerID,CoolerID) = CoolerID
union all
select
	CoolerID = convert(int,0)
	, Cooler = convert(varchar(255),null)
	, CartCapacity = convert(int,null)
	, Notes = convert(varchar(1000),null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,null)
,@UserName As UserName
where @IncludeNew = 1



GO
