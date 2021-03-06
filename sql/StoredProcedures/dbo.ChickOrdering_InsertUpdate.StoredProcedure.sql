USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ChickOrdering_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ChickOrdering_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[ChickOrdering_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChickOrdering_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ChickOrdering_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[ChickOrdering_InsertUpdate] 
@I_vPulletFarmPlanID int,
@I_vPulletFacilityID int = null,
@I_vActualHatchDate date = null,
@I_vFemaleBreed varchar(20) = null,
@I_vMaleBreed varchar(20) = null,
@I_vActualFemaleOrderQty int = null,
@I_vActualMaleOrderQty int = null,
@I_vVaccine bit = null,
@O_iErrorState int=0 output,				  
@oErrString varchar(255)='' output,
@iRowID varchar(255)=NULL output  


As   

declare @PulletFarmPlanID int,
	@OrigActualHatchDate date,
	@OrigActualFemaleOrderQty int,
	@OrigActualMaleOrderQty int,
	@ContractTypeID int 

select @PulletFarmPlanID = PulletFarmPlanID,
	@OrigActualHatchDate = ActualHatchDate,
	@OrigActualFemaleOrderQty = ActualFemaleOrderQty,
	@OrigActualMaleOrderQty = ActualMaleOrderQty, 
	@ContractTypeID = ContractTypeID
from PulletFarmPlan 
where PulletFarmPlanID = @I_vPulletFarmPlanID


update pfp set 
	PulletFacilityID = @I_vPulletFacilityID,
	Actual24WeekDate = dateadd(week,24,@I_vActualHatchDate),
	FemaleBreed = @I_vFemaleBreed,
	MaleBreed = @I_vMaleBreed,
	FlockNumber = 
		case
			when @ContractTypeID = 4 then 'M' + right(REPLICATE('0', 6) + convert(varchar(6), @I_vPulletFarmPlanID), 6)
			when @I_vActualHatchDate is null then 'M' + convert(varchar(10), FarmNumber) + '-' + right('00' + convert(varchar(2),datepart(wk, coalesce(ActualHatchDate, PlannedHatchDate))), 2) + '-' + right(convert(varchar(4),datepart(year,coalesce(ActualHatchDate, PlannedHatchDate))),2)
			else 'M' + convert(varchar(10), FarmNumber) + '-' + right('00' + convert(varchar(2),datepart(wk, @I_vActualHatchDate)), 2) + '-' + right(convert(varchar(4),datepart(year,@I_vActualHatchDate)),2)
		end,
	ActualFemaleOrderQty = @I_vActualFemaleOrderQty,
	ActualMaleOrderQty = @I_vActualMaleOrderQty,
	Vaccine = @I_vVaccine
from PulletFarmPlan pfp
left outer join Farm f on pfp.FarmID = f.FarmID
where PulletFarmPlanID = @I_vPulletFarmPlanID

if @OrigActualHatchDate <> @I_vActualHatchDate
		or @OrigActualFemaleOrderQty <> @I_vActualFemaleOrderQty
		or @OrigActualMaleOrderQty <> @I_vActualMaleOrderQty
begin	
	declare
		@Actual24WeekDate date 

	select @Actual24WeekDate = dateadd(week,24,@I_vActualHatchDate)

	
	execute PulletFarmPlan_Form_UpdateActuals_InsertUpdate
		@I_vPulletFarmPlanID = @PulletFarmPlanID
		, @I_vActual24WeekDate = @Actual24WeekDate
		, @O_iErrorState = @O_iErrorState
		, @oErrString = @oErrString
		, @iRowID = @iRowID
		



end



GO
