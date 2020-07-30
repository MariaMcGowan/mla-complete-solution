USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[DailyOrWeekly_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[DailyOrWeekly_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[DailyOrWeekly_Lookup]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DailyOrWeekly_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DailyOrWeekly_Lookup] AS' 
END
GO



ALTER proc [dbo].[DailyOrWeekly_Lookup]
  As    
  
  select 'Daily' as DailyOrWeekly, 'Daily' as DailyOrWeeklyID
  union all
  select 'Weekly' as DailyOrWeekly, 'Weekly' as DailyOrWeeklyID
 



GO
