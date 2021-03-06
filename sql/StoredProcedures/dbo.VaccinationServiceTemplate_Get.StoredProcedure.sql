
/****** Object:  StoredProcedure [dbo].[VaccinationServiceTemplate_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[VaccinationServiceTemplate_Get]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationServiceTemplate_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationServiceTemplate_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VaccinationServiceTemplate_Get] AS' 
END
GO



ALTER proc [dbo].[VaccinationServiceTemplate_Get]  @VaccinationServiceTemplateID int = null, @IncludeBlank bit = 0
As    

select @VaccinationServiceTemplateID = nullif(@VaccinationServiceTemplateID, '')

select 
	VaccinationServiceTemplateID
	, VaccinationServiceTemplateDescr
	, IsActive
from VaccinationServiceTemplate
where 
--IsActive = 1
--and 
VaccinationServiceTemplateID = isnull(@VaccinationServiceTemplateID, VaccinationServiceTemplateID)
union all
select 
	VaccinationServiceTemplateID = convert(int, 0)
	, VaccinationServiceTemplateDescr = convert(varchar(200), null)
	, IsActive = convert(bit, null)
where @IncludeBlank = 1


GO
