USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialEggSchedule_Find]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialEggSchedule_Find]
GO
/****** Object:  StoredProcedure [dbo].[CommercialEggSchedule_Find]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialEggSchedule_Find]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialEggSchedule_Find] AS' 
END
GO



ALTER proc [dbo].[CommercialEggSchedule_Find]
@StartDate date = null, @EndDate date = null, @DailyOrWeeklyID varchar(10)=null, @EggWeightClassificationID int = null
as

	select @StartDate  = isnull(nullif(@StartDate,''), convert(date,getdate()))
	select @EndDate  = isnull(nullif(@EndDate,''), dateadd(yy, 2, @StartDate))
	select @DailyOrWeeklyID = isnull(nullif(@DailyOrWeeklyID, ''), 'Weekly')
	select @EggWeightClassificationID = isnull(nullif(@EggWeightClassificationID, ''), 0)

	select 
		@StartDate as StartDate,
		@EndDate as EndDate,
		@DailyOrWeeklyID as DailyOrWeeklyID,
		@EggWeightClassificationID as EggWeightClassificationID



GO
