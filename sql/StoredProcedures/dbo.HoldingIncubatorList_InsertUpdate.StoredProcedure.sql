USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorList_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HoldingIncubatorList_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorList_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldingIncubatorList_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HoldingIncubatorList_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[HoldingIncubatorList_InsertUpdate]
	@I_vHoldingIncubatorID int
	,@I_vHoldingIncubator nvarchar(255)
	,@I_vCartCapacity int = null
	,@I_vSortOrder int = null
	,@I_vIsActive bit = null
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
	update dbo.HoldingIncubator
	set
	HoldingIncubator = @I_vHoldingIncubator
		,CartCapacity = @I_vCartCapacity
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vHoldingIncubatorID = HoldingIncubatorID
	select @iRowID = @I_vHoldingIncubatorID




GO
