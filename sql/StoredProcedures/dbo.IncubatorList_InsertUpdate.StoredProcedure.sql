USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorList_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorList_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorList_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorList_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorList_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[IncubatorList_InsertUpdate]
	@I_vIncubatorID int
	,@I_vSortOrder int = null
	,@I_vIsActive bit = null
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
	update dbo.Incubator
	set
		SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vIncubatorID = IncubatorID
	select @iRowID = @I_vIncubatorID



GO
