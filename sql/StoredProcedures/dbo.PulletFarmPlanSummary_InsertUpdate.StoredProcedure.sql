USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanSummary_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlanSummary_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanSummary_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanSummary_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlanSummary_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[PulletFarmPlanSummary_InsertUpdate]
	@I_vPulletFarmPlanID int
	, @I_vStartDate date
	, @I_vEndDate date
	, @O_iErrorState int=0 output
	, @oErrString varchar(255)='' output
	, @iRowID varchar(255)=NULL output  
As   

-- Is @StartDate and @EndDate between 23 and 65 weeks?
-- Does this interfere with the Removal dates?

select @I_vStartDate = isnull(nullif(@I_vStartDate, ''), '01/01/1900')
	, @I_vEndDate = isnull(nullif(@I_vEndDate, ''), '12/31/3000')

declare @HatchDate date
	, @MovedToFarm date 
	, @RemovedFromFarm date
	, @PlannedOrActual varchar(1)
	, @ContractTypeID int



select @HatchDate = 
	case
		when pfp.Actual24WeekDate is not null then pfp.ActualHatchDate
		else pfp.PlannedHatchDate
	end, 
	@PlannedOrActual = 
	case
		when pfp.Actual24WeekDate is not null then 'A'
		else 'P'
	end, 
	@ContractTypeID = ContractTypeID
from PulletFarmPlan pfp
where pfp.PulletFarmPlanID = @I_vPulletFarmPlanID

select 
	@MovedToFarm = isnull(PulletFacility_RemoveDate, dateadd(week, 22, @HatchDate))
	, @RemovedFromFarm = isnull(ProductionFarm_RemoveDate, dateadd(week, 67, @HatchDate))
from PulletFarmPlan 
where PulletFarmPlanID = @I_vPulletFarmPlanID


if @I_vStartDate between @MovedToFarm and @RemovedFromFarm
	and @I_vEndDate between @MovedToFarm and @RemovedFromFarm
begin
	if @PlannedOrActual = 'A'
	begin
		update PulletFarmPlan set ActualStartDate = @I_vStartDate, ActualEndDate = isnull(@RemovedFromFarm, @I_vEndDate) where PulletFarmPlanID = @I_vPulletFarmPlanID
	end
	else
	begin
		update PulletFarmPlan set PlannedStartDate = @I_vStartDate, PlannedEndDate = @I_vEndDate where PulletFarmPlanID = @I_vPulletFarmPlanID
	end

	-- Update the details! - but not for Pullet Only!!!!
	if @ContractTypeID <> 4	-- Pullet Only
	begin
		execute.PulletFarmPlanDetail_InsertUpdate @PulletFarmPlanID = @I_vPulletFarmPlanID, @PulletQtyChanged = 0, @ConservativeFactorChanged = 0

		-- Update Commercial Plans!
		execute CommercialCommitment_UpdateDetail @PulletFarmPlanID = @I_vPulletFarmPlanID
	end

end







GO
