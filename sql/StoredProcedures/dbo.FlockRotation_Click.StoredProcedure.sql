
/****** Object:  StoredProcedure [dbo].[FlockRotation_Click]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockRotation_Click]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_Click]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockRotation_Click]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockRotation_Click] AS' 
END
GO



ALTER proc [dbo].[FlockRotation_Click]
	  @PulletFarmPlanID int = null
	, @FarmID int = null
	, @WeekEndingDate date = null
	, @ContractTypeID int

as

--declare  @PulletFarmPlanID int = null
--	, @FarmID int = null
--	, @WeekEndingDate date = null
--	, @ContractTypeID int

--	select  @PulletFarmPlanID =0,
--	@FarmID = 32, 
--	@WeekEndingDate = '11/16/2019', 
--	@ContractTypeID = 1

select @PulletFarmPlanID = isnull(nullif(@PulletFarmPlanID, ''),0)
	, @WeekEndingDate = nullif(@WeekEndingDate, '')
	, @FarmID = nullif(@FarmID, '')
	, @ContractTypeID = nullif(@ContractTypeID, '')

	
declare
	@StartDate date,
	@EndDate date,
	@IgnorePulletFarmPlanID int, 
	@ReturnCode int, 
	@Conflict24WeekDate date, 
	@ConflictEndDate date, 
	@ShowMessage bit, 
	@Overridable bit,
	@MoveWeekCount int,
	@OrigStartDate date,
	@OrigEndDate date,
	@UserMessage varchar(500),
	@UserMessageID int, 
	@FlockInProcess bit = 0,
	@UserFlockPlanChangesID int,
	@RunValidation bit = 0



-- Is this new planned flock?
if @PulletFarmPlanID = 0 
begin
	select @IgnorePulletFarmPlanID = 0, @RunValidation = 1
end
else
begin	
	-- Is this flock currently in production?
	select @StartDate = coalesce(ActualStartDate, Actual24WeekDate, PlannedStartDate, Planned24WeekDate)
	from PulletFarmPlan 
	where PulletFarmPlanID = @PulletFarmPlanID

	if getdate() > @StartDate
	begin
		-- Could be updating planned or actual
		select @ReturnCode = 777, @UserFlockPlanChangesID = @PulletFarmPlanID
	end
	else
	begin
		-- This is an edit to an existing flock plan
		if exists (select 1 from PulletFarmPlan where PulletFarmPlanID = @PulletFarmPlanID and Actual24WeekDate is null)
		begin
			-- Could be updating planned or actual
			select @ReturnCode = 888, @UserFlockPlanChangesID = @PulletFarmPlanID
		end
		else 
		begin
			-- Update to actuals
			select @ReturnCode = 999, @UserFlockPlanChangesID = @PulletFarmPlanID
		end
	end
end

if @RunValidation = 1
begin
	select 
		@StartDate = @WeekEndingDate,
		@EndDate = dateadd(week, 41, @WeekEndingDate)

	declare @ValidateFlock table (ReturnCode int, Conflict24WeekDate date, ConflictStartDate date, ConflictEndDate date, ShowMessage bit, Overridable bit)

	insert into @ValidateFlock
	select *
	from dbo.ValidateNewFlock(@FarmID, @StartDate, @EndDate, @IgnorePulletFarmPlanID, @ContractTypeID)


	--select * from @ValidateFlock

	select top 1 
		@ReturnCode = ReturnCode,
		@Conflict24WeekDate = Conflict24WeekDate, 
		@ConflictEndDate = ConflictEndDate,
		@ShowMessage = ShowMessage,
		@Overridable = Overridable
	from @ValidateFlock

	select @UserMessage = 
			case @ReturnCode
				when 0 then null

				when 10 then 'This flock plan would not leave the minimum requested days between the flock planned for ' 
				+ convert(varchar, @Conflict24WeekDate, 101) + ' - ' 
				+ convert(varchar, @ConflictEndDate, 101) + ' and this new flock plan.  Please confirm.'
			
				when 20 then 'This flock plan would not leave the minimum requested days between the flock that has been order confirmed for ' 
				+ convert(varchar, @Conflict24WeekDate, 101) + ' - ' 
				+ convert(varchar, @ConflictEndDate, 101) + ' and this new flock plan.  Please confirm.'

				when -10 then 'This flock plan would interfere with the flock that has been planned for '
				+ convert(varchar, @Conflict24WeekDate, 101) + ' - ' 
				+ convert(varchar, @ConflictEndDate, 101) + '.'

				when -20 then 'This flock plan would interfere with the flock that has been order confirmed for '
				+ convert(varchar, @Conflict24WeekDate, 101) + ' - ' 
				+ convert(varchar, @ConflictEndDate, 101) + '.'

				when -30 then 'This flock is currently in production, it cannot be changed.' 

			end

	-- Log Flock Plan Change
	if exists (select 1 from UserFlockPlanChanges where FarmID = @FarmID and StartDate = @StartDate and EndDate = @EndDate and ContractTypeID = @ContractTypeID)
	begin
		select @UserFlockPlanChangesID = UserFlockPlanChangesID
		from UserFlockPlanChanges
		where FarmID = @FarmID and StartDate = @StartDate and EndDate = @EndDate and ContractTypeID = @ContractTypeID

		update UserFlockPlanChanges set UserMessage = @UserMessage, ValidationReturnCode = @ReturnCode
		where UserFlockPlanChangesID = @UserFlockPlanChangesID
	end
	else
	begin
		insert into UserFlockPlanChanges (PulletFarmPlanID, FarmID, Planned24WeekDate, StartDate, EndDate, UserMessage, ValidationReturnCode, ContractTypeID)
		select @PulletFarmPlanID, @FarmID, @StartDate, @StartDate, @EndDate, @UserMessage, @ReturnCode, @ContractTypeID

		select @UserFlockPlanChangesID = SCOPE_IDENTITY()
	end

end



select 

	UserFlockPlanChangesID = @UserFlockPlanChangesID
	, 
	referenceType = 
		case
			-- it is new
			when @ReturnCode = 0 then 'CreateNewFlock'

			-- it doesn't leave the minimum required amount of room, but user can override
			when @ReturnCode in (10, 20) then 'ConfirmNewFlock'

			-- This flock is currently in production
			when @ReturnCode = 777 then 'EditCurrentFlock'

			-- It is an edit, but not sure what they are editing
			when @ReturnCode = 888 then 'EditFutureFlock'

			-- this is an edit, but the flock already has actual dates, so can only update actuals
			when @ReturnCode = 999 then 'EditFutureFlockThatHasActuals'
			
			-- Straight up failures
			else 'Failed'

		end


GO
