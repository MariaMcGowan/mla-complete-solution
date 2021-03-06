USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_Get_FarmList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockRotation_Get_FarmList]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_Get_FarmList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockRotation_Get_FarmList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockRotation_Get_FarmList] AS' 
END
GO



ALTER  proc [dbo].[FlockRotation_Get_FarmList] @UserID varchar(255)

As   


declare @FarmTranslation table (FarmColumn int, FarmID int, FarmName varchar(100), FarmNumber varchar(6))

	insert into @FarmTranslation
	select * 
	from dbo.GetPlanningFarmList(@UserID)


select *
from @FarmTranslation



GO
