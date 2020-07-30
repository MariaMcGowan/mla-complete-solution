DROP PROCEDURE IF EXISTS [dbo].[Pre_PulletFarmPlan_InsertUpdate]
GO

create proc [dbo].[Pre_PulletFarmPlan_InsertUpdate]
	@PulletFarmPlanID int = null,
	@FarmID int = null,
	@ConservativeFactor float = null,
	@PulletQtyAt16Weeks int = null,
	@ContractTypeID int = null,
	@PlannedHatchDate date = null,
	@PlannedStartDate date = null,
	@ProductionFarm_PlannedRemoveDate date = null,
	@ActualHatchDate date = null,
	@ActualStartDate date = null,
	@ProductionFarm_RemoveDate date = null,
	@ProductionFarm_RemovalDateConfirmed bit = null,
	@PulletFacility_RemoveDate date = null,
	@PulletFacility_RemovalDateConfirmed bit = null,
	@PulletFacility_FumigationDate date = null,
	@PulletFacility_FumigationDateConfirmed bit = null,
	@PulletFacility_LitterDate date = null,
	@PulletFacility_LitterDateConfirmed bit = null,
	@PulletFacility_WashDownDate date = null,
	@PulletFacility_WashDownDateConfirmed bit = null,
	@ProductionFarm_FumigationDate date = null,
	@ProductionFarm_FumigationDateConfirmed bit = null,
	@ProductionFarm_LitterDate date = null,
	@ProductionFarm_LitterDateConfirmed bit = null,
	@ProductionFarm_WashDownDate date = null,
	@ProductionFarm_WashDownDateConfirmed bit = null,
	@OverrideModifiedAfterOrderConfirm bit = null
	
	
as

set nocount on

declare @FarmNumber int,
	@ReturnCode int, 
	@Conflict24WeekDate date, 
	@ConflictStartDate date,
	@ConflictEndDate date, 
	@ShowMessage bit, 
	@Overridable bit,
	@MoveWeekCount int,
	@OrigStartDate date,
	@OrigEndDate date,
	@UserMessage varchar(500),
	@UserMessageID int, 
	@FlockInProcess bit = 0,
	@RunInsertUpdate bit = 0, 
	@ChangeApplied bit = 0,
	@UserFlockPlanChangesID int,
	/*
		The user has a form which allows them to update either the planned dates, or the 
		actual dates.  In an attempt to simplify, if actual dates are filled in, 
		than that is what is used for validation purposes.  Because once we have actuals 
		we don't care about planned.
		Otherwise, we just validate with planned.
	*/
	@ActualOrPlanned varchar(1),
	@TestStartDate date,
	@TestEndDate date,

	@Original_Test24WeekDate date,
	@Original_TestStartDate date,
	@Original_TestEndDate date,

	@ActualEndDate date,
	@PlannedEndDate date,

	@New24WeekDate date


select @PulletFarmPlanID = isnull(nullif(@PulletFarmPlanID, ''),0)
	, @PlannedStartDate = nullif(@PlannedStartDate, '')
	, @PlannedHatchDate = nullif(@PlannedHatchDate, '')
	, @ProductionFarm_PlannedRemoveDate = nullif(@ProductionFarm_PlannedRemoveDate, '')
	, @ActualStartDate = nullif(@ActualStartDate, '')
	, @ActualHatchDate = nullif(@ActualHatchDate, '')
	, @ProductionFarm_RemoveDate = nullif(@ProductionFarm_RemoveDate, '')
	, @ProductionFarm_RemovalDateConfirmed = isnull(nullif(@ProductionFarm_RemovalDateConfirmed, ''),0)
	, @FarmID = nullif(@FarmID, '')
	, @PulletQtyAt16Weeks = nullif(@PulletQtyAt16Weeks, '')
	, @ConservativeFactor = nullif(@ConservativeFactor, '')
	, @PulletFacility_RemovalDateConfirmed = isnull(nullif(@PulletFacility_RemovalDateConfirmed, ''),0)


select @ReturnCode = 0

-- Confirm that there is either a planned hatch date or an actual hatch date
if @ActualHatchDate is null and @PlannedHatchDate is null
begin
	select @UserMessage = 'This flock cannot be saved without a hatch date!', 
		@ReturnCode = -40, 
		@RunInsertUpdate = 0

	insert into UserFlockPlanChanges (PulletFarmPlanID, FarmID, ActualHatchDate, StartDate, EndDate, UserMessage, ValidationReturnCode, ContractTypeID)
	select @PulletFarmPlanID, @FarmID, @ActualHatchDate, @TestStartDate, @TestEndDate, @UserMessage, @ReturnCode, @ContractTypeID

	select @UserFlockPlanChangesID = SCOPE_IDENTITY()
end

if @ReturnCode >= 0
begin
	if @ActualHatchDate is null
		set @ActualOrPlanned = 'P'
	else
		set @ActualOrPlanned = 'A'

	if @ActualOrPlanned = 'P'
	begin
		select @PlannedStartDate = isnull(@PlannedStartDate, dateadd(week, 24, @PlannedHatchDate))
		select @PlannedEndDate = coalesce(@ProductionFarm_PlannedRemoveDate, @PlannedEndDate, dateadd(week, 41, @PlannedStartDate))
		select @TestStartDate = @PlannedStartDate, 
			@TestEndDate = @PlannedEndDate
		select @New24WeekDate= dateadd(week,24,@PlannedHatchDate)
	end
	else
	begin
		select @ActualStartDate = isnull(@ActualStartDate, dateadd(week,24,@ActualHatchDate))
		select @ActualEndDate = coalesce(@ProductionFarm_RemoveDate, @ActualEndDate, dateadd(week, 41, @ActualStartDate))
		select @TestStartDate = @ActualStartDate, 
			@TestEndDate = @ActualEndDate
		select @New24WeekDate= dateadd(week,24,@ActualHatchDate)
	end

	if isnull(@PulletFarmPlanID, 0) > 0
	begin
		if @ActualOrPlanned = 'P'
		begin
			select @Original_Test24WeekDate = Planned24WeekDate, 
				@Original_TestStartDate = isnull(PlannedStartDate, Planned24WeekDate), 
				@Original_TestEndDate = PlannedEndDate
			from PulletFarmPlan
			where PulletFarmPlanID = @PulletFarmPlanID
			and ContractTypeID = @ContractTypeID
		end
		else
		begin
			select @Original_Test24WeekDate = Actual24WeekDate, 
				@Original_TestStartDate = isnull(ActualStartDate, Actual24WeekDate), 
				@Original_TestEndDate = ActualEndDate
			from PulletFarmPlan
			where PulletFarmPlanID = @PulletFarmPlanID
			and ContractTypeID = @ContractTypeID
		end
	end

	-- Did the flock change 24 week date?
	if @Original_Test24WeekDate = @New24WeekDate
	begin
		-- No need to validate, just allow other changes
		select @RunInsertUpdate = 1, @ChangeApplied = 0
	end
	else
	begin
		print '@ActualOrPlanned ' + @ActualOrPlanned
		print convert(varchar(10), @Original_Test24WeekDate, 101)
		print convert(varchar(10), @New24WeekDate, 101)

		-- Was this flock plan change already validated?
		if exists 
		(
			select 1 
			from UserFlockPlanChanges 
			where FarmID = @FarmID 
				and StartDate = @TestStartDate
				and EndDate = @TestEndDate
		)
		begin
			-- Yes!, it was!
			select @ReturnCode = ValidationReturnCode, @ChangeApplied = ChangeApplied, @UserFlockPlanChangesID = UserFlockPlanChangesID
			from UserFlockPlanChanges 
			where FarmID = @FarmID 
				and StartDate = @TestStartDate 
				and EndDate = @TestEndDate 
				and ContractTypeID = @ContractTypeID

			if @ReturnCode >= 0 
			begin
				select @RunInsertUpdate = 1
			end
		end
		else
		begin
			-- Nope, then we just have to validate it!
			declare @ValidateFlock table (ReturnCode int, Conflict24WeekDate date, ConflictStartDate date, ConflictEndDate date, ShowMessage bit, Overridable bit)

			insert into @ValidateFlock
			select *
			from dbo.ValidateNewFlock(@FarmID, @TestStartDate, @TestEndDate, @PulletFarmPlanID, @ContractTypeID)

			--select * from @ValidateFlock

			select top 1 
				@ReturnCode = ReturnCode,
				@Conflict24WeekDate = Conflict24WeekDate, 
				@ConflictStartDate = ConflictStartDate,
				@ConflictEndDate = ConflictEndDate,
				@ShowMessage = ShowMessage,
				@Overridable = Overridable
			from @ValidateFlock

			select @UserMessage = 
					case @ReturnCode
						when 0 then null

						when 10 then 'This flock plan would not leave the minimum requested days between the flock planned for ' 
						+ convert(varchar, @ConflictStartDate, 101) + ' - ' 
						+ convert(varchar, @ConflictEndDate, 101) + ' and this new flock plan.  Please confirm.'
			
						when 20 then 'This flock plan would not leave the minimum requested days between the flock that has been order confirmed for ' 
						+ convert(varchar, @ConflictStartDate, 101) + ' - ' 
						+ convert(varchar, @ConflictEndDate, 101) + ' and this new flock plan.  Please confirm.'

						when -10 then 'This flock plan would interfere with the flock that has been planned for '
						+ convert(varchar, @ConflictStartDate, 101) + ' - ' 
						+ convert(varchar, @ConflictEndDate, 101) + '.'

						when -20 then 'This flock plan would interfere with the flock that has been order confirmed for '
						+ convert(varchar, @ConflictStartDate, 101) + ' - ' 
						+ convert(varchar, @ConflictEndDate, 101) + '.'

						when -30 then 'This flock is currently in production, it cannot be changed.' 

					end

			if @ActualOrPlanned = 'P'
			begin
				insert into UserFlockPlanChanges (PulletFarmPlanID, FarmID, Planned24WeekDate, StartDate, EndDate, UserMessage, ValidationReturnCode, ContractTypeID)
				select @PulletFarmPlanID, @FarmID, @TestStartDate, @TestStartDate, @TestEndDate, @UserMessage, @ReturnCode, @ContractTypeID

				select @UserFlockPlanChangesID = SCOPE_IDENTITY()
			end
			else
			begin
				insert into UserFlockPlanChanges (PulletFarmPlanID, FarmID, ActualHatchDate, StartDate, EndDate, UserMessage, ValidationReturnCode, ContractTypeID)
				select @PulletFarmPlanID, @FarmID, @ActualHatchDate, @TestStartDate, @TestEndDate, @UserMessage, @ReturnCode, @ContractTypeID

				select @UserFlockPlanChangesID = SCOPE_IDENTITY()
			end

			if @ReturnCode = 0
			begin
				select @RunInsertUpdate = 1
			end
		end
	end
end

	if @RunInsertUpdate = 1
	begin
		if @ChangeApplied = 0
		begin
			declare @Planned24WeekDate date,
			@Actual24WeekDate date,
			@O_iErrorState int=0,				  
			@oErrString varchar(255)='',
			@iRowID varchar(255)=NULL

			select @Planned24WeekDate = dateadd(week, 24, @PlannedHatchDate),
				@Actual24WeekDate = dateadd(week, 24, @ActualHatchDate)

			--exec PulletFarmPlan_InsertUpdate @I_vFarmID = @FarmID, @I_vPlanned24WeekDate = @Planned24WeekDate, 
			--@I_vPlannedStartDate = @PlannedStartDate, @I_vProductionFarm_PlannedRemoveDate = @ProductionFarm_PlannedRemoveDate, 
			--@I_vActual24WeekDate = @Actual24WeekDate, 
			--@I_vActualStartDate = @ActualStartDate, @I_vProductionFarm_RemoveDate = @ProductionFarm_RemoveDate, 
			--@I_vPulletFarmPlanID = @PulletFarmPlanID, @I_vPulletQtyAt16Weeks = @PulletQtyAt16Weeks, @I_vContractTypeID = @ContractTypeID,
			--@I_vConservativeFactor = @ConservativeFactor, @I_vOverrideModifiedAfterOrderConfirm = @OverrideModifiedAfterOrderConfirm, 
			--@O_iErrorState = @O_iErrorState OUTPUT, @oErrString = @oErrString OUTPUT, @iRowID = @iRowID OUTPUT

			exec PulletFarmPlan_InsertUpdate 
			@I_vPulletFarmPlanID = @PulletFarmPlanID, 
			@I_vContractTypeID = @ContractTypeID,
			@I_vFarmID = @FarmID, 
			@I_vConservativeFactor = @ConservativeFactor, 
			@I_vPulletQtyAt16Weeks = @PulletQtyAt16Weeks, 
			@I_vPlanned24WeekDate = @Planned24WeekDate, 
			@I_vPlannedStartDate = @PlannedStartDate, 					
			@I_vProductionFarm_PlannedRemoveDate = @ProductionFarm_PlannedRemoveDate, 
			@I_vActual24WeekDate = @Actual24WeekDate, 
			@I_vActualStartDate = @ActualStartDate, 
			@I_vProductionFarm_RemoveDate = @ProductionFarm_RemoveDate, 			
			@I_vProductionFarm_RemovalDateConfirmed = @ProductionFarm_RemovalDateConfirmed,
			@I_vPulletFacility_RemoveDate = @PulletFacility_RemoveDate, 	
			@I_vPulletFacility_RemovalDateConfirmed = @PulletFacility_RemovalDateConfirmed, 
			@I_vPulletFacility_FumigationDate = @PulletFacility_FumigationDate,
			@I_vPulletFacility_FumigationDateConfirmed = @PulletFacility_FumigationDateConfirmed,
			@I_vPulletFacility_LitterDate = @PulletFacility_LitterDate,
			@I_vPulletFacility_LitterDateConfirmed = @PulletFacility_LitterDateConfirmed,
			@I_vPulletFacility_WashDownDate = @PulletFacility_WashDownDate,
			@I_vPulletFacility_WashDownDateConfirmed = @PulletFacility_WashDownDateConfirmed,
			@I_vProductionFarm_FumigationDate = @ProductionFarm_FumigationDate,
			@I_vProductionFarm_FumigationDateConfirmed = @ProductionFarm_FumigationDateConfirmed,
			@I_vProductionFarm_LitterDate = @ProductionFarm_LitterDate,
			@I_vProductionFarm_LitterDateConfirmed = @ProductionFarm_LitterDateConfirmed,
			@I_vProductionFarm_WashDownDate = @ProductionFarm_WashDownDate,
			@I_vProductionFarm_WashDownDateConfirmed = @ProductionFarm_WashDownDateConfirmed,	
			@I_vOverrideModifiedAfterOrderConfirm = @OverrideModifiedAfterOrderConfirm, 
			@O_iErrorState = @O_iErrorState OUTPUT, @oErrString = @oErrString OUTPUT, @iRowID = @iRowID OUTPUT

			if exists (select 1 from PulletFarmPlan where FarmID = @FarmID and ContractTypeID = @ContractTypeID and PlannedStartDate = @PlannedStartDate and PlannedEndDate = @PlannedEndDate and Planned24WeekDate = @Planned24WeekDate)
			begin
				-- this was definitely added / updated!
				delete from UserFlockPlanChanges
				where FarmID = @FarmID and StartDate = @PlannedStartDate and EndDate = @PlannedEndDate and Planned24WeekDate = @Planned24WeekDate and ContractTypeID = @ContractTypeID
			end
		end
	end

	select 
		UserFlockPlanChangesID = @UserFlockPlanChangesID,
		referenceType = 
			case 
				-- Successfully saved!
				when @RunInsertUpdate = 1 then 'Close'
				-- Change was applied, either this time or before
				when @ChangeApplied = 1 then 'Close'
				-- Straight up failures
				when @ReturnCode < 0 then 'Failed'
				-- Is it an update?
				when @PulletFarmPlanID > 0 then 'Update'
				-- Nope, it is new
				when @ReturnCode in (10, 20) then 'Confirm'
			end




