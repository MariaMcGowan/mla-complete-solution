USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletOnlyFlock_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletOnlyFlock_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[PulletOnlyFlock_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletOnlyFlock_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletOnlyFlock_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[PulletOnlyFlock_InsertUpdate]
	@I_vPulletFarmPlanID int
	, @I_vPulletQtyAt16Weeks int = null
	, @I_vPlannedHatchDate date=null
	, @I_vActualHatchDate date =null
	, @I_vDestination varchar(100)=null
	, @I_vPulletFacilityID int = null
	, @I_vFemaleBreed varchar(20) = null
	, @I_vMaleBreed varchar(20) = null
	, @I_vPlannedMaleOrderQty int = null
	, @O_iErrorState int=0 output
	, @oErrString varchar(255)='' output
	, @iRowID varchar(255)=NULL output
AS

declare @Actual24WeekDate date,
	@ActualStartDate date,
	@ActualEndDate date,
	@Planned24WeekDate date,
	@PlannedStartDate date,
	@PlannedEndDate date,
	@MaleToFemaleBirdRatio numeric(8,6),
	@ExpectedLivabilityRatio numeric(8,6)

	select @ExpectedLivabilityRatio = ConstantValue
	from SystemConstant
	where ConstantName like 'Expected Livability Ratio%'

	select @MaleToFemaleBirdRatio = ConstantValue
	from SystemConstant
	where ConstantName like 'Male to Female Bird Ratio%'

select @I_vActualHatchDate = nullif(@I_vActualHatchDate, ''), 
	@I_vDestination = nullif(@I_vDestination, ''), 
	@I_vFemaleBreed = nullif(@I_vFemaleBreed, ''), 
	@I_vMaleBreed = nullif(@I_vMaleBreed, ''), 
	@I_vPlannedMaleOrderQty = nullif(@I_vPlannedMaleOrderQty, '')

if @I_vActualHatchDate is not null
begin
	select @Actual24WeekDate = dateadd(week, 24, @I_vActualHatchDate)
	select @ActualStartDate = @Actual24WeekDate,
		@ActualEndDate = dateadd(week, 65, @I_vActualHatchDate)
end
else
begin
	select @Planned24WeekDate = dateadd(week, 24, @I_vPlannedHatchDate)
	select @PlannedStartDate = @Planned24WeekDate,
		@PlannedEndDate = dateadd(week, 65, @I_vPlannedHatchDate)
end

if @I_vPulletFarmPlanID = 0
begin
	declare @PulletFarmPlanID table (PulletFarmPlanID int)
	insert into dbo.PulletFarmPlan (		
		PulletQtyAt16Weeks
		, Planned24WeekDate
		, PlannedStartDate
		, PlannedEndDate
		, Actual24WeekDate
		, ActualStartDate
		, ActualEndDate
		, Destination
		, ContractTypeID
		, ConservativeFactor
		, FemaleBreed
		, MaleBreed
		, ExpectedLivabilityRatio
		, MaleToFemaleBirdRatio
		, FlockNumber
				)
	output inserted.PulletFarmPlanID into @PulletFarmPlanID(PulletFarmPlanID)
	select	
		@I_vPulletQtyAt16Weeks
		, @Planned24WeekDate
		, @PlannedStartDate
		, @PlannedEndDate
		, @Actual24WeekDate
		, @ActualStartDate
		, @ActualEndDate
		, @I_vDestination
		, 4
		, 1
		, @I_vFemaleBreed
		, @I_vMaleBreed
		, @ExpectedLivabilityRatio
		, @MaleToFemaleBirdRatio
		, ''
		
	select top 1 @I_vPulletFarmPlanID = PulletFarmPlanID, @iRowID = PulletFarmPlanID from @PulletFarmPlanID

end
else
begin
	update dbo.PulletFarmPlan
	set		
		PulletQtyAt16Weeks = @I_vPulletQtyAt16Weeks
		, Planned24WeekDate = @Planned24WeekDate
		, PlannedStartDate = @PlannedStartDate
		, PlannedEndDate = @PlannedEndDate
		, Actual24WeekDate = @Actual24WeekDate
		, ActualStartDate = @ActualStartDate
		, ActualEndDate = @ActualEndDate
		, Destination = @I_vDestination
		, PulletFacilityID = @I_vPulletFacilityID
		, FemaleBreed = @I_vFemaleBreed
		, MaleBreed = @I_vMaleBreed
		, ExpectedLivabilityRatio = @ExpectedLivabilityRatio
		, MaleToFemaleBirdRatio = @MaleToFemaleBirdRatio
	where @I_vPulletFarmPlanID = PulletFarmPlanID

	select @iRowID = @I_vPulletFarmPlanID
end


select @I_vPulletFarmPlanID as ID,'forward' As referenceType


GO
