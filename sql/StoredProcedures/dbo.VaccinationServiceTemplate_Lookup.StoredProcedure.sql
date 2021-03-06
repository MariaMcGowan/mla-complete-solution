USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationServiceTemplate_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[VaccinationServiceTemplate_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationServiceTemplate_Lookup]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationServiceTemplate_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VaccinationServiceTemplate_Lookup] AS' 
END
GO



ALTER proc [dbo].[VaccinationServiceTemplate_Lookup]
 @IncludeBlank bit = 0
 ,@IncludeNew bit = 0
  As    
  
  select VaccinationServiceTemplateDescr, VaccinationServiceTemplateID
  from VaccinationServiceTemplate
  where IsActive = 1
  
  union all 
  select '{New}', null
  where @IncludeNew = 1

  select '',null
  where @IncludeBlank = 1    
  

	


GO
