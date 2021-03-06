USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanDetailID_TestValue]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlanDetailID_TestValue]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanDetailID_TestValue]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanDetailID_TestValue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlanDetailID_TestValue] AS' 
END
GO



ALTER proc [dbo].[PulletFarmPlanDetailID_TestValue] @PulletFarmPlanDetailID int
As   

select 
	referenceType = 
		case
			when exists (select 1 from PulletFarmPlanDetail where PulletFarmPlanDetailID = @PulletFarmPlanDetailID) then 'Pass'
			else 'Fail'
		end, 
	PulletFarmPlanDetailID = @PulletFarmPlanDetailID



GO
