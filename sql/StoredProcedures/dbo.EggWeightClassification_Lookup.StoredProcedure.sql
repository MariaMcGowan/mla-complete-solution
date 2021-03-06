USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggWeightClassification_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggWeightClassification_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[EggWeightClassification_Lookup]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggWeightClassification_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggWeightClassification_Lookup] AS' 
END
GO



ALTER proc [dbo].[EggWeightClassification_Lookup]
 @IncludeBlank bit = 1
 ,@IncludeAll bit = 1    
  As    
  
  declare @data table (EggWeightClassification varchar(50), EggWeightClassificationID int, SortOrder int)

  insert into @data(EggWeightClassification, EggWeightClassificationID, SortOrder)
  select EggWeightClassification, EggWeightClassificationID, MinCaseWeight_lbs
  from EggWeightClassification
  
  
  
  insert into @data(EggWeightClassification, EggWeightClassificationID, SortOrder)
  select '','', -1
  where @IncludeBlank = 1    
  
  insert into @data(EggWeightClassification, EggWeightClassificationID, SortOrder)
  select 'All','',0 
  where @IncludeAll = 1

  select EggWeightClassification, EggWeightClassificationID
  from @Data
  order by SortOrder



GO
