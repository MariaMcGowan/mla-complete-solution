USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_HoldingIncubator_New]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_HoldingIncubator_New]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_HoldingIncubator_New]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_HoldingIncubator_New]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_HoldingIncubator_New] AS' 
END
GO


ALTER proc [dbo].[EggTransaction_HoldingIncubator_New] @DeliveryCartFlockID int, @UserName varchar(100)
As

select 
DeliveryCartID = dc.DeliveryCartID,
DeliveryCartFlockID,
IncubatorLocationNumber, 
FlockID = FlockID,
QtyChange = convert(int,0), 
QtyChangeHoldingIncubatorCart = convert(int,0), 
QtyChangeCase = convert(int,0), 
QtyChangeReasonID = convert(int,0), 
QtyChangeActualDate = convert(date, getdate()), 
QtyChangeRecordedDate = convert(date, getdate()),
@UserName as UserName
from DeliveryCart dc
inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
where dcf.DeliveryCartFlockID = @DeliveryCartFlockID



GO
