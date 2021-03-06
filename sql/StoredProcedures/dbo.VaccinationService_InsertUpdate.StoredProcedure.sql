USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationService_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[VaccinationService_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationService_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationService_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VaccinationService_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[VaccinationService_InsertUpdate]  
     @I_vVaccinationServiceID int
	,@I_vFlockID int = null
    ,@I_vVaccinationServiceTemplateID int = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output  
 
AS

select @I_vVaccinationServiceID = isnull(nullif(@I_vVaccinationServiceID, ''),0)
	, @I_vFlockID = nullif(@I_vFlockID, '')

if @I_vVaccinationServiceID = 0
begin
	select @I_vVaccinationServiceTemplateID = isnull(nullif(@I_vVaccinationServiceTemplateID, ''),0)

	select top 1 @I_vVaccinationServiceTemplateID = VaccinationServiceTemplateID 
	from VaccinationServiceTemplate
	where IsActive = 1
	and @I_vVaccinationServiceTemplateID = 0
	order by VaccinationServiceTemplateID desc

	declare @VaccinationServiceID table (VaccinationServiceID int)
	insert into dbo.VaccinationService (		
		 FlockID
		, VaccinationService
	)
	output inserted.VaccinationServiceID into @VaccinationServiceID(VaccinationServiceID)
	select	
		@I_vFlockID
		, 'Vaccination and Service for ' + (select flock from flock where FlockID = @I_vFlockID) + '; ' + convert(varchar(20), getdate(), 101)

	select top 1 @I_vVaccinationServiceID = VaccinationServiceID, @iRowID = VaccinationServiceID from @VaccinationServiceID

	insert into VaccinationServiceDetail(VaccinationServiceID, 
	ServiceOrDisease, AgeInDays, Service, Disease, VaccineDeliveryMethod, Supplier, 
	ProductName, ProductSerialNumber, Administrator, IsActive, SortOrder)
	select @I_vVaccinationServiceID, 
	ServiceOrDisease, AgeInDays, Service, Disease, VaccineDeliveryMethod, Supplier, 
	ProductName, ProductSerialNumber, Administrator, IsActive, SortOrder
	from VaccinationServiceTemplateItem i 
	where i.VaccinationServiceTemplateID = @I_vVaccinationServiceTemplateID
	and i.IsActive = 1
	order by i.SortOrder

	declare @Loop int = 3
	declare @MaxSortOrder int

	select @MaxSortOrder = max(SortOrder) 
	from VaccinationServiceTemplateItem i
	where i.VaccinationServiceTemplateID = @I_vVaccinationServiceTemplateID and i.IsActive = 1

	while @Loop > 0
	begin
		select @MaxSortOrder= @MaxSortOrder + 10

		insert into VaccinationServiceDetail (VaccinationServiceID, SortOrder)
		select @I_vVaccinationServiceID, @MaxSortOrder

		select @Loop = @Loop - 1
	end
end
else
begin
	update VaccinationService
		set FlockID = @I_vFlockID
	where VaccinationServiceID = @I_vVaccinationServiceID
end

select @I_vVaccinationServiceID as ID,'forward' As referenceType


GO
