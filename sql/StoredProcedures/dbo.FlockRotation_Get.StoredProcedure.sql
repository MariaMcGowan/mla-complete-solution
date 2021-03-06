USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockRotation_Get]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockRotation_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockRotation_Get] AS' 
END
GO



ALTER proc [dbo].[FlockRotation_Get] @UserID varchar(255), 
@ShowEmbryoOrPulletQtyID varchar(10) = null,
@PlanningStartDate date = null, 
@PlanningEndDate date = null,
@ContractTypeID int = null

as


select @ShowEmbryoOrPulletQtyID = isnull(nullif(@ShowEmbryoOrPulletQtyID, ''), 'Embryo'),
	@PlanningStartDate = isnull(nullif(@PlanningStartDate, ''), convert(date, getdate()))

select @PlanningEndDate = isnull(nullif(@PlanningEndDate, ''), dateadd(year,2,@PlanningStartDate))

-- Make sure that all of the active farms are visible
if exists 
(
	select 1
	from RollingDailySchedule rds
	where rds.Date between @PlanningStartDate and @PlanningEndDate
		and rds.SellableEggs > 0
		and rds.ContractTypeID = @ContractTypeID
		and not exists (select 1 from UserPlanningFarmList where FarmID = rds.FarmID and ContractTypeID = rds.ContractTypeID and UserID = @UserID)
)
begin
	insert into UserPlanningFarmList (UserID, ContractTypeID, FarmID)
	select @UserID, @ContractTypeID, FarmID
	from RollingDailySchedule rds
	where rds.Date between @PlanningStartDate and @PlanningEndDate
		and rds.SellableEggs > 0
		and rds.ContractTypeID = @ContractTypeID
		and not exists (select 1 from UserPlanningFarmList where FarmID = rds.FarmID and ContractTypeID = rds.ContractTypeID and UserID = @UserID)
	group by FarmID

end

if @ContractTypeID = (select ContractTypeID from ContractType where ContractType = 'Commercial')
begin
	if upper(left(@ShowEmbryoOrPulletQtyID,1)) = 'E'
	begin
	execute GetPlannedEmbryoSchedule_ForCommercialContracts @UserID = @UserID, @StartDate = @PlanningStartDate, @EndDate = @PlanningEndDate, @ContractTypeID = @ContractTypeID
	end
	else
	begin
		execute GetPlannedPulletSchedule_ForCommercialContracts @UserID = @UserID, @StartDate = @PlanningStartDate, @EndDate = @PlanningEndDate, @ContractTypeID = @ContractTypeID
	end
end
else
begin
	if upper(left(@ShowEmbryoOrPulletQtyID,1)) = 'E'
	begin
		execute GetPlannedEmbryoSchedule @UserID = @UserID, @StartDate = @PlanningStartDate, @EndDate = @PlanningEndDate, @ContractTypeID = @ContractTypeID
	end
	else
	begin
		execute GetPlannedPulletSchedule @UserID = @UserID, @StartDate = @PlanningStartDate, @EndDate = @PlanningEndDate, @ContractTypeID = @ContractTypeID
	end
end


GO
