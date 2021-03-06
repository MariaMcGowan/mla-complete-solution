USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[DestinationMaster_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[DestinationMaster_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[DestinationMaster_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DestinationMaster_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DestinationMaster_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[DestinationMaster_InsertUpdate]
	@I_vDestinationID int
	,@I_vDestination nvarchar(255)=null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

-- This is read only, so nothing to do here.
-- The flock detail will update separately.

	select @iRowID = @I_vDestinationID



GO
