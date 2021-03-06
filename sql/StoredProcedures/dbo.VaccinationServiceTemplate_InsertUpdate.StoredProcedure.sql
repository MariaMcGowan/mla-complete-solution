USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationServiceTemplate_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[VaccinationServiceTemplate_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationServiceTemplate_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationServiceTemplate_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VaccinationServiceTemplate_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[VaccinationServiceTemplate_InsertUpdate]  
 @I_vVaccinationServiceTemplateID int
 ,@I_vVaccinationServiceTemplateDescr nvarchar(200)=null
 ,@I_vIsActive bit = null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

if @I_vVaccinationServiceTemplateID = 0  
begin
	-- Copy the current template and allow the user to change it...
	declare @CopyVaccinationServiceTemplateID int 

	select top 1 @CopyVaccinationServiceTemplateID = VaccinationServiceTemplateID
	from VaccinationServiceTemplate
	where IsActive = 1
	order by VaccinationServiceTemplateID desc

	select @I_vVaccinationServiceTemplateDescr = isnull(nullif(@I_vVaccinationServiceTemplateDescr, ''), 'VaccinationService Template Created on ' + convert(varchar(20), getdate(), 101))

	declare @VaccinationServiceTemplateID table (VaccinationServiceTemplateID int)   
	insert into VaccinationServiceTemplate (	VaccinationServiceTemplateDescr, IsActive )   
		output inserted.VaccinationServiceTemplateID into @VaccinationServiceTemplateID(VaccinationServiceTemplateID)  
	select @I_vVaccinationServiceTemplateDescr, 1

	select top 1 @I_vVaccinationServiceTemplateID = VaccinationServiceTemplateID, @iRowID = @I_vVaccinationServiceTemplateID 
	from @VaccinationServiceTemplateID  


	insert into VaccinationServiceTemplateItem (VaccinationServiceTemplateID, ServiceOrDisease, AgeInDays, Service, Disease, VaccineDeliveryMethod, Supplier, ProductName, ProductSerialNumber, Administrator, IsActive, SortOrder)
	select @I_vVaccinationServiceTemplateID, ServiceOrDisease, AgeInDays, Service, Disease, VaccineDeliveryMethod, Supplier, ProductName, ProductSerialNumber, Administrator, IsActive, SortOrder
	from VaccinationServiceTemplateItem
	where VaccinationServiceTemplateID = @CopyVaccinationServiceTemplateID and IsActive = 1

	-- Originally was only planning on having a single "Active" template
	-- Now, multiple templates can be active at once and the user chooses the 
	-- template that they want to use.
	--update VaccinationServiceTemplate set IsActive = 
	--case
	--	when VaccinationServiceTemplateID = @I_vVaccinationServiceTemplateID then 1
	--	else 0
	--end
end  
else  
begin   
	update VaccinationServiceTemplate set
	   VaccinationServiceTemplateDescr = @I_vVaccinationServiceTemplateDescr
	  ,IsActive = @I_vIsActive
	 where @I_vVaccinationServiceTemplateID = VaccinationServiceTemplateID   
	 
	 select @iRowID = @I_vVaccinationServiceTemplateID  
end

select @I_vVaccinationServiceTemplateID as ID,'forward' As referenceType


GO
