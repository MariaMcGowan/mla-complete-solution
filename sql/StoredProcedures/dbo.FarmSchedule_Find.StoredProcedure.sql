USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FarmSchedule_Find]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FarmSchedule_Find]
GO
/****** Object:  StoredProcedure [dbo].[FarmSchedule_Find]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FarmSchedule_Find]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FarmSchedule_Find] AS' 
END
GO



ALTER proc [dbo].[FarmSchedule_Find]
@PlanningStartDate date = null, @PlanningEndDate date = null
as

	select @PlanningStartDate  = isnull(nullif(@PlanningStartDate,''), dateadd(yy,-1,convert(date,getdate())))
	select @PlanningEndDate  = isnull(nullif(@PlanningEndDate,''), dateadd(yy, 3, @PlanningStartDate))

	select 
	convert(varchar(10), null) as FlockCode,
	convert(int, null) as PulletFacilityID, 
	convert(int, null) as FarmID, 
	@PlanningStartDate as PlanningStartDate, @PlanningEndDate as PlanningEndDate



GO
