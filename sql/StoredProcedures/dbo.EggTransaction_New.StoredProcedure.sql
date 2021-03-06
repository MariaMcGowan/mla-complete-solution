USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_New]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_New]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_New]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_New]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_New] AS' 
END
GO


ALTER proc [dbo].[EggTransaction_New]  @CoolerClutchID int = null
As

select EggTransactionID = convert(int, 0), 
ClutchID = convert(int, null), 
FlockID = convert(int, null), 
LayDate = convert(date, null), 
QtyChange = convert(int,0), 
QtyChangeIncubatorCart = convert(int,0), 
QtyChangeCase = convert(int,0), 
QtyChangeReasonID = convert(int,0), 
QtyChangeActualDate = convert(date, getdate()), 
QtyChangeRecordedDate = convert(date, getdate()),
CoolerClutchID = @CoolerClutchID,
Flock = 
	(
		select fl.Flock
		from CoolerClutch cc
		left outer join Clutch cl on cc.ClutchID = cl.ClutchID
		left outer join Flock fl on cl.FlockID = fl.FlockID
		where CoolerCLutchID = @CoolerClutchID
	),
LayDate = 
	(
		select LayDate
		from CoolerClutch cc
		left outer join Clutch cl on cc.ClutchID = cl.ClutchID
		where CoolerCLutchID = @CoolerClutchID
	)





GO
