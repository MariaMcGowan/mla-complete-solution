USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QuantityChangeReason_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QuantityChangeReason_Get]
GO
/****** Object:  StoredProcedure [dbo].[QuantityChangeReason_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuantityChangeReason_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QuantityChangeReason_Get] AS' 
END
GO


ALTER proc [dbo].[QuantityChangeReason_Get]
@QuantityChangeReasonID int = null
,@IncludeNew bit = 1
,@UserName nvarchar(255) = ''
As

select
	QuantityChangeReasonID
	, QuantityChangeReason
	, Notes
	, SortOrder
	, IsActive
	, @UserName As UserName
from dbo.QuantityChangeReason
where IsNull(@QuantityChangeReasonID,QuantityChangeReasonID) = QuantityChangeReasonID
union all
select
	QuantityChangeReasonID = convert(int,0)
	, QuantityChangeReason = convert(varchar(255),null)
	, Notes = convert(varchar(1000),null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,null)
,@UserName As UserName
where @IncludeNew = 1



GO
