USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CoolerList_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CoolerList_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[CoolerList_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoolerList_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CoolerList_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[CoolerList_InsertUpdate]
	@I_vCoolerID int
	,@I_vSortOrder int
	,@I_vIsActive bit
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
	update dbo.Cooler
	set
		SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vCoolerID = CoolerID
	select @iRowID = @I_vCoolerID



GO
