USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockComment_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockComment_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[FlockComment_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockComment_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockComment_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[FlockComment_InsertUpdate] 
@I_vPulletFarmPlanCommentID int = null,
@I_vPulletFarmPlanID int = null,
@I_vScreenName varchar(50) = null, 
@I_vUserID varchar(100),
@I_vComment varchar(2000) = null,
@O_iErrorState int=0 output,				  
@oErrString varchar(255)='' output,
@iRowID varchar(255)=NULL output  


As   

if @I_vPulletFarmPlanCommentID = 0
begin
	insert into PulletFarmPlanComment (PulletFarmPlanID, ScreenName, UserID, Comment, UpdatedDateTime)
	select @I_vPulletFarmPlanID, @I_vScreenName, @I_vUserID, @I_vComment, getdate()

	select @I_vPulletFarmPlanCommentID = SCOPE_IDENTITY()

end
else
begin
	update PulletFarmPlanComment set
		UserID = @I_vUserID
		, Comment = @I_vComment
		, UpdatedDateTime = getdate()
	where PulletFarmPlanCommentID = @I_vPulletFarmPlanCommentID
	
end



GO
