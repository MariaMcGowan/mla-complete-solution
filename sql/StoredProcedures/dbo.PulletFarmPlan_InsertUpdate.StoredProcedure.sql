DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlan_InsertUpdate]
GO

create proc [dbo].[PulletFarmPlan_InsertUpdate] 
	@I_vPulletFarmPlanID int = null,
	@I_vContractTypeID int,
	@I_vFarmID int = null,
	@I_vConservativeFactor float = null,
	@I_vPulletQtyAt16Weeks int = null,
	@I_vPlanned24WeekDate date = null,
	@I_vPlannedStartDate date = null,
	@I_vProductionFarm_PlannedRemoveDate date = null,
	@I_vActual24WeekDate date = null,
	@I_vActualStartDate date = null,
	@I_vProductionFarm_RemoveDate date = null,
	@I_vProductionFarm_RemovalDateConfirmed bit = null,
	@I_vPulletFacility_RemoveDate date = null,
	@I_vPulletFacility_RemovalDateConfirmed bit = null,
	@I_vPulletFacility_FumigationDate date = null,
	@I_vPulletFacility_FumigationDateConfirmed bit = null,
	@I_vPulletFacility_LitterDate date = null,
	@I_vPulletFacility_LitterDateConfirmed bit = null,
	@I_vPulletFacility_WashDownDate date = null,
	@I_vPulletFacility_WashDownDateConfirmed bit = null,
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

As   

declare 
	@ExpectedLivability  numeric(10,8),
	@MaleToFemale  numeric(10,8),
	@FarmNumber varchar(10),
	@CommercialFarmEggPlanID int,
	@OrigPulletQtyAt16Weeks int,
	@PulletQtyChanged bit = 0,
	@ActualOrPlanned varchar(1), 
	@HatchDate date,
	@PlannedEndDate date,
	@ActualEndDate date,
	@Orig_Actual24WeekDate date,
	@Orig_Planned24WeekDate date,
	@ConservativeFactorChanged bit = 0,
	@Orig_ConservativeFactor float,
	@FlockPlanChanged bit = 1


select 
	@I_vPulletFarmPlanID = isnull(nullif(@I_vPulletFarmPlanID, ''),0),
	@I_vPlanned24WeekDate = nullif(@I_vPlanned24WeekDate, ''),
	@I_vPlannedStartDate = nullif(@I_vPlannedStartDate, ''),
	@I_vProductionFarm_PlannedRemoveDate = nullif(@I_vProductionFarm_PlannedRemoveDate, ''),
	@I_vActual24WeekDate = nullif(@I_vActual24WeekDate, ''),
	@I_vActualStartDate = nullif(@I_vActualStartDate, ''),
	@I_vProductionFarm_RemoveDate = nullif(@I_vProductionFarm_RemoveDate, ''),
	@I_vProductionFarm_RemovalDateConfirmed = isnull(nullif(@I_vProductionFarm_RemovalDateConfirmed, ''), 0),
	@I_vPulletFacility_RemoveDate = nullif(@I_vPulletFacility_RemoveDate, ''),
	@I_vPulletFacility_RemovalDateConfirmed = isnull(nullif(@I_vPulletFacility_RemovalDateConfirmed, ''), 0), 
	@I_vPulletFacility_FumigationDate = nullif(@I_vPulletFacility_FumigationDate, ''),
	@I_vPulletFacility_FumigationDateConfirmed = nullif(@I_vPulletFacility_FumigationDateConfirmed, ''),
	@I_vPulletFacility_LitterDate = nullif(@I_vPulletFacility_LitterDate, ''),
	@I_vPulletFacility_LitterDateConfirmed = nullif(@I_vPulletFacility_LitterDateConfirmed, ''),
	@I_vPulletFacility_WashDownDate = nullif(@I_vPulletFacility_WashDownDate, ''),
	@I_vPulletFacility_WashDownDateConfirmed = nullif(@I_vPulletFacility_WashDownDateConfirmed, ''),
	@I_vProductionFarm_FumigationDate = nullif(@I_vProductionFarm_FumigationDate, ''),
	@I_vProductionFarm_FumigationDateConfirmed = nullif(@I_vProductionFarm_FumigationDateConfirmed, ''),
	@I_vProductionFarm_LitterDate = nullif(@I_vProductionFarm_LitterDate, ''), 
	@I_vProductionFarm_LitterDateConfirmed = nullif(@I_vProductionFarm_LitterDateConfirmed, ''), 
	@I_vProductionFarm_WashDownDate = nullif(@I_vProductionFarm_WashDownDate, ''),
	@I_vProductionFarm_WashDownDateConfirmed = nullif(@I_vProductionFarm_WashDownDateConfirmed, ''),
	@I_vOverrideModifiedAfterOrderConfirm = nullif(@I_vOverrideModifiedAfterOrderConfirm, ''),
	@I_vFarmID= nullif(@I_vFarmID, ''),
	@I_vConservativeFactor = nullif(@I_vConservativeFactor, ''),
	@I_vContractTypeID = nullif(@I_vContractTypeID, '')


-- Changed by MCM on 11/15/2019
select @Orig_Actual24WeekDate = isnull(Actual24WeekDate, '01/01/1900')
	, @Orig_Planned24WeekDate = isnull(Planned24WeekDate, '01/01/1900')
	, @Orig_ConservativeFactor = ConservativeFactor
from PulletFarmPlan
where PulletFarmPlanID = @I_vPulletFarmPlanID

select @I_vPlannedStartDate = 
	case
		when @Orig_Planned24WeekDate <> @I_vPlanned24WeekDate then @I_vPlanned24WeekDate
		else isnull(@I_vPlannedStartDate, @I_vPlanned24WeekDate)
	end, 
	@PlannedEndDate = 
	case
		when isnull(@I_vProductionFarm_PlannedRemoveDate, '12/12/3000') < dateadd(week, 41, @I_vPlanned24WeekDate) then dateadd(day,-1, @I_vProductionFarm_PlannedRemoveDate)
		else dateadd(week, 41, @I_vPlanned24WeekDate)
	end

select @I_vActualStartDate = 
	case
		when @Orig_Actual24WeekDate <> @I_vActual24WeekDate then @I_vActual24WeekDate
		else isnull(@I_vActualStartDate, @I_vActual24WeekDate)
	end, 
	@ActualEndDate = 
	case
		when isnull(@I_vProductionFarm_RemoveDate, '12/12/3000') < dateadd(week, 41, @I_vActual24WeekDate) then dateadd(day,-1,@I_vProductionFarm_RemoveDate)
		else dateadd(week, 41, @I_vActual24WeekDate)
	end

select @FarmNumber = convert(varchar(10), FarmNumber) from Farm where FarmID = @I_vFarmID 

if @I_vActualStartDate is null
begin
	select @HatchDate = dateadd(week, -24,@I_vPlanned24WeekDate)
	if @Orig_Planned24WeekDate = @I_vPlanned24WeekDate
	begin
		select @FlockPlanChanged = 0
	end
end
else
begin
	select @HatchDate = dateadd(week, -24,@I_vActual24WeekDate)
	if @Orig_Actual24WeekDate = @I_vActual24WeekDate
	begin
		select @FlockPlanChanged = 0
	end
end

if @I_vConservativeFactor is null
begin
	if @I_vPulletFarmPlanID > 0
	begin
		select @I_vConservativeFactor = ConservativeFactor from PulletFarmPlan where PulletFarmPlanID = @I_vPulletFarmPlanID
		if @I_vConservativeFactor is null
		begin
			select @I_vConservativeFactor = ConservativeFactor from Farm where FarmID = @I_vFarmID
		end
	end
	else
	begin
		select @I_vConservativeFactor = ConservativeFactor from Farm where FarmID = @I_vFarmID
	end
end

if @I_vPulletFarmPlanID = 0
begin
	-- This is an insert!
	select @ExpectedLivability = ConstantValue from SystemConstant where ConstantName = 'Expected Livability Ratio'
	select @MaleToFemale = ConstantValue from SystemConstant where ConstantName = 'Male to Female Bird Ratio'

	-- Add in the new record
	insert into PulletFarmPlan (
		FarmID
		, PulletQtyAt16Weeks
		, Planned24WeekDate
		, PlannedStartDate
		, PlannedEndDate
		, PlannedCommercialEndDate
		, ProductionFarm_PlannedRemoveDate
		, ContractTypeID
		, ConservativeFactor	
		, ExpectedLivabilityRatio
		, MaleToFemaleBirdRatio
		, FlockNumber
		)
	select 
		@I_vFarmID
		, @I_vPulletQtyAt16Weeks
		, @I_vPlanned24WeekDate
		, @I_vPlannedStartDate
		, @PlannedEndDate
		, @PlannedEndDate
		, @I_vProductionFarm_PlannedRemoveDate
		, @I_vContractTypeID
		, @I_vConservativeFactor
		, @ExpectedLivability
		, @MaleToFemale
		, 'M' + @FarmNumber + '-' + right('00' + convert(varchar(2),datepart(wk, @HatchDate)),2) + '-' + right(convert(varchar(4),datepart(year,@HatchDate)),2)
	select @I_vPulletFarmPlanID = SCOPE_IDENTITY()

end
else
begin
	-- Is the pullet quantity the same?
	select @OrigPulletQtyAt16Weeks = PulletQtyAt16Weeks
	from PulletFarmPlan
	where PulletFarmPlanID = @I_vPulletFarmPlanID

	if @I_vPulletQtyAt16Weeks <> @OrigPulletQtyAt16Weeks
	begin
		select @PulletQtyChanged = 1
	end

	update PulletFarmPlan set 
		PulletQtyAt16Weeks = @I_vPulletQtyAt16Weeks,
		ConservativeFactor = @I_vConservativeFactor,
		Planned24WeekDate = @I_vPlanned24WeekDate, 
		PlannedStartDate = @I_vPlannedStartDate,
		PlannedEndDate = @PlannedEndDate,		--coalesce(@I_vProductionFarm_PlannedRemoveDate, PlannedEndDate, Planned65WeekDate),
		ProductionFarm_PlannedRemoveDate = @I_vProductionFarm_PlannedRemoveDate,

		Actual24WeekDate = @I_vActual24WeekDate, 
		ActualStartDate = @I_vActualStartDate,
		ActualEndDate = @ActualEndDate,		--coalesce(@I_vProductionFarm_RemoveDate, ActualEndDate, Actual65WeekDate),
		ActualCommercialEndDate = @ActualEndDate,

		ProductionFarm_RemoveDate = @I_vProductionFarm_RemoveDate,
		ProductionFarm_RemovalDateConfirmed = @I_vProductionFarm_RemovalDateConfirmed, 

		PulletFacility_RemoveDate = @I_vPulletFacility_RemoveDate,
		PulletFacility_RemovalDateConfirmed = @I_vPulletFacility_RemovalDateConfirmed, 
		PulletFacility_FumigationDate = @I_vPulletFacility_FumigationDate,
		PulletFacility_FumigationDateConfirmed = @I_vPulletFacility_FumigationDateConfirmed,
		PulletFacility_LitterDate = @I_vPulletFacility_LitterDate,
		PulletFacility_LitterDateConfirmed = @I_vPulletFacility_LitterDateConfirmed,
		PulletFacility_WashDownDate = @I_vPulletFacility_WashDownDate,
		PulletFacility_WashDownDateConfirmed = @I_vPulletFacility_WashDownDateConfirmed,

		ProductionFarm_FumigationDate = @I_vProductionFarm_FumigationDate,
		ProductionFarm_FumigationDateConfirmed = @I_vProductionFarm_FumigationDateConfirmed,
		ProductionFarm_LitterDate = @I_vProductionFarm_LitterDate,
		ProductionFarm_LitterDateConfirmed = @I_vProductionFarm_LitterDateConfirmed,
		ProductionFarm_WashDownDate = @I_vProductionFarm_WashDownDate,
		ProductionFarm_WashDownDateConfirmed = @I_vProductionFarm_WashDownDateConfirmed,
		OverrideModifiedAfterOrderConfirm = @I_vOverrideModifiedAfterOrderConfirm,
		ModifiedAfterOrderConfirm =
			case
				when Actual24WeekDate is not null and @FlockPlanChanged = 1 then 1
				else 0
			end,
		FlockNumber = 'M' + @FarmNumber + '-' + convert(varchar(2),datepart(wk, @HatchDate)) + '-' + right(convert(varchar(4),datepart(year, @HatchDate)),2)
		--,
		---- Added by MCM on 11/19
		--PlannedOrActual = 
		--	case
		--		when @I_vActual24WeekDate is not null then 'A'
		--		else 'P'
		--	end
	where PulletFarmPlanID = @I_vPulletFarmPlanID

end

if @I_vConservativeFactor <> @Orig_ConservativeFactor
	select @ConservativeFactorChanged = 1

-- Update the details! - but not for Pullet Only!!!!
if @I_vContractTypeID <> 4	-- Pullet Only
begin
	execute.PulletFarmPlanDetail_InsertUpdate @PulletFarmPlanID = @I_vPulletFarmPlanID, @PulletQtyChanged = @PulletQtyChanged, @ConservativeFactorChanged = @ConservativeFactorChanged
	--, 
	--	@PulletQtyAt16Weeks = @I_vPulletQtyAt16Weeks,
	--	@Planned24WeekDate = @I_vPlanned24WeekDate,
	--	@PlannedStartDate = @I_vPlannedStartDate,
	--	@PlannedEndDate  = @I_vPlannedEndDate,
	--	@ConservativeFactor = @I_vConservativeFactor

	-- Update Commercial Plans!
	execute CommercialCommitment_UpdateDetail @PulletFarmPlanID = @I_vPulletFarmPlanID
end

select @iRowID = @I_vPulletFarmPlanID



