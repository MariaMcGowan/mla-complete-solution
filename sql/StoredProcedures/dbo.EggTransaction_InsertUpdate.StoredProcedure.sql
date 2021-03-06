USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[EggTransaction_InsertUpdate]
@I_vFlockID int = null
,@I_vLayDate date = null
,@I_vCoolerClutchID int = null
,@I_vQtyChange int
,@I_vQtyChangeReasonID int
,@I_vQtyChangeActualDate date
,@I_vUserName varchar(100)
,@O_iErrorState int=0 output
,@oErrString varchar(255)='' output
,@iRowID varchar(255)=NULL output
As

declare @ChangeQtyBeforeTransaction int = 0
declare @ClutchID int = 0
declare @TableID int = null

if @I_vCoolerClutchID is not null
begin
	select @I_vCoolerClutchID = nullif(@I_vCoolerClutchID, ''),
	@I_vFlockID = nullif(@I_vFlockID, ''),
	@I_vLayDate = nullif(@I_vLayDate, '')

	select @ChangeQtyBeforeTransaction = ActualQty, @ClutchID = ClutchID, @TableID = CoolerClutchID
	from CoolerClutch
	where CoolerClutchID = @I_vCoolerClutchID

	--if @ClutchID is not null
	--begin
	--	update CoolerClutch set ActualQty = @ChangeQtyBeforeTransaction + @I_vQtyChange
	--	where CoolerClutchID = @I_vCoolerClutchID
	--end
end
else
begin
	if @I_vFlockID is not null and @I_vLayDate is not null
	begin
		if not exists (select 1 from Clutch where FlockID = @I_vFlockID and LayDate = @I_vLayDate)
		begin
			insert into Clutch (FlockID, LayDate)
			select @I_vFlockID, @I_vLayDate
		end
		
		select @ClutchID = ClutchID
		from Clutch
		where FlockID = @I_vFlockID and LayDate = @I_vLayDate
	end
end

if @ClutchID is not null
begin
	select top 1 @I_vCoolerClutchID = CoolerClutchID, @ChangeQtyBeforeTransaction = ActualQty
	from CoolerClutch
	where ClutchID = @ClutchID
	order by ActualQty desc

	insert into EggTransaction (ClutchID, QtyChange, QtyChangeReasonID, QtyChangeActualDate, QtyChangeRecordedDate, UseName, ClutchQtyAfterTransaction, CoolerClutchID)
	select @ClutchID, @I_vQtyChange, @I_vQtyChangeReasonID, @I_vQtyChangeActualDate, getdate(), @I_vUserName, @ChangeQtyBeforeTransaction + @I_vQtyChange, @I_vCoolerClutchID

	update CoolerClutch set ActualQty = @ChangeQtyBeforeTransaction + @I_vQtyChange
	where CoolerClutchID = @I_vCoolerClutchID
end




GO
