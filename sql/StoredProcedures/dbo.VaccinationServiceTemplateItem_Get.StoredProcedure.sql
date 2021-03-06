USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationServiceTemplateItem_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[VaccinationServiceTemplateItem_Get]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationServiceTemplateItem_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationServiceTemplateItem_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VaccinationServiceTemplateItem_Get] AS' 
END
GO



ALTER proc [dbo].[VaccinationServiceTemplateItem_Get]  @VaccinationServiceTemplateID int, @IncludeBlank bit = 0
As    

select @VaccinationServiceTemplateID = nullif(@VaccinationServiceTemplateID, '')

select VaccinationServiceTemplateItemID
	,VaccinationServiceTemplateID
	,ServiceOrDisease
	,AgeInDays
	,Service
	,Disease
	,VaccineDeliveryMethod
	,Supplier
	,ProductName
	,ProductSerialNumber
	,Administrator
	,SortOrder
	,DeleteItem = convert(bit,0)
from VaccinationServiceTemplateItem
--where IsActive = 1
where VaccinationServiceTemplateID = @VaccinationServiceTemplateID
union all
select VaccinationServiceTemplateItemID = convert(int, 0)
	, VaccinationServiceTemplateID = @VaccinationServiceTemplateID
	,ServiceOrDisease = convert(char(1),null)
	,AgeInDays = convert(int, null)
	,Service = convert(varchar(200), null)
	,Disease = convert(varchar(200), null)
	,VaccineDeliveryMethod = convert(varchar(20), null)
	,Supplier = convert(varchar(20), null)
	,ProductName = convert(varchar(50), null)
	,ProductSerialNumber = convert(varchar(20), null)
	,Administrator = convert(varchar(20), null)
	,SortOrder = 100 + isnull((select max(SortOrder) from VaccinationServiceTemplateItem where IsActive = 1 and VaccinationServiceTemplateID = @VaccinationServiceTemplateID),0)
	,DeleteItem = convert(bit,0)
where @IncludeBlank = 1
order by SortOrder


GO
