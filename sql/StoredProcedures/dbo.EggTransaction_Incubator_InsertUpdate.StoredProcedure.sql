USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_Incubator_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_Incubator_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_Incubator_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_Incubator_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_Incubator_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[EggTransaction_Incubator_InsertUpdate]
@I_vOrderIncubatorCartID int = null
,@I_vQtyChange int
,@I_vQtyChangeReasonID int
,@I_vQtyChangeActualDate date
,@I_vUserName varchar(100)
,@O_iErrorState int=0 output
,@oErrString varchar(255)='' output
,@iRowID varchar(255)=NULL output
As

declare @ClutchID int
declare @QtyBeforeChange int
declare @OrderIncubatorID int


if isnull(@I_vOrderIncubatorCartID ,0) <> 0
begin
	select @ClutchID = ClutchID, @OrderIncubatorID = OrderIncubatorID
	from OrderIncubatorCart
	where OrderIncubatorCartID = @I_vOrderIncubatorCartID

	select top 1 @QtyBeforeChange = ClutchQtyAfterTransaction
	from EggTransaction
	where ClutchID = @ClutchID
	order by QtyChangeRecordedDate desc

	insert into EggTransaction (ClutchID, QtyChange, QtyChangeReasonID, QtyChangeActualDate, QtyChangeRecordedDate, UseName, ClutchQtyAfterTransaction, OrderIncubatorCartID)
	select @ClutchID, @I_vQtyChange, @I_vQtyChangeReasonID, @I_vQtyChangeActualDate, getdate(), @I_vUserName, @QtyBeforeChange + @I_vQtyChange, @I_vOrderIncubatorCartID

	-- MCM change 04/07/2017
	-- Change made to store original actual qty to the planned qty
	update OrderIncubatorCart set PlannedQty = ActualQty, ActualQty = ActualQty + @I_vQtyChange 
	where OrderIncubatorCartID = @I_vOrderIncubatorCartID

	-- MCM change 04/07/2017
	-- Change made to store original actual qty to the planned qty
	update OrderIncubator set PlannedQty = ActualQty, ActualQty = ActualQty + @I_vQtyChange
	where OrderIncubatorID = @OrderIncubatorID 
end



GO
