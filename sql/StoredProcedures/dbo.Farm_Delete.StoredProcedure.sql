USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Farm_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Farm_Delete]
GO
/****** Object:  StoredProcedure [dbo].[Farm_Delete]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Farm_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Farm_Delete] AS' 
END
GO


ALTER proc [dbo].[Farm_Delete]
	@I_vFarmID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

-- Can this farm be deleted?, does it have any PulletFarmPlan's associated to it?
declare @CanBeDeleted bit = 1

if exists (select 1 from PulletFarmPlan where FarmID = @I_vFarmID)
	select @CanBeDeleted = 0


if @CanBeDeleted = 1
begin
	delete from UserPlanningFarmList where FarmID = @I_vFarmID
	delete from UserFlockPlanChanges where FarmID = @I_vFarmID
	delete from FarmEmbryoStandardYield where FarmID = @I_vFarmID

	delete from Farm where FarmID = @I_vFarmID
end
else
begin
	-- This farm can't be deleted, but can it be deactivated?
	-- Is it used in a current or future flock?
	 if exists 
	 (
		select 1 
		from RollingDailySchedule rds 
		where rds.Date between dateadd(year,-1,getdate()) and dateadd(year,2,getdate())
		and FarmID = @I_vFarmID
		and rds.SellableEggs > 0
	)
	begin
		declare @ErrorMessage varchar(255)
		declare @FarmNumber varchar(10)

		select @FarmNumber = FarmNumber
		from Farm 
		where FarmID = @I_vFarmID

		select @ErrorMessage = 'Farm ' + @FarmNumber + ' is included in active flocks; it may not be deleted.'
		RAISERROR(@ErrorMessage,16,1)
	end
	else
	begin
		update Farm set IsActive = 0 where FarmID = @I_vFarmID
	end
end



GO
