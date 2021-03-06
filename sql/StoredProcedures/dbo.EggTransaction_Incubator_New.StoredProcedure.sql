USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_Incubator_New]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_Incubator_New]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_Incubator_New]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_Incubator_New]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_Incubator_New] AS' 
END
GO


ALTER proc [dbo].[EggTransaction_Incubator_New] @OrderIncubatorCartID int, @UserName varchar(100)
As

select 
OrderIncubatorCartID = OrderIncubatorCartID,
ic.IncubatorLocationNumber, 
FlockID = FlockID,
LayDate = LayDate,
QtyChange = convert(int,0), 
QtyChangeIncubatorCart = convert(int,0), 
QtyChangeCase = convert(int,0), 
QtyChangeReasonID = convert(int,0), 
QtyChangeActualDate = convert(date, getdate()), 
QtyChangeRecordedDate = convert(date, getdate()),
@UserName as UserName
from OrderIncubatorCart oic 
inner join IncubatorCart ic on oic.IncubatorCartID = ic.IncubatorCartID
inner join Clutch c on oic.ClutchID = c.ClutchID
where oic.OrderIncubatorCartID = @OrderIncubatorCartID



GO
