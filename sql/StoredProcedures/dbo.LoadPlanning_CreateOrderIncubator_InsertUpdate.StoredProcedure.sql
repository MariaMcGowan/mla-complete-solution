USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_CreateOrderIncubator_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[LoadPlanning_CreateOrderIncubator_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_CreateOrderIncubator_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning_CreateOrderIncubator_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[LoadPlanning_CreateOrderIncubator_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[LoadPlanning_CreateOrderIncubator_InsertUpdate]
	@I_vOrderID int
	,@I_vIncubatorID int
	,@I_vIncubatorNumber int
	,@I_vLoadPlanningID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
as

declare @I_vOrderIncubatorID int
select @I_vOrderIncubatorID = OrderIncubatorID from OrderIncubator where OrderID = @I_vOrderID and IncubatorID = @I_vIncubatorID

declare @SetDate date
select @SetDate = PlannedSetDate from [Order] where OrderID = @I_vOrderID

If IsNull(@I_vOrderIncubatorID,0) = 0
	begin
		declare @OrderIncubatorID table (OrderIncubatorID int)
		insert into OrderIncubator (OrderID, IncubatorID, PlannedQty, ActualQty, ProfileNumber, StartDateTime, ProgramBy, CheckedByPrimary, CheckedBySecondary, SetDate)
		output inserted.OrderIncubatorID into @OrderIncubatorID(OrderIncubatorID)
		select
			@I_vOrderID
			,@I_vIncubatorID
			,0
			,0
			,null
			,null
			,null
			,null
			,null
			,@SetDate

		select @I_vOrderIncubatorID = OrderIncubatorID from @OrderIncubatorID
	end


update LoadPlanning
set OrderIncubatorID1 = case when @I_vIncubatorNumber = 1 then @I_vOrderIncubatorID else OrderIncubatorID1 end
	,OrderIncubatorID2 = case when @I_vIncubatorNumber = 2 then @I_vOrderIncubatorID else OrderIncubatorID2 end
	,OrderIncubatorID3 = case when @I_vIncubatorNumber = 3 then @I_vOrderIncubatorID else OrderIncubatorID3 end
	,OrderIncubatorID4 = case when @I_vIncubatorNumber = 4 then @I_vOrderIncubatorID else OrderIncubatorID4 end
	,OrderIncubatorID5 = case when @I_vIncubatorNumber = 5 then @I_vOrderIncubatorID else OrderIncubatorID5 end
	,OrderIncubatorID6 = case when @I_vIncubatorNumber = 6 then @I_vOrderIncubatorID else OrderIncubatorID6 end
	,OrderIncubatorID7 = case when @I_vIncubatorNumber = 7 then @I_vOrderIncubatorID else OrderIncubatorID7 end
	,OrderIncubatorID8 = case when @I_vIncubatorNumber = 8 then @I_vOrderIncubatorID else OrderIncubatorID8 end
where LoadPlanningID = @I_vLoadPlanningID



GO
