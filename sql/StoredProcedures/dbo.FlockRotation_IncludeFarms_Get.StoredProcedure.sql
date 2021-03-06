USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_IncludeFarms_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockRotation_IncludeFarms_Get]
GO
/****** Object:  StoredProcedure [dbo].[FlockRotation_IncludeFarms_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockRotation_IncludeFarms_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockRotation_IncludeFarms_Get] AS' 
END
GO



ALTER procedure [dbo].[FlockRotation_IncludeFarms_Get]  @UserID varchar(255)
	
As    


select 
f.FarmID,
IncludeFarmInPlan =
	case
		when upfl.FarmID  is null then convert(bit, 0) 
		else convert(bit, 1)
	end
from Farm f
left outer join UserPlanningFarmList upfl on f.FarmID = upfl.FarmID and upfl.UserID = @UserID




GO
