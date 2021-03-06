USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Candling_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Candling_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Candling_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Candling_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Candling_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[Candling_InsertUpdate]
	@I_vFlockID int
    ,@I_vLoadPlanning_DetailID int = null
    ,@I_vLoadPlanningID int
    ,@I_vWgtPreCon numeric(19,1) = null
    ,@I_vSortOrder int = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

if isNull(@I_vLOadPlanning_DetailID,0) = 0
begin
	insert into LoadPlanning_Detail (LoadPlanningID, FlockID, FlockQty, LastCandleoutPercent, weightPreConversion, candlingSortOrder)
	select
		@I_vLoadPlanningID
		,@I_vFlockID
		,0
		,null
		,@I_vWgtPreCon
		,@I_vSortOrder

end
else
begin
	update LoadPLanning_Detail
	set weightPreConversion = @I_vWgtPreCon
		,candlingSortOrder = @I_vSortOrder
	where LoadPlanning_DetailID = @I_vLoadPlanning_DetailID
end



GO
