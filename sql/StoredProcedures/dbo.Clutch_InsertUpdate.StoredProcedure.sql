USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Clutch_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Clutch_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Clutch_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Clutch_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Clutch_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[Clutch_InsertUpdate]
	@I_vClutchID int
	,@I_vClutch nvarchar(255)=null
	,@I_vFlockID int=null
	,@I_vLayDate date
	,@I_vRackCnt decimal(15,10)
	,@I_vCaseCnt decimal(15,10)
	,@I_vPlannedQty int=null
	,@I_vActualQty int=null
	,@I_vCalculatedQty int=null
	,@I_vWgtPerDozen decimal(6,3)
	,@I_vReasoningForPlannedQty varchar(1000)=null
	,@I_vSortOrder int=null
	,@I_vIsActive bit=null
	,@I_vUserName nvarchar(255)=null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

if @I_vClutchID = 0
begin
	-- Check to see if a clutch already exists for this lay date
	select @I_vClutchID = IsNull((select ClutchID from Clutch where LayDate = @I_vLayDate and FlockID = @I_vFlockID),0) 
end


if @I_vClutchID = 0
begin
	declare @ClutchID table (ClutchID int)
	insert into dbo.Clutch (
		Clutch
		, FlockID
		, LayDate
		, RackCnt
		, CaseCnt
		, PlannedQty
		, ActualQty
		, CalculatedQty
		, WgtPerDozen
		, ReasoningForPlannedQty
		, SortOrder
		, IsActive
	)
	output inserted.ClutchID into @ClutchID(ClutchID)
	select
		@I_vClutch
		,@I_vFlockID
		,@I_vLayDate
		,@I_vRackCnt
		,@I_vCaseCnt
		,@I_vPlannedQty
		,@I_vActualQty
		,@I_vCalculatedQty
		,@I_vWgtPerDozen
		,@I_vReasoningForPlannedQty
		,@I_vSortOrder
		,@I_vIsActive
	select top 1 @I_vClutchID = ClutchID, @iRowID = ClutchID from @ClutchID
end
else
begin
	update dbo.Clutch
	set
		Clutch = @I_vClutch
		,FlockID = @I_vFlockID
		,LayDate = @I_vLayDate
		,RackCnt = @I_vRackCnt
		,CaseCnt = @I_vCaseCnt
		,PlannedQty = @I_vPlannedQty
		,ActualQty = @I_vActualQty
		,CalculatedQty = @I_vCalculatedQty
		,WgtPerDozen = @I_vWgtPerDozen
		,ReasoningForPlannedQty = @I_vReasoningForPlannedQty
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vClutchID = ClutchID
	select @iRowID = @I_vClutchID
end

select @I_vClutchID as ID,'forward' As referenceType



GO
