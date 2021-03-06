USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlan_ConfirmPlanChange]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlan_ConfirmPlanChange]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlan_ConfirmPlanChange]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan_ConfirmPlanChange]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlan_ConfirmPlanChange] AS' 
END
GO



ALTER proc [dbo].[PulletFarmPlan_ConfirmPlanChange]
	@UserFlockPlanChangesID int
as

declare @FarmNumber int,
	@PulletQtyAt16Weeks int, 
	@UserMessage varchar(500), 
	@FarmID int,
	@Planned24WeekDate date,
	@Planned65WeekDate date,
	@PlannedStartDate date,
	@PlannedEndDate date,
	@PulletFarmPlanID int,
	@ContractTypeID int,
	@ConservativeFactor numeric(8,6)


select @FarmID = FarmID, @PulletFarmPlanID = PulletFarmPlanID, 
@Planned24WeekDate = Planned24WeekDate,
@PlannedStartDate = StartDate, 
@PlannedEndDate = EndDate,
@ContractTypeID = ContractTypeID
from UserFlockPlanChanges 
where UserFlockPlanChangesID = @UserFlockPlanChangesID

select @ConservativeFactor = ConservativeFactor from PulletFarmPlan where PulletFarmPlanID = @PulletFarmPlanID

select @FarmID = nullif(@FarmID, ''), 
	@PulletFarmPlanID = isnull(nullif(@PulletFarmPlanID, ''), 0)

if @FarmID is null
begin
	select @FarmID = FarmID from PulletFarmPlan where PulletFarmPlanID = @PulletFarmPlanID
end

select @FarmNumber = FarmNumber from Farm where FarmID = @FarmID

select @UserMessage = UserMessage
from UserFlockPlanChanges
where FarmID = @FarmID and StartDate = @Planned24WeekDate and EndDate = @PlannedEndDate

if isnull(@UserMessage , '') = ''
begin
	select @UserMessage = 'Just click save.'
end

select @Planned65WeekDate = dateadd(week, 41, @Planned24WeekDate)

select 
	BlankFieldForSpace = '',
	FarmID = @FarmID,
	UserMessage = @UserMessage,
	PulletFarmPlanID = @PulletFarmPlanID,
	FarmNumber = @FarmNumber, 
	PulletQtyAt16Weeks = @PulletQtyAt16Weeks,
	Planned24WeekDate = @Planned24WeekDate,
	PlannedStartDate = @Planned24WeekDate,
	PlannedEndDate = @PlannedEndDate, 
	Planned65WeekDate = @Planned65WeekDate,
	Actual24WeekDate = convert(date, null),
	ActualStartDate = convert(date, null),
	ActualEndDate = convert(date, null), 
	Actual65WeekDate = convert(date, null),
	ContractTypeID = @ContractTypeID,
	ConservativeFactor = @ConservativeFactor


GO
