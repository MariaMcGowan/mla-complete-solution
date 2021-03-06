USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[TestModifiedAfterOrderConfirmDates]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[TestModifiedAfterOrderConfirmDates]
GO
/****** Object:  UserDefinedFunction [dbo].[TestModifiedAfterOrderConfirmDates]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TestModifiedAfterOrderConfirmDates]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[TestModifiedAfterOrderConfirmDates]
(@PulletFarmPlanID int)
returns 
@FailedDates Table
(
	FieldName varchar(50)
)
as

begin

	declare @MaxPlannedToActual int = 10,
		@MaxPulletRemoval int = 10,
		@MaxProductionRemoval int = 10

	declare @NullDate date = ''01/01/1999''

	-- The planned hatch date must be within X days of the actual hatch date
	select @MaxPlannedToActual = ConstantValue
	from SystemConstant 
	where SystemConstantID = 8

	-- Each of the pullet facility removal dates must be within Y days of the planned 16 week date
	select @MaxPulletRemoval = ConstantValue
	from SystemConstant 
	where SystemConstantID = 9

	-- Each production facility removal dates must be within Z days of the planned 65 week date / Planned Commercial end date
	select @MaxProductionRemoval = ConstantValue
	from SystemConstant 
	where SystemConstantID = 7

	-- Check actual hatch date
	-- Note - this planned date can be up to X number of days before or after the actual date
	if exists (
					select 1 
					from PulletFarmPlan 
					where PulletFarmPlanID = @PulletFarmPlanID 
					and abs(datediff(day,Planned24WeekDate,Actual24WeekDate)) > @MaxPlannedToActual
				)
	begin
		insert into @FailedDates
		select ''Planned24WeekDate''
	end

	-- Check pullet facility removal dates
	-- Note - the removal dates must occur no more than X days AFTER the end date
	if not exists (
					select 1 
					from PulletFarmPlan 
					where PulletFarmPlanID = @PulletFarmPlanID and 
					datediff(day, isnull(Actual16WeekDate,Planned16WeekDate), isnull(PulletFacility_RemoveDate, @NullDate)) 
					between 1 and @MaxPulletRemoval
				)
	begin
		insert into @FailedDates
		select ''PulletFacility_RemoveDate''
	end



	if not exists (
					select 1 
					from PulletFarmPlan 
					where PulletFarmPlanID = @PulletFarmPlanID and 
					datediff(day, isnull(Actual16WeekDate,Planned16WeekDate), isnull(PulletFacility_WashDownDate, @NullDate)) between 1 and @MaxPulletRemoval
				)
	begin
		insert into @FailedDates
		select ''PulletFacility_WashDownDate''
	end


	if not exists (
					select 1 
					from PulletFarmPlan 
					where PulletFarmPlanID = @PulletFarmPlanID and 
					datediff(day, isnull(Actual16WeekDate,Planned16WeekDate), isnull(PulletFacility_LitterDate, @NullDate)) between 1 and @MaxPulletRemoval
				)
	begin
		insert into @FailedDates
		select ''PulletFacility_LitterDate''
	end

	if not exists (
					select 1 
					from PulletFarmPlan 
					where PulletFarmPlanID = @PulletFarmPlanID and 
					datediff(day, isnull(Actual16WeekDate,Planned16WeekDate), isnull(PulletFacility_FumigationDate, @NullDate)) between 1 and @MaxPulletRemoval
				)
	begin
		insert into @FailedDates
		select ''PulletFacility_FumigationDate''
	end
				

	-- Check production removal dates
	-- Note - the removal dates must occur no more than X days AFTER the end date
	if not exists (
					select 1 
					from PulletFarmPlan 
					where PulletFarmPlanID = @PulletFarmPlanID and 
					datediff(day, coalesce(ActualCommercialEndDate,PlannedCommercialEndDate, ActualEndDate, PlannedEndDate), isnull(ProductionFarm_RemoveDate, @NullDate)) between 1 and @MaxPulletRemoval
				)
	begin
		insert into @FailedDates
		select ''ProductionFarm_RemoveDate''
	end


	if not exists (
					select 1 
					from PulletFarmPlan pff
					where PulletFarmPlanID = @PulletFarmPlanID and 
					datediff(day, coalesce(ActualCommercialEndDate,PlannedCommercialEndDate, ActualEndDate, PlannedEndDate), isnull(ProductionFarm_WashDownDate, @NullDate)) between 1 and @MaxPulletRemoval
				)
	begin
		insert into @FailedDates
		select ''ProductionFarm_WashDownDate''
	end


	if not exists (
					select 1 
					from PulletFarmPlan
					where PulletFarmPlanID = @PulletFarmPlanID and 
					datediff(day, coalesce(ActualCommercialEndDate,PlannedCommercialEndDate, ActualEndDate, PlannedEndDate), isnull(ProductionFarm_LitterDate, @NullDate)) between 1 and @MaxPulletRemoval
				)
	begin
		insert into @FailedDates
		select ''ProductionFarm_LitterDate''
	end

	if not exists (
					select 1 
					from PulletFarmPlan
					where PulletFarmPlanID = @PulletFarmPlanID and 
					datediff(day, coalesce(ActualCommercialEndDate,PlannedCommercialEndDate, ActualEndDate, PlannedEndDate), isnull(ProductionFarm_FumigationDate, @NullDate)) between 1 and @MaxPulletRemoval
				)
	begin
		insert into @FailedDates
		select ''ProductionFarm_FumigationDate''
	end

	return

end' 
END

GO
