USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_Detail_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[LoadPlanning_Detail_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_Detail_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning_Detail_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[LoadPlanning_Detail_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[LoadPlanning_Detail_InsertUpdate]
	@I_vLoadPlanning_DetailID int
	,@I_vLoadPlanningID int
	,@I_vFlockID int = null
	,@I_vIsOverflow bit = 0
	,@I_vFlockQty int = 0
	,@I_vLastCandleoutPercent numeric(5,2) = 0
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

if @I_vFlockID is null
	return

if @I_vIsOverflow = 1
begin
	update LoadPlanning set OverflowFlockID = @I_vFlockID where LoadPlanningID = @I_vLoadPlanningID
end

if @I_vLoadPlanning_DetailID = 0
begin
	declare @LoadPlanning_DetailID table (LoadPlanning_DetailID int)
	insert into LoadPlanning_Detail (
		
		LoadPlanningID
		, FlockID
		, FlockQty
		, LastCandleoutPercent
	)
	output inserted.LoadPlanning_DetailID into @LoadPlanning_DetailID(LoadPlanning_DetailID)
	select
		
		@I_vLoadPlanningID
		,@I_vFlockID
		,@I_vFlockQty
		,@I_vLastCandleoutPercent
	select top 1 @I_vLoadPlanning_DetailID = LoadPlanning_DetailID, @iRowID = LoadPlanning_DetailID from @LoadPlanning_DetailID
end
else
begin
	update LoadPlanning_Detail
	set
		
		LoadPlanningID = @I_vLoadPlanningID
		,FlockID = @I_vFlockID
		,FlockQty = @I_vFlockQty
		,LastCandleoutPercent = @I_vLastCandleoutPercent
	where @I_vLoadPlanning_DetailID = LoadPlanning_DetailID
	select @iRowID = @I_vLoadPlanning_DetailID
end



GO
