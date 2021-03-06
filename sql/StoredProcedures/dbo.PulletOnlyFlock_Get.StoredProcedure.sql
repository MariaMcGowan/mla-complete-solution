USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletOnlyFlock_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletOnlyFlock_Get]
GO
/****** Object:  StoredProcedure [dbo].[PulletOnlyFlock_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletOnlyFlock_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletOnlyFlock_Get] AS' 
END
GO



ALTER proc [dbo].[PulletOnlyFlock_Get] @PulletFarmPlanID int = null, @Destination varchar(100) = null
as

select @Destination = nullif(@Destination, ''), @PulletFarmPlanID = nullif(@PulletFarmPlanID, '')

select PulletFarmPlanID, PulletQtyAt16Weeks, 
Planned24WeekDate, PlannedHatchDate, Planned16WeekDate, Planned65WeekDate, PlannedStartDate, PlannedEndDate, 
Actual24WeekDate, ActualHatchDate, Actual16WeekDate, Actual65WeekDate, ActualStartDate, ActualEndDate, Destination, FlockNumber,
FemaleBreed, MaleBreed, PlannedMaleOrderQty, PlannedFemaleOrderQty,
ExpectedLivabilityRatio, MaleToFemaleBirdRatio
from PulletFarmPlan
where ContractTypeID = 4
and PulletFarmPlanID = isnull(@PulletFarmPlanID, PulletFarmPlanID)
and isnull(Destination, '') = coalesce(@Destination, Destination, '')
order by ActualHatchDate desc, Destination



GO
