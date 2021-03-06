USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Destination_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Destination_Get]
GO
/****** Object:  StoredProcedure [dbo].[Destination_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Destination_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Destination_Get] AS' 
END
GO


ALTER proc [dbo].[Destination_Get]
@DestinationID int = null
,@IncludeNew bit = 1
,@UserName nvarchar(255) = ''
As

select
	DestinationID
	, Destination
	, PrimaryContactID
	, SecondaryContactID
	, Notes
	, SortOrder
	, IsActive
	, @UserName As UserName
from dbo.Destination
where IsNull(@DestinationID,DestinationID) = DestinationID
union all
select
	DestinationID = convert(int,0)
	, Destination = convert(varchar(255),null)
	, PrimaryContactID = convert(int,null)
	, SecondaryContactID = convert(int,null)
	, Notes = convert(varchar(1000),null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,null)
,@UserName As UserName
where @IncludeNew = 1



GO
