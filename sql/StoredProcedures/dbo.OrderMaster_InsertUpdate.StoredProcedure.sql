USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderMaster_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderMaster_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OrderMaster_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderMaster_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderMaster_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[OrderMaster_InsertUpdate]
	@I_vOrderID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

-- This is read only, so nothing to do here.
-- The flock detail will update separately.

	select @iRowID = @I_vOrderID



GO
