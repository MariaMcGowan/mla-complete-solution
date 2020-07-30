USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockComment_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockComment_Delete]
GO
/****** Object:  StoredProcedure [dbo].[FlockComment_Delete]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockComment_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockComment_Delete] AS' 
END
GO


ALTER proc [dbo].[FlockComment_Delete]
	@I_vPulletFarmPlanCommentID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS


delete from dbo.PulletFarmPlanComment where PulletFarmPlanCommentID = @I_vPulletFarmPlanCommentID


GO
