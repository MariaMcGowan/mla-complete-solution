DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlan_InsertUpdate_NoValidationRequired]
GO

create proc [dbo].[PulletFarmPlan_InsertUpdate_NoValidationRequired]
	@I_vPulletFarmPlanID int,
	@I_vConservativeFactor float,
	@I_vPulletQtyAt16Weeks int,
	@I_vPulletFacility_RemoveDate date = null,
	@I_vPulletFacility_RemovalDateConfirmed bit = null,
	@I_vPulletFacility_FumigationDate date = null,
	@I_vPulletFacility_FumigationDateConfirmed bit = null,
	@I_vPulletFacility_LitterDate date = null,
	@I_vPulletFacility_LitterDateConfirmed bit = null,
	@I_vPulletFacility_WashDownDate date = null,
	@I_vPulletFacility_WashDownDateConfirmed bit = null,
	
	@I_vProductionFarm_PlannedRemoveDate date = null,
	@I_vProductionFarm_RemoveDate date = null,
	@I_vProductionFarm_RemovalDateConfirmed bit = null,
	@I_vProductionFarm_FumigationDate date = null,
	@I_vProductionFarm_FumigationDateConfirmed bit = null,
	@I_vProductionFarm_LitterDate date = null,
	@I_vProductionFarm_LitterDateConfirmed bit = null,
	@I_vProductionFarm_WashDownDate date = null,
	@I_vProductionFarm_WashDownDateConfirmed bit = null,

	@I_vOverrideModifiedAfterOrderConfirm bit = null,
	@O_iErrorState int=0 output,				  
	@oErrString varchar(255)='' output,
	@iRowID varchar(255)=NULL output  

as

declare @OrigPulletQtyAt16Weeks int, 
	@PulletQtyChanged bit = 0,
	@ContractTypeID int,
	@ConservativeFactorChanged bit = 0,
	@Orig_ConservativeFactor float

select 	@I_vPulletFacility_RemoveDate = nullif(@I_vPulletFacility_RemoveDate, ''),
	@I_vPulletFacility_RemovalDateConfirmed = isnull(nullif(@I_vPulletFacility_RemovalDateConfirmed, ''), 0),
	@I_vPulletFacility_FumigationDate = nullif(@I_vPulletFacility_FumigationDate, ''),
	@I_vPulletFacility_FumigationDateConfirmed = nullif(@I_vPulletFacility_FumigationDateConfirmed, ''),
	@I_vPulletFacility_LitterDate = nullif(@I_vPulletFacility_LitterDate, ''),
	@I_vPulletFacility_LitterDateConfirmed = nullif(@I_vPulletFacility_LitterDateConfirmed, ''),
	@I_vPulletFacility_WashDownDate = nullif(@I_vPulletFacility_WashDownDate, ''),
	@I_vPulletFacility_WashDownDateConfirmed = nullif(@I_vPulletFacility_WashDownDateConfirmed, ''),

	@I_vProductionFarm_PlannedRemoveDate = nullif(@I_vProductionFarm_PlannedRemoveDate, ''),
	@I_vProductionFarm_RemoveDate = nullif(@I_vProductionFarm_RemoveDate, ''),
	@I_vProductionFarm_RemovalDateConfirmed = isnull(nullif(@I_vProductionFarm_RemovalDateConfirmed, ''), 0),
	@I_vProductionFarm_FumigationDate = nullif(@I_vProductionFarm_FumigationDate, ''),
	@I_vProductionFarm_FumigationDateConfirmed = nullif(@I_vProductionFarm_FumigationDateConfirmed, ''),
	@I_vProductionFarm_LitterDate = nullif(@I_vProductionFarm_LitterDate, ''), 
	@I_vProductionFarm_LitterDateConfirmed = nullif(@I_vProductionFarm_LitterDateConfirmed, ''), 
	@I_vProductionFarm_WashDownDate = nullif(@I_vProductionFarm_WashDownDate, ''),
	@I_vProductionFarm_WashDownDateConfirmed = nullif(@I_vProductionFarm_WashDownDateConfirmed, ''),

	@I_vOverrideModifiedAfterOrderConfirm = nullif(@I_vOverrideModifiedAfterOrderConfirm, '')

-- Is the pullet quantity the same?
select @OrigPulletQtyAt16Weeks = PulletQtyAt16Weeks
	, @ContractTypeID = ContractTypeID
	, @Orig_ConservativeFactor = ConservativeFactor
from PulletFarmPlan
where PulletFarmPlanID = @I_vPulletFarmPlanID

if @I_vPulletQtyAt16Weeks <> @OrigPulletQtyAt16Weeks
begin
	select @PulletQtyChanged = 1
end

if @I_vConservativeFactor <> @Orig_ConservativeFactor
begin
	select @ConservativeFactorChanged = 1
end

update PulletFarmPlan
	set ConservativeFactor = @I_vConservativeFactor,
	PulletQtyAt16Weeks = @I_vPulletQtyAt16Weeks,

	PulletFacility_RemoveDate = @I_vPulletFacility_RemoveDate,
	PulletFacility_RemovalDateConfirmed = @I_vPulletFacility_RemovalDateConfirmed,
	PulletFacility_FumigationDate = @I_vPulletFacility_FumigationDate,
	PulletFacility_FumigationDateConfirmed = @I_vPulletFacility_FumigationDateConfirmed,
	PulletFacility_LitterDate = @I_vPulletFacility_LitterDate,
	PulletFacility_LitterDateConfirmed = @I_vPulletFacility_LitterDateConfirmed,
	PulletFacility_WashDownDate = @I_vPulletFacility_WashDownDate,
	PulletFacility_WashDownDateConfirmed = @I_vPulletFacility_WashDownDateConfirmed,

	ActualEndDate = coalesce(dateadd(day,-1, @I_vProductionFarm_RemoveDate), ActualEndDate, Actual65WeekDate),
	ProductionFarm_PlannedRemoveDate = @I_vProductionFarm_PlannedRemoveDate,
	PlannedEndDate = coalesce(dateadd(day,-1, @I_vProductionFarm_PlannedRemoveDate), PlannedEndDate, Planned65WeekDate),

	ProductionFarm_RemoveDate = @I_vProductionFarm_RemoveDate,
	ProductionFarm_RemovalDateConfirmed = @I_vProductionFarm_RemovalDateConfirmed, 
	ProductionFarm_FumigationDate = @I_vProductionFarm_FumigationDate,
	ProductionFarm_FumigationDateConfirmed = @I_vProductionFarm_FumigationDateConfirmed,
	ProductionFarm_LitterDate = @I_vProductionFarm_LitterDate,
	ProductionFarm_LitterDateConfirmed = @I_vProductionFarm_LitterDateConfirmed,
	ProductionFarm_WashDownDate = @I_vProductionFarm_WashDownDate,
	ProductionFarm_WashDownDateConfirmed = @I_vProductionFarm_WashDownDateConfirmed,

	OverrideModifiedAfterOrderConfirm = @I_vOverrideModifiedAfterOrderConfirm
where PulletFarmPlanID = @I_vPulletFarmPlanID



-- Update the details! - but not for Pullet Only!!!!
if @ContractTypeID <> 4	-- Pullet Only
begin
	execute.PulletFarmPlanDetail_InsertUpdate @PulletFarmPlanID = @I_vPulletFarmPlanID, @PulletQtyChanged = @PulletQtyChanged, @ConservativeFactorChanged = @ConservativeFactorChanged

	-- Update Commercial Plans!
	execute CommercialCommitment_UpdateDetail @PulletFarmPlanID = @I_vPulletFarmPlanID
end

select @iRowID = @I_vPulletFarmPlanID



