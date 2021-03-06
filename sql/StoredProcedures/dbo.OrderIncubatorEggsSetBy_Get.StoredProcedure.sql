USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubatorEggsSetBy_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderIncubatorEggsSetBy_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubatorEggsSetBy_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubatorEggsSetBy_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderIncubatorEggsSetBy_Get] AS' 
END
GO


ALTER proc [dbo].[OrderIncubatorEggsSetBy_Get]
@OrderIncubatorID int
,@IncludeNew bit = 1
As

select
	OrderIncubatorEggsSetByID
	, OrderIncubatorID
	, ContactID
from OrderIncubatorEggsSetBy
where @OrderIncubatorID = OrderIncubatorID
union all
select
	OrderIncubatorEggsSetByID = convert(int,0)
	, OrderIncubatorID = @OrderIncubatorID
	, ContactID = convert(int,null)
where @IncludeNew = 1



GO
