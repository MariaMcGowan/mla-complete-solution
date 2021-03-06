USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_IncubatorChanges]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_IncubatorChanges]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_IncubatorChanges]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_IncubatorChanges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_IncubatorChanges] AS' 
END
GO


ALTER proc [dbo].[EggTransaction_IncubatorChanges] @OrderIncubatorCartID int = null
As

select fl.FlockID, Flock, QtyChangeActualDate, QtyChange, qcr.QuantityChangeReason, EggTransactionID
from EggTransaction et
inner join Clutch cl on et.ClutchID = cl.ClutchID
inner join Flock fl on cl.FlockID = fl.FlockID
inner join QuantityChangeReason	qcr on et.QtyChangeReasonID = qcr.QuantityChangeReasonID
where OrderIncubatorCartID = @OrderIncubatorCartID
order by Flock, EggTransactionID




GO
