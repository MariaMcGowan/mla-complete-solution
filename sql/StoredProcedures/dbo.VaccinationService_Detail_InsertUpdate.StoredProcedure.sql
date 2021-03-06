USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationService_Detail_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[VaccinationService_Detail_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationService_Detail_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationService_Detail_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VaccinationService_Detail_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[VaccinationService_Detail_InsertUpdate]  
    @I_vVaccinationServiceDetailID int
	, @I_vAgeInDays int = null
	, @I_vService varchar(200) = null
	, @I_vDisease varchar(200) = null
	, @I_vVaccineDeliveryMethod varchar(20) = null
	, @I_vSupplier varchar(20) = null
	, @I_vProductName varchar(50) = null
	, @I_vProductSerialNumber varchar(20) = null
	, @I_vAdministrator varchar(20) = null
	, @I_vIsActive bit
	, @I_vSortOrder int = null
	, @I_vDateCompleted date = null
	, @I_vSignedOffBy varchar(100) = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output  
 
AS  

update d set 
	d.ServiceOrDisease = 
		case
			when isnull(@I_vService,'') > '' then 'S'
			when isnull(@I_vDisease, '') > '' then 'D'
		end
	, d.AgeInDays = @I_vAgeInDays
	, d.Service = @I_vService
	, d.Disease = @I_vDisease
	, d.VaccineDeliveryMethod = @I_vVaccineDeliveryMethod
	, d.Supplier = @I_vSupplier
	, d.ProductName = @I_vProductName
	, d.ProductSerialNumber = @I_vProductSerialNumber
	, d.Administrator = @I_vAdministrator
	, d.IsActive = @I_vIsActive
	, d.SortOrder = @I_vSortOrder
	, d.DateCompleted = @I_vDateCompleted
	, d.SignedOffBy = @I_vSignedOffBy
from VaccinationServiceDetail d
where VaccinationServiceDetailID = @I_vVaccinationServiceDetailID




GO
