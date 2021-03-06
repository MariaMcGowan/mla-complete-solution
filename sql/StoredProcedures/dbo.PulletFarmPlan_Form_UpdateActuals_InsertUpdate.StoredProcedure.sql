USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlan_Form_UpdateActuals_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlan_Form_UpdateActuals_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlan_Form_UpdateActuals_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan_Form_UpdateActuals_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlan_Form_UpdateActuals_InsertUpdate] AS' 
END
GO

ALTER proc [dbo].[PulletFarmPlan_Form_UpdateActuals_InsertUpdate]
	@I_vPulletFarmPlanID int
	, @I_vConservativeFactor float = null
	, @I_vPulletQtyAt16Weeks float = null
	, @I_vActual24WeekDate date = null
	, @I_vActualStartDate date = null
	, @I_vActualEndDate date = null
	, @O_iErrorState int=0 output   
	, @oErrString varchar(255)='' output   
	, @iRowID varchar(255)=NULL output  
As   

select 
	@I_vConservativeFactor = nullif(@I_vConservativeFactor,  '')
	, @I_vPulletQtyAt16Weeks = nullif(@I_vPulletQtyAt16Weeks, '')
	, @I_vActual24WeekDate = nullif(@I_vActual24WeekDate, '')
	, @I_vActualStartDate = nullif(@I_vActualStartDate, '')
	, @I_vActualEndDate = nullif(@I_vActualEndDate, '')

declare @ContractTypeID int
	, @OrigPulletQtyAt16Weeks int
	, @PulletQtyChanged bit = 0
	, @Orig_Actual24WeekDate date
	, @Orig_ConservativeFactor float
	, @ConservativeFactorChanged bit = 0

select @ContractTypeID = ContractTypeID
	, @OrigPulletQtyAt16Weeks = PulletQtyAt16Weeks
	, @Orig_Actual24WeekDate = isnull(Actual24WeekDate, '01/01/1900')
	, @Orig_ConservativeFactor = ConservativeFactor
from PulletFarmPlan where PulletFarmPlanID = @I_vPulletFarmPlanID

-- Changed by MCM on 11/15/2019
select @I_vActualStartDate = 
	case
		when @Orig_Actual24WeekDate <> @I_vActual24WeekDate then @I_vActual24WeekDate
		else isnull(@I_vActualStartDate, @I_vActual24WeekDate)
	end,
	@I_vActualEndDate = 
	case
		when @Orig_Actual24WeekDate <> @I_vActual24WeekDate then dateadd(week, 41, @I_vActual24WeekDate)
		else @I_vActualEndDate
	end

if @I_vPulletQtyAt16Weeks <> @OrigPulletQtyAt16Weeks
begin
	select @PulletQtyChanged = 1
end

if @I_vConservativeFactor <> @Orig_ConservativeFactor
begin
	select @ConservativeFactorChanged = 1
end

update PulletFarmPlan set 
	ConservativeFactor = isnull(@I_vConservativeFactor, ConservativeFactor)
	, PulletQtyAt16Weeks = isnull(@I_vPulletQtyAt16Weeks, PulletQtyAt16Weeks)
	, Actual24WeekDate = isnull(@I_vActual24WeekDate, Actual24WeekDate)
	, ActualStartDate = isnull(@I_vActualStartDate, ActualStartDate)
	, ActualEndDate = isnull(@I_vActualEndDate, ActualEndDate)
	--, PlannedOrActual = 'A'
where PulletFarmPlanID = @I_vPulletFarmPlanID


-- Update the details! - but not for Pullet Only!!!!
if @ContractTypeID <> 4	-- Pullet Only
begin
	execute.PulletFarmPlanDetail_InsertUpdate @PulletFarmPlanID = @I_vPulletFarmPlanID, @PulletQtyChanged = @PulletQtyChanged, @ConservativeFactorChanged = @ConservativeFactorChanged

	-- Update Commercial Plans!
	execute CommercialCommitment_UpdateDetail @PulletFarmPlanID = @I_vPulletFarmPlanID
end





GO
