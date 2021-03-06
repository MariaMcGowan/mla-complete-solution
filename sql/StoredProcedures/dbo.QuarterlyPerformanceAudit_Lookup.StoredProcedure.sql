USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QuarterlyPerformanceAudit_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_Lookup]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAudit_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QuarterlyPerformanceAudit_Lookup] AS' 
END
GO



ALTER proc [dbo].[QuarterlyPerformanceAudit_Lookup]
 @IncludeBlank bit = 0
 ,@IncludeNew bit = 0
  As    
  
  select QuarterlyPerformanceAudit, QuarterlyPerformanceAuditID, FlockID, DateCreated
  from QuarterlyPerformanceAudit
  
  union all 
  select '{New}', null, 0, DateCreated = dateadd(MINUTE, 30, getdate() )
  where @IncludeNew = 1

  select '',null, null, DateCreated = getdate()
  where @IncludeBlank = 1    
  
  order by DateCreated desc
	


GO
