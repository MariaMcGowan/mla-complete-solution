USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_HoldingIncubatorChanges]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_HoldingIncubatorChanges]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_HoldingIncubatorChanges]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_HoldingIncubatorChanges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_HoldingIncubatorChanges] AS' 
END
GO


ALTER proc [dbo].[EggTransaction_HoldingIncubatorChanges] @DeliveryCartFlockID int = null
As

select fl.FlockID, Flock, QtyChangeActualDate, QtyChange, qcr.QuantityChangeReason, EggTransactionID
from EggTransaction et
inner join Flock fl on et.FlockID = fl.FlockID
inner join QuantityChangeReason	qcr on et.QtyChangeReasonID = qcr.QuantityChangeReasonID
where DeliveryCartFlockID = @DeliveryCartFlockID
order by Flock, EggTransactionID




GO
