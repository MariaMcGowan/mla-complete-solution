USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubator_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderIncubator_Delete]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubator_Delete]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubator_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderIncubator_Delete] AS' 
END
GO


ALTER proc [dbo].[OrderIncubator_Delete]
	@I_vOrderIncubatorID int
	,@I_vUserName varchar(100)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

declare @ClutchQty table (ClutchID int, ClutchQtyAfterTransaction int)
insert into @ClutchQty (ClutchID)
select distinct ClutchID from OrderIncubatorCart where OrderIncubatorID = @I_vOrderIncubatorID

update cq 
set ClutchQtyAfterTransaction = (select top 1 ClutchQtyAfterTransaction from EggTransaction et where et.ClutchID = cq.ClutchID order by QtyChangeRecordedDate)
from @ClutchQty cq 

insert into EggTransaction (ClutchID, QtyChange, QtyChangeReasonID, QtyChangeActualDate, QtyChangeRecordedDate, UseName, 
ClutchQtyAfterTransaction, OrderIncubatorCartID)
select oic.ClutchID, ActualQty * -1, 10, getdate(), getdate(), 
@I_vUserName, ClutchQtyAfterTransaction, oic.OrderIncubatorCartID
from OrderIncubatorCart oic
left join @ClutchQty qc on oic.ClutchID = qc.ClutchID
where @I_vOrderIncubatorID = OrderIncubatorID



-- MCM change 04/07/2017
-- Change made to store original actual qty to the planned qty
update OrderIncubatorCart set PlannedQty = isnull(nullif(ActualQty,0),PlannedQty), ActualQty = 0
where OrderIncubatorID = @I_vOrderIncubatorID


-- MCM change 04/07/2017
-- Change made to store original actual qty to the planned qty
update OrderIncubator set PlannedQty = isnull(nullif(ActualQty,0),PlannedQty), ActualQty = 0
where OrderIncubatorID = @I_vOrderIncubatorID




GO
