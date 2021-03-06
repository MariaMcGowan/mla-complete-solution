USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[UserPlanningSettings_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[UserPlanningSettings_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[UserPlanningSettings_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPlanningSettings_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UserPlanningSettings_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[UserPlanningSettings_InsertUpdate] 
	  @I_vUserID varchar(255)
	 ,@I_vPlanningStartDate date
	 ,@I_vPlanningEndDate date
	 ,@I_vShowEmbryoOrPulletQtyID varchar(10)
	 ,@O_iErrorState int=0 output   
	 ,@oErrString varchar(255)='' output   
	 ,@iRowID varchar(255)=NULL output 
as


	if exists (select 1 from UserPlanningSettings where UserID = @I_vUserID)
	begin
		update UserPlanningSettings set
			PlanningStartDate  = @I_vPlanningStartDate,
			PlanningEndDate  = @I_vPlanningEndDate,
			ShowEmbryoOrPulletQtyID = @I_vShowEmbryoOrPulletQtyID
		from UserPlanningSettings
		where UserID = @I_vUserID
	end
	else
	begin
		insert into UserPlanningSettings (UserID, PlanningStartDate, PlanningEndDate, ShowEmbryoOrPulletQtyID)
		select @I_vUserID, @I_vPlanningStartDate, @I_vPlanningEndDate, @I_vShowEmbryoOrPulletQtyID
	end



GO
