USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_GetList]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_GetList] AS' 
END
GO


ALTER proc [dbo].[EggTransaction_GetList]
@ClutchID int
,@IncludeNew bit = 1
As

select EggTransactionID, ClutchID, QtyChange, QtyChangeReasonID, QtyChangeActualDate, QtyChangeRecordedDate
from EggTransaction
where ClutchID = @ClutchID
union all
select EggTransactionID = convert(int, 0), 
ClutchID = @ClutchID, 
QtyChange = convert(int,0), 
QtyChangeReasonID = convert(int,0), 
QtyChangeActualDate = convert(date, getdate()), 
QtyChangeRecordedDate = convert(date, getdate())
where @IncludeNew = 1



GO
