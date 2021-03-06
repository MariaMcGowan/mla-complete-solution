USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_Incubator_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_Incubator_Delete]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_Incubator_Delete]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_Incubator_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_Incubator_Delete] AS' 
END
GO


ALTER proc [dbo].[EggTransaction_Incubator_Delete]
	@I_vEggTransactionID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

declare @QtyChange int,
	@FlockID int,
	@OrderIncubatorCartID int, 
	@OrderIncubatorID int

select @QtyChange = QtyChange, @FlockID = FlockID, @OrderIncubatorCartID = OrderIncubatorCartID
from EggTransaction
where EggTransactionID = @I_vEggTransactionID

select @OrderIncubatorID = OrderIncubatorID
from OrderIncubatorCart oic
where OrderIncubatorCartID = @OrderIncubatorCartID

delete from EggTransaction where EggTransactionID = @I_vEggTransactionID

update OrderIncubatorCart set ActualQty = ActualQty - @QtyChange where OrderIncubatorCartID = @OrderIncubatorCartID
update OrderIncubator set ActualQty = ActualQty - @QtyChange where OrderIncubatorID = @OrderIncubatorID



GO
