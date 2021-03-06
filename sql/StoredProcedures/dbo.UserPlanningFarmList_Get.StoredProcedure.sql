USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[UserPlanningFarmList_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[UserPlanningFarmList_Get]
GO
/****** Object:  StoredProcedure [dbo].[UserPlanningFarmList_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPlanningFarmList_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UserPlanningFarmList_Get] AS' 
END
GO



ALTER proc [dbo].[UserPlanningFarmList_Get] @ContractTypeID int,  @UserID varchar(255)
	
As    


select @UserID as UserID,
@ContractTypeID as ContractTypeID,
f.FarmID, DefaultPulletQty,
Farm = FarmNumber,
	--case
	--	when right(Farm, 3) = convert(varchar(3),FarmNumber) then Farm
	--	else Farm + ' ' + convert(varchar(3),FarmNumber)
	--end, 
IncludeFarmInPlan =
	case
		when upfl.FarmID  is null then convert(bit, 0) 
		else convert(bit, 1)
	end
from Farm f
left outer join UserPlanningFarmList upfl on f.FarmID = upfl.FarmID and upfl.UserID = @UserID and ContractTypeID = @ContractTypeID
where f.IsActive = 1
order by FarmNumber



GO
