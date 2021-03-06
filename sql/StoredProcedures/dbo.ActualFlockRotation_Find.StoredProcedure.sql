USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ActualFlockRotation_Find]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ActualFlockRotation_Find]
GO
/****** Object:  StoredProcedure [dbo].[ActualFlockRotation_Find]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ActualFlockRotation_Find]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ActualFlockRotation_Find] AS' 
END
GO



ALTER proc [dbo].[ActualFlockRotation_Find]
@PlanningStartDate date = null, @PlanningEndDate date = null, @ShowEmbryoOrPulletQtyID varchar(10)=null
as

	select @PlanningStartDate  = isnull(nullif(@PlanningStartDate,''), convert(date,getdate()))
	select @PlanningEndDate  = isnull(nullif(@PlanningEndDate,''), dateadd(yy, 2, @PlanningStartDate))
	select @ShowEmbryoOrPulletQtyID = isnull(nullif(@ShowEmbryoOrPulletQtyID, ''), 'Embryo')

	select 
		@PlanningStartDate as PlanningStartDate,
		@PlanningEndDate as PlanningEndDate,
		@ShowEmbryoOrPulletQtyID as ShowEmbryoOrPulletQtyID



GO
