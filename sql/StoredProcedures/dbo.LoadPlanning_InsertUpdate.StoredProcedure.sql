USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[LoadPlanning_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[LoadPlanning_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[LoadPlanning_InsertUpdate]
	@I_vLoadPlanningID int = null
	,@I_vDeliveryDate date
	,@I_vSetDate date
	,@I_vOverflowFlockID int =  null
	,@I_vPercentCushion numeric(5,2) = null
	,@I_vTargetQty int = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

select @I_vLoadPlanningID = isnull(@I_vLoadPlanningID, 0)

If @I_vLoadPlanningID = 0
begin
	declare @LoadPlanningID table (LoadPlanningID int)
	insert into LoadPlanning (
		DeliveryDate
		, SetDate
	)
	output inserted.LoadPlanningID into @LoadPlanningID(LoadPlanningID)
	select @I_vDeliveryDate, @I_vSetDate

	select top 1 @I_vLoadPlanningID = LoadPlanningID, @iRowID = LoadPlanningID from @LoadPlanningID
	update [Order] set LoadPlanningID = @I_vLoadPlanningID where isnull(LoadPlanningID,0) = 0 and DeliveryDate = @I_vDeliveryDate and PlannedSetDate = @I_vSetDate
end
else
begin
	update LoadPlanning
	set
		OverflowFlockID = isnull(@I_vOverflowFlockID, OverflowFlockID)
		,PercentCushion = isnull(@I_vPercentCushion, PercentCushion)
		,TargetQty = isnull(@I_vTargetQty, TargetQty)
	where @I_vLoadPlanningID = LoadPlanningID
end
	
select @iRowID = @I_vLoadPlanningID





GO
