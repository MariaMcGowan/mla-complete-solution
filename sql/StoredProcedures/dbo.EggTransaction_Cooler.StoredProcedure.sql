USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_Cooler]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_Cooler]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_Cooler]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_Cooler]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_Cooler] AS' 
END
GO


ALTER proc [dbo].[EggTransaction_Cooler] @CoolerClutchID int
As

declare @Flock varchar(100)
declare @LayDate date
declare @ClutchID int

select @ClutchID = ClutchID from CoolerClutch where CoolerClutchID = @CoolerClutchID

select @Flock = Flock, @LayDate = LayDate
from Flock fl
inner join Clutch cl on fl.FlockID = cl.FlockID
where ClutchID = @ClutchID

select EggTransactionID = convert(int, 0), 
ClutchID = @ClutchID, 
Flock = @Flock,
LayDate = @LayDate,
QtyChange = convert(int,0), 
QtyChangeIncubatorCart = convert(int,0), 
QtyChangeCase = convert(int,0), 
QtyChangeReasonID = convert(int,0), 
QtyChangeActualDate = convert(date, getdate()), 
QtyChangeRecordedDate = convert(date, getdate()),
CoolerClutchID = @CoolerClutchID



GO
