USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_HoldingIncubator_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_HoldingIncubator_Delete]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_HoldingIncubator_Delete]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_HoldingIncubator_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_HoldingIncubator_Delete] AS' 
END
GO


ALTER proc [dbo].[EggTransaction_HoldingIncubator_Delete]
	@I_vEggTransactionID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

declare @QtyChange int,
	@FlockID int,
	@DeliveryCartFlockID int, 
	@DeliveryID int

select @QtyChange = QtyChange, @FlockID = FlockID, @DeliveryCartFlockID = DeliveryCartFlockID
from EggTransaction
where EggTransactionID = @I_vEggTransactionID

select @DeliveryID = DeliveryID
from DeliveryCartFlock dcf
inner join DeliveryCart dc on dcf.DeliveryCartID = dc.DeliveryCartID
where DeliveryCartFlockID = @DeliveryCartFlockID

delete from EggTransaction where EggTransactionID = @I_vEggTransactionID

update DeliveryCartFlock set ActualQty = ActualQty - @QtyChange where DeliveryCartFlockID = @DeliveryCartFlockID
update Delivery set ActualQty = ActualQty - @QtyChange where DeliveryID = @DeliveryID




GO
