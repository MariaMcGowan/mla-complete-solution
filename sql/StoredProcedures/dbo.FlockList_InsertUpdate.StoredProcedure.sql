USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockList_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockList_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[FlockList_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockList_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockList_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[FlockList_InsertUpdate]
	@I_vFlockID int
	,@I_vSortOrder int=null
	,@I_vIsActive bit=null
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

-- The Flock table was replaced with a view that is based
-- on the PulletFarmPlan
/*
	update dbo.Flock
	set
		SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vFlockID = FlockID
*/

	update dbo.PulletFarmPlan
		set OverwrittenIsActiveFlag = @I_vIsActive
	where PulletFarmPlanID = @I_vFlockID

	select @iRowID = @I_vFlockID



GO
