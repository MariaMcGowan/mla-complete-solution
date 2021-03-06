USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockPlanDates_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockPlanDates_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[FlockPlanDates_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockPlanDates_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockPlanDates_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[FlockPlanDates_InsertUpdate]  
  @I_vPulletFarmPlanID int
 ,@I_vActualHatchDate date = null
 ,@I_vPlannedHatchDate date = null
 ,@I_vPulletFacility_RemoveDate date = null
 ,@I_vPulletFacility_WashDownDate date = null
 ,@I_vPulletFacility_LitterDate date = null
 ,@I_vPulletFacility_FumigationDate date = null
 ,@I_vProductionFarm_RemoveDate date = null
 ,@I_vProductionFarm_WashDownDate date = null
 ,@I_vProductionFarm_LitterDate date = null
 ,@I_vProductionFarm_FumigationDate date = null
 ,@O_iErrorState int=0 output   
 ,@oErrString varchar(255)='' output   
 ,@iRowID varchar(255)=NULL output  
 
 AS  

	declare @FarmNumber varchar(3)
		, @HatchDate date
		, @ContractTypeID int 

	select 
		@I_vPlannedHatchDate = coalesce(@I_vPlannedHatchDate, PlannedHatchDate), 
		@I_vActualHatchDate = coalesce(@I_vActualHatchDate, ActualHatchDate),
		@ContractTypeID = ContractTypeID
	from PulletFarmPlan
	where PulletFarmPlanID = @I_vPulletFarmPlanID

 	 update PulletFarmPlan set 
		  Actual24WeekDate = dateadd(week,24, @I_vActualHatchDate)
		 ,Planned24WeekDate = dateadd(week, 24, @I_vPlannedHatchDate)
		 ,PulletFacility_RemoveDate = @I_vPulletFacility_RemoveDate
		 ,PulletFacility_WashDownDate = @I_vPulletFacility_WashDownDate
		 ,PulletFacility_LitterDate = @I_vPulletFacility_LitterDate
		 ,PulletFacility_FumigationDate = @I_vPulletFacility_FumigationDate
		 ,ProductionFarm_RemoveDate = @I_vProductionFarm_RemoveDate
		 ,ProductionFarm_WashDownDate = @I_vProductionFarm_WashDownDate
		 ,ProductionFarm_LitterDate = @I_vProductionFarm_LitterDate
		 ,ProductionFarm_FumigationDate = @I_vProductionFarm_FumigationDate
		 ,ActualEndDate = isnull(@I_vPulletFacility_RemoveDate, ActualEndDate)
		 ,ActualCommercialEndDate = isnull(@I_vProductionFarm_RemoveDate, ActualCommercialEndDate)
	 where PulletFarmPlanID = @I_vPulletFarmPlanID

	 select @HatchDate = coalesce(ActualHatchDate, PlannedHatchDate), @FarmNumber = FarmNumber
	 from PulletFarmPlan pfp
	 left outer join Farm f on pfp.FarmID = f.FarmID
	 where PulletFarmPlanID = @I_vPulletFarmPlanID

	-- Don't forget to update the flock number if the hatch date changed
	update PulletFarmPlan set 
		FlockNumber = 'M' + @FarmNumber + '-' + right('00' + convert(varchar(2),datepart(wk, @HatchDate)),2) + '-' + right(convert(varchar(4),datepart(year,@HatchDate)),2)
	where PulletFarmPlanID = @I_vPulletFarmPlanID


	-- What about the detail?
	-- If the actual hatch date changed, it needs to be updated!
	-- Update the details! - but not for Pullet Only!!!!
	if @ContractTypeID <> 4	-- Pullet Only
	begin
		execute.PulletFarmPlanDetail_InsertUpdate @PulletFarmPlanID = @I_vPulletFarmPlanID, @PulletQtyChanged = 0, @ConservativeFactorChanged = 0

		-- Update Commercial Plans!
		execute CommercialCommitment_UpdateDetail @PulletFarmPlanID = @I_vPulletFarmPlanID
	end


GO
