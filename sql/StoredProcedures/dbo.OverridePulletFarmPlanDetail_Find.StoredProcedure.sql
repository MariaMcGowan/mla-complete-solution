USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OverridePulletFarmPlanDetail_Find]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OverridePulletFarmPlanDetail_Find]
GO
/****** Object:  StoredProcedure [dbo].[OverridePulletFarmPlanDetail_Find]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OverridePulletFarmPlanDetail_Find]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OverridePulletFarmPlanDetail_Find] AS' 
END
GO



ALTER proc [dbo].[OverridePulletFarmPlanDetail_Find]
@StartDate date = null, @EndDate date = null, @FarmID int = null, @ContractTypeID int = null
as

	select @StartDate  = isnull(nullif(@StartDate,''), convert(date,getdate()))
	select @EndDate  = isnull(nullif(@EndDate,''), dateadd(MONTH, 1, @StartDate))
	select @FarmID = nullif(@FarmID, '')
	select @ContractTypeID = nullif(@ContractTypeID, '')

	select 
		@StartDate as StartDate,
		@EndDate as EndDate,
		@FarmID as FarmID,
		@ContractTypeID as ContractTypeID



GO
