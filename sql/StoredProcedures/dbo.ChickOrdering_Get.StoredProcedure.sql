USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ChickOrdering_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ChickOrdering_Get]
GO
/****** Object:  StoredProcedure [dbo].[ChickOrdering_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChickOrdering_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ChickOrdering_Get] AS' 
END
GO



ALTER proc [dbo].[ChickOrdering_Get]  
	@FlockCode varchar(10) = null,
	@FarmID int = null,
	@PulletFacilityID int = null,
	@PlanningStartDate date = null, 
	@PlanningEndDate date = null,
	@ContractTypeID int = null
		
As  

declare @DateRange table (Date date index idxDate clustered)

select @FarmID = nullif(nullif(@FarmID, ''),0),
	@PulletFacilityID = nullif(nullif(@PulletFacilityID, ''),0),
	@FlockCode = nullif(@FlockCode, ''),
	@ContractTypeID = nullif(@ContractTypeID, '')

select @PlanningStartDate = isnull(nullif(@PlanningStartDate, ''), '01/01/1999')
select @PlanningEndDate = isnull(nullif(@PlanningEndDate, ''), '01/01/2999')

select PulletFarmPlanID, FlockNumber = f.FarmNumber, PulletFacilityID, ActualHatchDate, PlannedHatchDate, 
FemaleBreed, 
PlannedFemaleOrder = convert(int,round(PulletQtyAt16Weeks / ExpectedLivabilityRatio,0)),
ActualFemaleOrderQty = 
	case
		when ActualFemaleOrderQty is null then dbo.RoundUpToNearestN(convert(int,round(PulletQtyAt16Weeks / ExpectedLivabilityRatio,0)),500)
		else ActualFemaleOrderQty
	end,
MaleBreed, 
PlannedMaleOrder = convert(int, round(PulletQtyAt16Weeks * MaleToFemaleBirdRatio / ExpectedLivabilityRatio,0)),
ActualMaleOrderQty = 
	case	
		when ActualMaleOrderQty is null then dbo.RoundUpToNearestN(convert(int, round(PulletQtyAt16Weeks * MaleToFemaleBirdRatio / ExpectedLivabilityRatio,0)),100)
		else ActualMaleOrderQty
	end,
PulletQtyAt16Weeks, Planned24WeekDate,
FarmName = 
	case
		when pfp.ContractTypeID = 4 then Destination 
		else Farm + ' - ' + cast(FarmNumber as varchar)
	end,
DynamicFormatting = 
	case
		when abs(datediff(day,ActualHatchDate, PlannedHatchDate)) >= 10 then 'DateWarning'
		else ''
	end,
Vaccine,
Actual24WeekDate,
ContractType,
Delete_PulletFarmPlanID = 
	case
		when pfp.ContractTypeID = 4 then PulletFarmPlanID
		else null
	end
from PulletFarmPlan pfp
left outer join Farm f on pfp.FarmID = f.FarmID
left outer join ContractType ct on isnull(pfp.ContractTypeID,1) = ct.ContractTypeID

where NOT
	(
		coalesce(ActualHatchDate, PlannedHatchDate,getdate()) > @PlanningEndDate
		or
		coalesce(Actual24WeekDate, Planned24WeekDate,getdate()) < @PlanningStartDate
	)
and isnull(pfp.FarmID,0) = coalesce(@FarmID, pfp.FarmID,0)
and isnull(pfp.PulletFacilityID,0) = isnull(@PulletFacilityID, isnull(pfp.PulletFacilityID,0))
and isnull(pfp.FlockNumber, 'X') = isnull(@FlockCode, isnull(pfp.FlockNumber, 'X'))
and pfp.ContractTypeID = isnull(@ContractTypeID, pfp.ContractTypeID)
order by Planned24WeekDate, pfp.FarmID



GO
