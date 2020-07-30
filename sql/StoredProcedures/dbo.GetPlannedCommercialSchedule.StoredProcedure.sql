USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[GetPlannedCommercialSchedule]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetPlannedCommercialSchedule]
GO
/****** Object:  StoredProcedure [dbo].[GetPlannedCommercialSchedule]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPlannedCommercialSchedule]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPlannedCommercialSchedule] AS' 
END
GO



ALTER proc [dbo].[GetPlannedCommercialSchedule] @StartDate date, @EndDate date, @EggWeightClassificationID int
as

--if @DailyOrWeeklyID = 'Daily'
--	execute GetPlannedCommercialSchedule_ByDay @StartDate, @EndDate
--else	
	execute GetPlannedCommercialSchedule_ByWeek @StartDate, @EndDate, @EggWeightClassificationID



GO
