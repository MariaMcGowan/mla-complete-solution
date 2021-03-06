USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationService_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[VaccinationService_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[VaccinationService_Lookup]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationService_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VaccinationService_Lookup] AS' 
END
GO



ALTER proc [dbo].[VaccinationService_Lookup]
 @IncludeBlank bit = 0
 ,@IncludeNew bit = 0
  As    
  
  select VaccinationService, VaccinationServiceID, FlockID
  from VaccinationService
  
  union all 
  select '{New}', null, 0
  where @IncludeNew = 1

  select '',null, null
  where @IncludeBlank = 1    
  

	


GO
