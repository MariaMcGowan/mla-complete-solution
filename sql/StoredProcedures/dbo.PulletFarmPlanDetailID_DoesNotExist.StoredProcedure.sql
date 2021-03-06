USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanDetailID_DoesNotExist]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlanDetailID_DoesNotExist]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanDetailID_DoesNotExist]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanDetailID_DoesNotExist]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlanDetailID_DoesNotExist] AS' 
END
GO



ALTER proc [dbo].[PulletFarmPlanDetailID_DoesNotExist]
As   

select UserMessage = 'The system does not expect eggs from this farm on this date; please confirm farm/date and try again.'



GO
