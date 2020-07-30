USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_Settings]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockRotation_Settings]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_Settings]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockRotation_Settings]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockRotation_Settings] AS' 
END
GO



ALTER proc [dbo].[FlockRotation_Settings]
as

	select PlanningStartDate  = convert(date,getdate()),
	PlanningEndDate  = dateadd(yy, 2, convert(date,getdate())),
	ShowEmbryoOrPulletQtyID = 'Embryo'




GO
