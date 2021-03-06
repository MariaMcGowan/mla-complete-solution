USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Process_PulletFarmPlan_UpdatePlannedOrActuals]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Process_PulletFarmPlan_UpdatePlannedOrActuals]
GO
/****** Object:  StoredProcedure [dbo].[Process_PulletFarmPlan_UpdatePlannedOrActuals]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Process_PulletFarmPlan_UpdatePlannedOrActuals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Process_PulletFarmPlan_UpdatePlannedOrActuals] AS' 
END
GO





ALTER proc [dbo].[Process_PulletFarmPlan_UpdatePlannedOrActuals]
	@PulletFarmPlanID int
	, @ConservativeFactor float
	, @PulletQtyAt16Weeks int
	, @Planned24WeekDate date = null
	, @PlannedStartDate date = null
	, @PlannedEndDate date = null
	, @Actual24WeekDate date = null
	, @ActualStartDate date = null
	, @ActualEndDate date = null
as

--exec Process_PulletFarmPlan_UpdatePlannedOrActuals '2053', '0.9', '21000', '12/19/2020', '12/19/2020', '10/02/2021', '12/27/2020', '', ''
--declare
--	@PulletFarmPlanID int
--	, @ConservativeFactor float
--	, @PulletQtyAt16Weeks int
--	, @Planned24WeekDate date = null
--	, @PlannedStartDate date = null
--	, @PlannedEndDate date = null
--	, @Actual24WeekDate date = null
--	, @ActualStartDate date = null
--	, @ActualEndDate date = null

--select 
--	@PulletFarmPlanID = '2053'
--	, @ConservativeFactor = '0.9'
--	, @PulletQtyAt16Weeks = '21000'
--	, @Planned24WeekDate = '12/19/2020'
--	, @PlannedStartDate = '12/19/2020'
--	, @PlannedEndDate = '10/02/2021'
--	, @Actual24WeekDate = '12/27/2020'
--	, @ActualStartDate = ''
--	, @ActualEndDate = ''

declare @FarmNumber int,
	@Planned65WeekDate date,
	@Original_Planned24WeekDate date,
	@Original_PlannedStartDate date,
	@Original_PlannedEndDate date,
	@Original_Planned65WeekDate date,
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
	@FarmID int,
	@ContractTypeID int,
	@O_iErrorState int=0,				  
	@oErrString varchar(255)='',
	@iRowID varchar(255)=NULL


select @Planned24WeekDate = nullif(@Planned24WeekDate, '')
	, @PlannedStartDate = nullif(@PlannedStartDate, '')
	, @PlannedEndDate = nullif(@PlannedEndDate, '')
	, @Actual24WeekDate = nullif(@Actual24WeekDate, '')
	, @ActualStartDate = nullif(@ActualStartDate, '')
	, @ActualEndDate = nullif(@ActualEndDate, '')


-- is the user changing the Actual dates?
if @Actual24WeekDate is not null
begin
	-- We can change the actuals without doing validation
	execute PulletFarmPlan_Form_UpdateActuals_InsertUpdate 
		@I_vPulletFarmPlanID = @PulletFarmPlanID
		, @I_vConservativeFactor = @ConservativeFactor
		, @I_vPulletQtyAt16Weeks = @PulletQtyAt16Weeks
		, @I_vActual24WeekDate = @Actual24WeekDate
		, @I_vActualStartDate = @ActualStartDate
		, @I_vActualEndDate = @ActualEndDate
		, @O_iErrorState = @O_iErrorState
		, @oErrString = @oErrString
		, @iRowID = @iRowID

	select @ChangeApplied = 1, @RunInsertUpdate = 0
end
else
begin
	select @PlannedStartDate = isnull(nullif(@PlannedStartDate,''), @Planned24WeekDate)

	select @Original_Planned24WeekDate = Planned24WeekDate, 
		@Original_PlannedStartDate = isnull(PlannedStartDate, Planned24WeekDate), 
		@Original_PlannedEndDate = PlannedEndDate,
		@FarmID = FarmID,
		@ContractTypeID = ContractTypeID
	from PulletFarmPlan
	where PulletFarmPlanID = @PulletFarmPlanID


	-- Was this flock plan change already validated?
	if exists 
	(
		select 1 
		from UserFlockPlanChanges 
		where FarmID = @FarmID 
			and StartDate = @PlannedStartDate
			and Planned24WeekDate = @Planned24WeekDate 
			and EndDate = @PlannedEndDate
	)
	begin
		-- Yes!, it was!
		select @ReturnCode = ValidationReturnCode, @ChangeApplied = ChangeApplied, @UserFlockPlanChangesID = UserFlockPlanChangesID
		from UserFlockPlanChanges 
		where FarmID = @FarmID 
			and StartDate = @PlannedStartDate 
			and EndDate = @PlannedEndDate 
			and Planned24WeekDate = @Planned24WeekDate

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
		from dbo.ValidateNewFlock(@FarmID, @Planned24WeekDate, @PlannedEndDate, @PulletFarmPlanID, @ContractTypeID)

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

		insert into UserFlockPlanChanges (PulletFarmPlanID, FarmID, Planned24WeekDate, StartDate, EndDate, UserMessage, ValidationReturnCode, ContractTypeID)
		select @PulletFarmPlanID, @FarmID, @Planned24WeekDate, @PlannedStartDate, @PlannedEndDate, @UserMessage, @ReturnCode, @ContractTypeID

		select @UserFlockPlanChangesID = SCOPE_IDENTITY()

		if @ReturnCode = 0
		begin
			select @RunInsertUpdate = 1
		end
	end

	if @RunInsertUpdate = 1
	begin
		if @ChangeApplied = 0
		begin
			exec PulletFarmPlan_InsertUpdate @I_vFarmID = @FarmID, @I_vPlanned24WeekDate = @Planned24WeekDate, 
			@I_vPlannedStartDate = @PlannedStartDate, @I_vPlannedEndDate = @PlannedEndDate, 
			@I_vPulletFarmPlanID = @PulletFarmPlanID, @I_vPulletQtyAt16Weeks = @PulletQtyAt16Weeks, @I_vContractTypeID = @ContractTypeID,
			@I_vConservativeFactor = @ConservativeFactor,
			@O_iErrorState = @O_iErrorState OUTPUT, @oErrString = @oErrString OUTPUT, @iRowID = @iRowID OUTPUT

			if exists (select 1 from PulletFarmPlan where FarmID = @FarmID and ContractTypeID = @ContractTypeID and PlannedStartDate = @PlannedStartDate and PlannedEndDate = @PlannedEndDate and Planned24WeekDate = @Planned24WeekDate)
			begin
				-- this was definitely added / updated!
				delete from UserFlockPlanChanges
				where FarmID = @FarmID and StartDate = @PlannedStartDate and EndDate = @PlannedEndDate and Planned24WeekDate = @Planned24WeekDate and ContractTypeID = @ContractTypeID
			end
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




GO
