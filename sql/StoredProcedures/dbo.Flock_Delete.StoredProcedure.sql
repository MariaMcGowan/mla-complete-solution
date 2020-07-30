USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Flock_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Flock_Delete]
GO
/****** Object:  StoredProcedure [dbo].[Flock_Delete]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Flock_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Flock_Delete] AS' 
END
GO


ALTER proc [dbo].[Flock_Delete]
	@I_vFlockID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

--foreign keys exist for this table. These should 
delete from dbo.Flock where FlockID = @I_vFlockID



GO
