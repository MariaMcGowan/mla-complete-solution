USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_Find]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QuarterlyPerformanceAudit_Find]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_Find]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAudit_Find]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QuarterlyPerformanceAudit_Find] AS' 
END
GO



ALTER proc [dbo].[QuarterlyPerformanceAudit_Find]  
As    


select FarmID = convert(int, null), QuarterlyPerformanceAuditID = convert(int, null)



GO
