USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationServiceTemplateItem_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[VaccinationServiceTemplateItem_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationServiceTemplateItem_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationServiceTemplateItem_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VaccinationServiceTemplateItem_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[VaccinationServiceTemplateItem_InsertUpdate]  
 @I_vVaccinationServiceTemplateID int
 ,@I_vVaccinationServiceTemplateItemID int
 ,@I_vServiceOrDisease char(1)=null
 ,@I_vAgeInDays int=null
 ,@I_vService varchar(200)=null
 ,@I_vDisease varchar(200)=null
 ,@I_vVaccineDeliveryMethod varchar(20)=null
 ,@I_vSupplier varchar(20)=null
 ,@I_vProductName varchar(50)=null
 ,@I_vProductSerialNumber varchar(20)=null
 ,@I_vAdministrator varchar(20)=null
 ,@I_vSortOrder int = null
 ,@I_vDeleteItem bit = 0
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

select @I_vServiceOrDisease = nullif(@I_vServiceOrDisease, '')
	, @I_vService = nullif(@I_vService, '')
	, @I_vDisease = nullif(@I_vDisease, '')
	, @I_vVaccineDeliveryMethod = nullif(@I_vVaccineDeliveryMethod, '')
	, @I_vSupplier = nullif(@I_vSupplier, '')
	, @I_vProductName = nullif(@I_vProductName, '')
	, @I_vAdministrator = nullif(@I_vAdministrator, '')

select @I_vAgeInDays = 
	case
		when isnumeric(@I_vAgeInDays) = 1 then @I_vAgeInDays
		else null
	end

if @I_vVaccinationServiceTemplateItemID = 0
begin   
	declare @VaccinationServiceTemplateItemID table (VaccinationServiceTemplateItemID int)   
	insert into VaccinationServiceTemplateItem (	
		VaccinationServiceTemplateID
		 ,ServiceOrDisease
		 ,AgeInDays
		 ,Service
		 ,Disease
		 ,VaccineDeliveryMethod
		 ,Supplier
		 ,ProductName
		 ,ProductSerialNumber
		 ,Administrator
		, IsActive
		, SortOrder
		)   
		output inserted.VaccinationServiceTemplateItemID into @VaccinationServiceTemplateItemID(VaccinationServiceTemplateItemID)  
	select 
		 @I_vVaccinationServiceTemplateID
		 ,@I_vServiceOrDisease
		 ,@I_vAgeInDays
		 ,@I_vService
		 ,@I_vDisease
		 ,@I_vVaccineDeliveryMethod
		 ,@I_vSupplier
		 ,@I_vProductName
		 ,@I_vProductSerialNumber
		 ,@I_vAdministrator
		 ,1
		 ,@I_vSortOrder

	select top 1 @I_vVaccinationServiceTemplateItemID = VaccinationServiceTemplateItemID, @iRowID = VaccinationServiceTemplateItemID 
	from @VaccinationServiceTemplateItemID
end  
else
begin   
	-- Should this row be removed?
	if @I_vDeleteItem = 1
	begin
		update VaccinationServiceTemplateItem set IsActive = 0 where @I_vVaccinationServiceTemplateItemID = VaccinationServiceTemplateItemID   
	end
	else
	begin
		update VaccinationServiceTemplateItem set
			ServiceOrDisease=@I_vServiceOrDisease
			,AgeInDays=@I_vAgeInDays
			,Service=@I_vService
			,Disease=@I_vDisease
			,VaccineDeliveryMethod=@I_vVaccineDeliveryMethod
			,Supplier=@I_vSupplier
			,ProductName=@I_vProductName
			,ProductSerialNumber=@I_vProductSerialNumber
			,Administrator=@I_vAdministrator
			, SortOrder=@I_vSortOrder
		 where @I_vVaccinationServiceTemplateItemID = VaccinationServiceTemplateItemID   
	 
		 select @iRowID = @I_vVaccinationServiceTemplateItemID  
	end
end

select @I_vVaccinationServiceTemplateItemID as ID,'forward' As referenceType


GO
