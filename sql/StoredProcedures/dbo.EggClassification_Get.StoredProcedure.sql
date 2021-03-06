USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggClassification_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggClassification_Get]
GO
/****** Object:  StoredProcedure [dbo].[EggClassification_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggClassification_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggClassification_Get] AS' 
END
GO



ALTER proc [dbo].[EggClassification_Get]  @EggClassificationID int = null  ,@IncludeNew bit = 0
As    


select  
 EggClassificationID
 , EggClassification
from EggClassification
where IsNull(@EggClassificationID,EggClassificationID) = EggClassificationID
union all  
select  
 EggClassificationID = convert(int,0)
 , EggClassification = convert(nvarchar(255),null)
where @IncludeNew = 1  



GO
