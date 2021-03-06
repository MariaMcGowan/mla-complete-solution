USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ValidateNewFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ValidateNewFlock]
GO
/****** Object:  UserDefinedFunction [dbo].[ValidateNewFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ValidateNewFlock]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[ValidateNewFlock] (@FarmID int, @StartDate date, @EndDate date, @IgnorePulletFarmPlanID int, @ContractTypeID int)
Returns
@Results TABLE 
(
	-- Add the column definitions for the TABLE variable here
	ReturnCode int,
	Conflict24WeekDate date,
	ConflictStartDate date,
	ConflictEndDate date,
	ShowMessage bit,
	Overridable bit
)
as
begin
	declare @ReturnCode int

	-- @ReturnCode
	--		  0 = No conflict, there is enough time between flocks
	--		 10 = Does not leave enough time between planned flock and this new flock
	--		 20 = Does not leave enough time between actual flock and this new flock
	--		-10 = This is in the middle of a planned flock, cannot schedule it!!!
	--		-20 = This is in the middle of an actual flock, cannot schedule it!!!
	--		-30 = This flock is in the middle of production, it cannot be moved!
	--		-40 = Missing flock dates

	declare 
		@Conflict24WeekDate date,
		@ConflictStartDate date,
		@ConflictEndDate date,
		@FarmNumber varchar(10),
		@Overridable bit,
		@ShowMessage bit,
		@MinDaysBetweenFlock int,
		@ConflictPulletFarmPlanID int, 
		@ConflictType varchar(20)

	select @MinDaysBetweenFlock  = ConstantValue
	from SystemConstant
	where ConstantName = ''Minimum day count between flocks''

	select @ShowMessage = 0,
		@ReturnCode = 0

	-- Bare minimum, does the flock have a start date and an end date?
	if @StartDate is null or @EndDate is null
	begin
		-- This flock can''t be moved, because it doesn''t have dates!
		select @ReturnCode = -40,
			@ShowMessage = 1, 
			@Overridable = 0, 
			@ConflictPulletFarmPlanID = @IgnorePulletFarmPlanID,
			@ConflictType = ''Actual''
	end
	else
	begin
		-- Check the existing pullet to see if it can be moved
		if exists 
		(
			select 1
			from RollingWeeklySchedule
			where PulletFarmPlanID = @IgnorePulletFarmPlanID
			and getdate() between FlockStartDate and FlockEndDate 
			and ContractTypeID = @ContractTypeID
		)
		begin
			-- This flock can''t be moved, it is in the middle of production!
			select @ReturnCode = -30,
				@ShowMessage = 1, 
				@Overridable = 0, 
				@ConflictPulletFarmPlanID = @IgnorePulletFarmPlanID,
				@ConflictType = ''Actual''
		end
		else
		begin

			--StartA <= EndB) and (EndA >= StartB)
			-- Check Farm to see if this plan overlaps with any existing flocks
			if exists 
			(
				select 1 
				from RollingWeeklySchedule rws 
				--inner join PulletFarmPlan pfp on rws.PulletFarmPlanID = pfp.PulletFarmPlanID
				where FarmID = @FarmID
				and rws.PulletFarmPlanID <> @IgnorePulletFarmPlanID
				and WeekEndingDate between FlockStartDate and FlockEndDate 
				and WeekEndingDate between dateadd(day,-1 * @MinDaysBetweenFlock, @StartDate) and dateadd(day,@MinDaysBetweenFlock,@EndDate)
				and ContractTypeID = @ContractTypeID
			)
			begin
				select @ShowMessage = 1
				select @FarmNumber = farmnumber from Farm where FarmID = @FarmID

				-- There''s overlap, how bad is it?
				if exists 
				(
					select 1 
					from RollingWeeklySchedule rws 
					--inner join PulletFarmPlan pfp on rws.PulletFarmPlanID = pfp.PulletFarmPlanID
					where FarmID = @FarmID
					and rws.PulletFarmPlanID <> @IgnorePulletFarmPlanID
					and WeekEndingDate between FlockStartDate and FlockEndDate 
					and WeekEndingDate between @StartDate and @EndDate
					and ContractTypeID = @ContractTypeID
				)
				begin
					select top 1 @ConflictPulletFarmPlanID = rws.PulletFarmPlanID, @ConflictType = rws.UseSourceType
					from RollingWeeklySchedule rws 
					--inner join PulletFarmPlan pfp on rws.PulletFarmPlanID = pfp.PulletFarmPlanID
					where FarmID = @FarmID
					and rws.PulletFarmPlanID <> @IgnorePulletFarmPlanID
					and WeekEndingDate between @StartDate and @EndDate
					and WeekEndingDate between FlockStartDate and FlockEndDate 
					and ContractTypeID = @ContractTypeID

					-- It is truly overlapping!
					select @Overridable = 0, 
						@ReturnCode = 
							case
								when @ConflictType = ''Planned'' then -10
								else -20
							end
				end
				else
				begin
					select top 1 @ConflictPulletFarmPlanID = rws.PulletFarmPlanID, @ConflictType = rws.UseSourceType
					from RollingWeeklySchedule rws 
					--inner join PulletFarmPlan pfp on rws.PulletFarmPlanID = pfp.PulletFarmPlanID
					where FarmID = @FarmID
					and rws.PulletFarmPlanID <> @IgnorePulletFarmPlanID
					and WeekEndingDate between FlockStartDate and FlockEndDate 
					and WeekEndingDate between dateadd(day,-1 * @MinDaysBetweenFlock, @StartDate) and dateadd(day,@MinDaysBetweenFlock,@EndDate)
					and ContractTypeID = @ContractTypeID
				
					-- it isnt truly overlapping, just not leaving the minimum required days between flocks
					select @Overridable = 1, 
						@ReturnCode = 
							case
								when @ConflictType = ''Planned'' then 10
								else 20
							end
				end
			end
		end
	end


	if @ConflictPulletFarmPlanID is not null
	begin
		select 
			@Conflict24WeekDate = 
				case
					when @ConflictType = ''Planned'' then Planned24WeekDate
					else Actual24WeekDate
				end, 
			@ConflictStartDate = 
				case
					when @ConflictType = ''Planned'' then isnull(PlannedStartDate, Planned24WeekDate)
					else isnull(ActualStartDate, Actual24WeekDate)
				end, 
			@ConflictEndDate = 
				case
					when @ConflictType = ''Planned'' then isnull(PlannedEndDate, Planned65WeekDate)
					else isnull(ActualEndDate, Actual65WeekDate)
				end
		from PulletFarmPlan
		where PulletFarmPlanID = @ConflictPulletFarmPlanID
	end
	
	insert into @Results(ReturnCode, Conflict24WeekDate, ConflictStartDate, ConflictEndDate, ShowMessage, Overridable)
	select @ReturnCode, @Conflict24WeekDate, @ConflictStartDate, @ConflictEndDate, @ShowMessage, @Overridable

	return
end
' 
END

GO
