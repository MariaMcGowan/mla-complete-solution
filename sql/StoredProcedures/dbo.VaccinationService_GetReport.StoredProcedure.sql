USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationService_GetReport]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[VaccinationService_GetReport]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationService_GetReport]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationService_GetReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VaccinationService_GetReport] AS' 
END
GO




ALTER proc [dbo].[VaccinationService_GetReport]  @VaccinationServiceID int
As    
select @VaccinationServiceID = nullif(@VaccinationServiceID, '')


select a.VaccinationServiceID
, Flock = FlockNumber
, f.FarmNumber
, HatchDate = coalesce(ActualHatchDate, PlannedHatchDate)
, Hatchery = f.FarmNumber
, PulletFacility = pf.PulletFacility
, LayerHouse = convert(varchar(20), null)
, Strain = FemaleBreed
, HenCount = ActualFemaleOrderQty
, Roosters = ActualMaleOrderQty
, ScheduleDate = dateadd(day,AgeInDays, coalesce(ActualHatchDate, PlannedHatchDate))
, AgeInDays
, Service
, Disease
, VaccineDeliveryMethod
, Supplier
, ProductName
, ProductSerialNumber
, Administrator
, DateCompleted = d.DateCompleted
, SignedOffBy
, d.VaccinationServiceDetailID
from VaccinationService a
inner join PulletFarmPlan pfp on a.FlockID = pfp.PulletFarmPlanID
inner join Farm f on pfp.FarmID = f.FarmID
inner join VaccinationServiceDetail d on a.VaccinationServiceID = d.VaccinationServiceID
left outer join PulletFacility pf on pfp.PulletFacilityID = pf.PulletFacilityID
where @VaccinationServiceID is not null
and a.VaccinationServiceID = @VaccinationServiceID
and d.IsActive = 1


GO
