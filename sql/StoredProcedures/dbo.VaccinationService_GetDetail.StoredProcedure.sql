USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationService_GetDetail]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[VaccinationService_GetDetail]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationService_GetDetail]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationService_GetDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VaccinationService_GetDetail] AS' 
END
GO




ALTER proc [dbo].[VaccinationService_GetDetail]  @VaccinationServiceID int
As    


select fl.Flock, 
VaccinationServiceDetailID, d.VaccinationServiceID, AgeInDays = isnull(AgeInDays,1), 
Service, Disease, VaccineDeliveryMethod, Supplier, ProductName, ProductSerialNumber, Administrator, 
d.IsActive, d.SortOrder, DateCompleted, SignedOffBy, ScheduleDate = dateadd(day,isnull(d.AgeInDays,1)-1,fl.HatchDate), 
fl.HatchDate
from VaccinationService a
inner join VaccinationServiceDetail d on a.VaccinationServiceID = d.VaccinationServiceID
inner join Flock fl on a.FlockID = fl.FlockID
where a.VaccinationServiceID =  @VaccinationServiceID
and d.IsActive = 1
order by d.SortOrder


GO
