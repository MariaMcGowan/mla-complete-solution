USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanSummary_Find]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlanSummary_Find]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanSummary_Find]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanSummary_Find]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlanSummary_Find] AS' 
END
GO



ALTER proc [dbo].[PulletFarmPlanSummary_Find]
as

select convert(int, 1) as ContractTypeID


GO
