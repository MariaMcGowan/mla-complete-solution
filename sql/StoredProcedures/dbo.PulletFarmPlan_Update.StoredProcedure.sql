USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlan_Update]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlan_Update]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlan_Update]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlan_Update] AS' 
END
GO



ALTER proc [dbo].[PulletFarmPlan_Update] 
	@I_vPulletFarmPlanID int, 
	@I_vPlanned24WeekDate date, 
	@I_vPlannedEndDate date,
	--@I_vPlanned65WeekDate date,
	@I_vPulletQtyAt16Weeks int,
	@O_iErrorState int=0 output,
	@oErrString varchar(255)='' output,
	@iRowID varchar(255)=NULL output  

As   

declare 
	@FarmID int,
	@Conflict24WeekDate date,
	@ConflictEndDate date,
	@FarmNumber varchar(10),
	@MinDaysBetweenFlock int,
	@ReturnCode int,
	@ShowMessage bit, 
	@Overridable bit,
	@ErrorMessage varchar(1000),
	@UserMessage varchar(500),
	@UserMessageID int,
	@OrigStartDate date,
	@OrigEndDate date,
	@StartDate date,
	@EndDate date
	
	
select @I_vPlanned24WeekDate = nullif(@I_vPlanned24WeekDate, ''), 
	@I_vPlannedEndDate = nullif(@I_vPlannedEndDate, '')
	--, 
	--@I_vPlanned65WeekDate = nullif(@I_vPlanned65WeekDate, '')

select @StartDate = @I_vPlanned24WeekDate, @EndDate = @EndDate


if @I_vPlanned24WeekDate is not null
begin
	if @EndDate is null
		select @EndDate = dateadd(week, 41, @I_vPlanned24WeekDate)

	--if @I_vPlanned65WeekDate is null
	--	select @I_vPlanned65WeekDate = dateadd(week, 41, @I_vPlanned24WeekDate)


	-- Was a message logged about this change?
	-- If so, the user received a message, and they are saving it anyway!
	if exists (select 1 from UserPlanningMessage where PulletFarmPlanID = @I_vPulletFarmPlanID and StartDate = @StartDate and EndDate = @EndDate)
	begin
		-- Update the return code so that it shows that the save can be processed
		-- without any other verification
		select @ReturnCode = 0

		-- Delete Message
		delete from UserPlanningMessage where PulletFarmPlanID = @I_vPulletFarmPlanID and StartDate = @StartDate and EndDate = @EndDate

	end
	else
	begin
		select @FarmID = FarmID, 
		@OrigStartDate = 
		case
			when Actual24WeekDate is null then Planned24WeekDate
			when ModifiedAfterOrderConfirm = 1 then Planned24WeekDate
			else Actual24WeekDate
		end, 
		@OrigEndDate = 
		case
			when Actual24WeekDate is null then isnull(PlannedEndDate, Planned65WeekDate)
			when ModifiedAfterOrderConfirm = 1 then isnull(PlannedEndDate, Planned65WeekDate)
			else isnull(ActualEndDate, Actual65WeekDate)
		end
		from PulletFarmPlan where PulletFarmPlanID = @I_vPulletFarmPlanID

		declare @ValidateFlock table (ReturnCode int, Conflict24WeekDate date, ConflictStartDate date, ConflictEndDate date, ShowMessage bit, Overridable bit)

		insert into @ValidateFlock
		select *
		from dbo.ValidateNewFlock(@FarmID, @StartDate, @EndDate, @I_vPulletFarmPlanID, 1)

		select top 1 
			@ReturnCode = ReturnCode,
			@Conflict24WeekDate = Conflict24WeekDate, 
			@ConflictEndDate = ConflictEndDate,
			@ShowMessage = ShowMessage,
			@Overridable = Overridable
		from @ValidateFlock
	end
end

else
begin
	-- No start date defined!
	select @ReturnCode = -999
end


if @ReturnCode = 0
begin
	-- Call Actual SAVE program
	execute PulletFarmPlan_InsertUpdate 
		@I_vFarmID = @FarmID,
		@I_vPlanned24WeekDate = @I_vPlanned24WeekDate,
		@I_vPlannedEndDate = @I_vPlannedEndDate,
		@I_vPulletFarmPlanID = @I_vPulletFarmPlanID,
		@I_vPulletQtyAt16Weeks = @I_vPulletQtyAt16Weeks,
		@O_iErrorState = @O_iErrorState, 
		@oErrString = @oErrString,
		@iRowID = @iRowID

end
else
begin
	select @UserMessage = 
		case @ReturnCode
			when 0 then 'Flock plan changes have been saved.'

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

			when -999 then 'The 24 week date was not defined.' 

		end
	insert into UserPlanningMessage (UserMessage, PulletFarmPlanID, StartDate, EndDate, PulletQtyAt16Weeks)
	select @UserMessage, @I_vPulletFarmPlanID, @StartDate, @EndDate, @I_vPulletQtyAt16Weeks
end


select @iRowID = @I_vPulletFarmPlanID  





GO
