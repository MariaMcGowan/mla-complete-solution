USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFacilityFlock_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFacilityFlock_Get]
GO
/****** Object:  StoredProcedure [dbo].[PulletFacilityFlock_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFacilityFlock_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFacilityFlock_Get] AS' 
END
GO




ALTER proc [dbo].[PulletFacilityFlock_Get]  @PulletFacilityID int = null  ,@IncludeNew bit = 1 
As

    select  
	 PulletFarmPlanID
	 , FarmID
	 , PulletQtyAt16Weeks
	 , Planned24WeekDate
	 , PlannedHatchDate
	 , Planned16WeekDate
	 , Planned65WeekDate
	 , ExpectedLivabilityRatio
	 , PlannedFemaleOrderQty
	 , MaleToFemaleBirdRatio
	 , PlannedMaleOrderQty
	 , ActualFemaleOrderQty
	 , ActualMaleOrderQty
	 , PulletFacilityID
	 , ActualHatchDate
	 , FlockNumber
	from PulletFarmPlan  where IsNull(@PulletFacilityID,PulletFacilityID) = PulletFacilityID  
	union all  select  
	 PulletFarmPlanID = convert(int,0)
	 , FarmID = convert(int,null)
	 , PulletQtyAt16Weeks = convert(int,null)
	 , Planned24WeekDate = convert(date,null)
	 , PlannedHatchDate = convert(date,null)
	 , Planned16WeekDate = convert(date,null)
	 , Planned65WeekDate = convert(date,null)
	 , ExpectedLivabilityRatio = convert(numeric(8,6),null)
	 , PlannedFemaleOrderQty = convert(numeric(19,0),null)
	 , MaleToFemaleBirdRatio = convert(numeric(8,6),null)
	 , PlannedMaleOrderQty = convert(numeric(28,0),null)
	 , ActualFemaleOrderQty = convert(int,null)
	 , ActualMaleOrderQty = convert(int,null)
	 , PulletFacilityID = convert(int,null)
	 , ActualHatchDate = convert(date,null)
	 , FlockNumber = convert(varchar(20),null)
	where @IncludeNew = 1 
	



GO
