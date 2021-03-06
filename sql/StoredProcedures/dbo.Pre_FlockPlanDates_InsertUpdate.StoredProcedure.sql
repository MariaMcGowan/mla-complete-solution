USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Pre_FlockPlanDates_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Pre_FlockPlanDates_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Pre_FlockPlanDates_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pre_FlockPlanDates_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Pre_FlockPlanDates_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[Pre_FlockPlanDates_InsertUpdate]

	@PulletFarmPlanID int,
	@PlannedHatchDate date,
	@ActualHatchDate date,
	@PulletFacility_RemoveDate date, 
	@PulletFacility_WashDownDate date, 
	@PulletFacility_LitterDate date, 
	@PulletFacility_FumigationDate date, 
	@ProductionFarm_RemoveDate date, 
	@ProductionFarm_WashDownDate date, 
	@ProductionFarm_LitterDate date, 
	@ProductionFarm_FumigationDate date,
	@PulletFacilityID int,
	@OverrideModifiedAfterOrderConfirm bit = 0

as

declare @FarmID int,
	@OriginalPlannedHatchDate date,
	@Planned24WeekDate date, 
	@PlannedEndDate date,
	@UserMessage varchar(500),
	@UserFlockPlanChangesID int, 
	@ReturnCode int, 
	@Conflict24WeekDate date, 
	@ConflictStartDate date,
	@ConflictEndDate date, 
	@ShowMessage bit, 
	@Overridable bit,
	@ChangeApplied bit, 
	@RunInsertUpdate bit = 0,
	@ContractTypeID int,
	@OriginalPulletFacilityID int


update PulletFarmPlan set OverrideModifiedAfterOrderConfirm = @OverrideModifiedAfterOrderConfirm
where PulletFarmPlanID = @PulletFarmPlanID

select 	
	@PlannedHatchDate = nullif(@PlannedHatchDate, ''),
	@ActualHatchDate = nullif(@ActualHatchDate, ''),
	@PulletFacility_RemoveDate = nullif(@PulletFacility_RemoveDate, ''), 
	@PulletFacility_WashDownDate = nullif(@PulletFacility_WashDownDate, ''), 
	@PulletFacility_LitterDate = nullif(@PulletFacility_LitterDate, ''), 
	@PulletFacility_FumigationDate = nullif(@PulletFacility_FumigationDate, ''), 
	@ProductionFarm_RemoveDate = nullif(@ProductionFarm_RemoveDate, ''), 
	@ProductionFarm_WashDownDate = nullif(@ProductionFarm_WashDownDate, ''), 
	@ProductionFarm_LitterDate = nullif(@ProductionFarm_LitterDate, ''), 
	@ProductionFarm_FumigationDate = nullif(@ProductionFarm_FumigationDate, '')


select @FarmID = FarmID, @OriginalPlannedHatchDate = PlannedHatchDate, @ContractTypeID = ContractTypeID, @OriginalPulletFacilityID = isnull(PulletFacilityID,0)
from PulletFarmPlan
where PulletFarmPlanID = @PulletFarmPlanID



if @OriginalPulletFacilityID <> @PulletFacilityID
begin
	update PulletFarmPlan set PulletFacilityID = @PulletFacilityID
	where PulletFarmPlanID = @PulletFarmPlanID
end



if @OriginalPlannedHatchDate <> isnull(@PlannedHatchDate, @OriginalPlannedHatchDate)
begin
	-- the user is changing the actual flock plan schedule, not just the removal dates or the actual hatch date
	-- We need to confirm this the same way we do when they try to move an existing flock
	select @Planned24WeekDate = dateadd(week,24,@PlannedHatchDate),
		@PlannedEndDate = dateadd(week, 61, @PlannedHatchDate)


	-- Was this flock plan change already validated?
	if exists (select 1 from UserFlockPlanChanges where PulletFarmPlanID = @PulletFarmPlanID and StartDate = @Planned24WeekDate and EndDate = @PlannedEndDate)
	begin
		-- Yes!, it was!
		select @ReturnCode = ValidationReturnCode, @ChangeApplied = ChangeApplied, @UserFlockPlanChangesID = UserFlockPlanChangesID
		from UserFlockPlanChanges 
		where FarmID = @FarmID and StartDate = @Planned24WeekDate and EndDate = @PlannedEndDate

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
		--ActualHatchDate, PlannedHatchDate, PulletFacility_RemoveDate, PulletFacility_WashDownDate, PulletFacility_LitterDate, PulletFacility_FumigationDate, 
		--ProductionFarm_RemoveDate, ProductionFarm_WashDownDate, ProductionFarm_LitterDate, ProductionFarm_FumigationDate)
		select @PulletFarmPlanID, @FarmID, @Planned24WeekDate, @Planned24WeekDate, @PlannedEndDate, @UserMessage, @ReturnCode, @ContractTypeID
		--@ActualHatchDate, @PlannedHatchDate, @PulletFacility_RemoveDate, @PulletFacility_WashDownDate, @PulletFacility_LitterDate, @PulletFacility_FumigationDate, 
		--@ProductionFarm_RemoveDate, @ProductionFarm_WashDownDate, @ProductionFarm_LitterDate, @ProductionFarm_FumigationDate

		select @UserFlockPlanChangesID = SCOPE_IDENTITY()

		if @ReturnCode = 0
		begin
			select @RunInsertUpdate = 1, @ChangeApplied = 0
		end
	end
end
else
begin
	-- The overall plan date range is not changing
	select @RunInsertUpdate = 1, 
		@ChangeApplied = 0, 
		@ReturnCode = 10
end

if @RunInsertUpdate = 1
begin
	if @ChangeApplied = 0
	begin
		declare @O_iErrorState int=0,				  
		@oErrString varchar(255)='',
		@iRowID varchar(255)=NULL

		exec FlockPlanDates_InsertUpdate 
			@I_vPulletFarmPlanID = @PulletFarmPlanID,
			@I_vPlannedHatchDate = @PlannedHatchDate,
			@I_vActualHatchDate = @ActualHatchDate,
			@I_vPulletFacility_RemoveDate = @PulletFacility_RemoveDate, 
			@I_vPulletFacility_WashDownDate = @PulletFacility_WashDownDate, 
			@I_vPulletFacility_LitterDate = @PulletFacility_LitterDate, 
			@I_vPulletFacility_FumigationDate = @PulletFacility_FumigationDate, 
			@I_vProductionFarm_RemoveDate = @ProductionFarm_RemoveDate, 
			@I_vProductionFarm_WashDownDate = @ProductionFarm_WashDownDate, 
			@I_vProductionFarm_LitterDate = @ProductionFarm_LitterDate, 
			@I_vProductionFarm_FumigationDate = @ProductionFarm_FumigationDate,
			@O_iErrorState = @O_iErrorState OUTPUT, @oErrString = @oErrString OUTPUT, @iRowID = @iRowID OUTPUT

			update UserFlockPlanChanges set ChangeApplied = 1 
			where FarmID = @FarmID and StartDate = @Planned24WeekDate and EndDate = @PlannedEndDate
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
