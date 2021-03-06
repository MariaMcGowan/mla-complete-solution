USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[UserPlanningSettings_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[UserPlanningSettings_Get]
GO
/****** Object:  StoredProcedure [dbo].[UserPlanningSettings_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPlanningSettings_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UserPlanningSettings_Get] AS' 
END
GO



ALTER proc [dbo].[UserPlanningSettings_Get] @UserID varchar(255)
as

	declare @PlanningStartDate date, 
		@PlanningEndDate date, 
		@ShowEmbryoOrPulletQtyID varchar(10)


	if exists (select 1 from UserPlanningSettings where UserID = @UserID)
	begin
		select @PlanningStartDate  = PlanningStartDate,
		@PlanningEndDate  = PlanningEndDate,
		@ShowEmbryoOrPulletQtyID = ShowEmbryoOrPulletQtyID
		from UserPlanningSettings
		where UserID = @UserID

		if @PlanningEndDate < convert(date, getdate())
			select @PlanningEndDate = convert(date, getdate())
	end
	else
	begin
		select @PlanningStartDate  = isnull(nullif(@PlanningStartDate,''), convert(date,getdate()))
		select @PlanningEndDate  = isnull(nullif(@PlanningEndDate,''), dateadd(yy, 2, @PlanningStartDate))
		select @ShowEmbryoOrPulletQtyID = isnull(nullif(@ShowEmbryoOrPulletQtyID, ''), 'Embryo')
	end

	select @UserID as UserID, @PlanningStartDate as PlanningStartDate, @PlanningEndDate as PlanningEndDate, @ShowEmbryoOrPulletQtyID as ShowEmbryoOrPulletQtyID



GO
