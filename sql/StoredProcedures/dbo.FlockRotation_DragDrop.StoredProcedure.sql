USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_DragDrop]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockRotation_DragDrop]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_DragDrop]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockRotation_DragDrop]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockRotation_DragDrop] AS' 
END
GO



ALTER proc [dbo].[FlockRotation_DragDrop]	
	  @origPulletFarmPlanID int = null
	, @FarmID int = null
	, @origWeekEndingDate date = null
	, @targetWeekEndingDate date = null
	, @ContractTypeID int

as

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
	@PlannedOrActual varchar(1) = 'P'


select @origPulletFarmPlanID = nullif(@origPulletFarmPlanID, '')
	, @origWeekEndingDate = nullif(@origWeekEndingDate, '')
	, @targetWeekEndingDate = nullif(@targetWeekEndingDate, '')
	, @FarmID = nullif(@FarmID, '')
	, @ContractTypeID = nullif(@ContractTypeID, '')


-- Is this a new planned flock?
-- Note - it can't be a new flock!
if isnull(@origPulletFarmPlanID,0) = 0
begin
	select 
		@StartDate = @targetWeekEndingDate,
		@IgnorePulletFarmPlanID = 0,
		@EndDate = dateadd(week, 41, @targetWeekEndingDate)
end
else
begin
	-- Let's move the flock START DATE the number of weeks down that the user dragged the flock
	-- The end date should be overwritten to be the adjusted 65 week date
	select @OrigStartDate =
		case
			when ActualHatchDate is null then isnull(PlannedStartDate, Planned24WeekDate)
			else isnull(ActualStartDate, Actual24WeekDate)
		end,
		@OrigEndDate =
		case
			when ActualHatchDate is null then coalesce(PlannedEndDate, Planned65WeekDate)
			else coalesce(ActualEndDate, Actual65WeekDate)
		end,
		@PlannedOrActual =
		case
			when ActualHatchDate is null then 'P'
			else 'A'
		end
	from PulletFarmPlan
	where PulletFarmPlanID = @origPulletFarmPlanID

	select @MoveWeekCount = datediff(week,@origWeekEndingDate,@targetWeekEndingDate)
	select @StartDate = dateadd(week, @MoveWeekCount, @OrigStartDate),
		--@EndDate = dateadd(week, @MoveWeekCount, @OrigEndDate),
		@IgnorePulletFarmPlanID = @origPulletFarmPlanID
	
	-- Overwriting the end date
	select @EndDate = dateadd(week,41,@StartDate);
end



declare @ValidateFlock table (ReturnCode int, Conflict24WeekDate date, ConflictStartDate date, ConflictEndDate date, ShowMessage bit, Overridable bit)

insert into @ValidateFlock
select *
from dbo.ValidateNewFlock(@FarmID, @StartDate, @EndDate, @IgnorePulletFarmPlanID, @ContractTypeID)

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
	select @origPulletFarmPlanID, @FarmID, @StartDate, @StartDate, @EndDate, @UserMessage, @ReturnCode, @ContractTypeID

	select @UserFlockPlanChangesID = SCOPE_IDENTITY()
end

select 
	--FarmID = @FarmID,
	--Planned24WeekDate = @StartDate,
	--PlannedEndDate = @EndDate,
	----Planned65WeekDate = dateadd(week, 41, @StartDate),
	--PulletFarmPlanID = isnull(@origPulletFarmPlanID,0),

	--Original_Planned24WeekDate = @OrigStartDate,
	--Original_PlannedEndDate = @OrigEndDate,
	UserFlockPlanChangesID = @UserFlockPlanChangesID,
	referenceType = 
		case 
			-- Straight up failures
			when @ReturnCode < 0 then 'Failed'
			-- Is it an update?
			when @IgnorePulletFarmPlanID > 0 and @PlannedOrActual = 'A' then 'EditFlockWithActuals'
			
			when @IgnorePulletFarmPlanID > 0 and @PlannedOrActual = 'P' then 'EditFlock'

			-- Nope, it is new
			when @ReturnCode = 0 then 'CreateNewFlock'
			when @ReturnCode in (10, 20) then 'ConfirmNewFlock'
		end



GO
