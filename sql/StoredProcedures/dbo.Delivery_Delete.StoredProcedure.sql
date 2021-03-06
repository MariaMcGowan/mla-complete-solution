USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Delivery_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Delivery_Delete]
GO
/****** Object:  StoredProcedure [dbo].[Delivery_Delete]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Delivery_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Delivery_Delete] AS' 
END
GO


ALTER proc [dbo].[Delivery_Delete]
	@I_vDeliveryID int
	,@I_vUserName varchar(100)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS


declare @FlockQty table (FlockID int, FlockQtyAfterTransaction int)
insert into @FlockQty (FlockID)
select distinct FlockID
from Delivery d
inner join DeliveryCart dc on d.DeliveryID = dc.DeliveryID
inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID 
where d.DeliveryID = @I_vDeliveryID

update fq
set FlockQtyAfterTransaction = (select top 1 FlockQtyAfterTransaction from EggTransaction et where et.FlockID = fq.FlockID order by QtyChangeRecordedDate)
from @FlockQty fq


insert into EggTransaction (FlockID, QtyChange, QtyChangeReasonID, QtyChangeActualDate, QtyChangeRecordedDate, UseName, ClutchQtyAfterTransaction, DeliveryCartFlockID)
select dcf.FlockID, dcf.ActualQty, 11, getdate(), getdate(), @I_vUserName, FlockQtyAfterTransaction, DeliveryCartFlockID
from Delivery d
inner join DeliveryCart dc on d.DeliveryID = dc.DeliveryID
inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID 
left outer join @FlockQty fq on dcf.FlockID = fq.FlockID
where d.DeliveryID = @I_vDeliveryID

-- MCM change 04/07/2017
-- Change made to store original actual qty to the planned qty
update dcf set dcf.PlannedQty = isnull(nullif(dcf.ActualQty,0),dcf.PlannedQty), dcf.ActualQty = 0
from DeliveryCart dc 
inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID 
where DeliveryID = @I_vDeliveryID

-- MCM change 04/07/2017
-- Change made to store original actual qty to the planned qty
update Delivery set PlannedQty = isnull(nullif(ActualQty,0),PlannedQty), ActualQty = 0
where DeliveryID = @I_vDeliveryID




--delete from OrderDelivery where DeliveryID = @I_vDeliveryID

--delete from Delivery where DeliveryID = @I_vDeliveryID



GO
