USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockComment_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockComment_Get]
GO
/****** Object:  StoredProcedure [dbo].[FlockComment_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockComment_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockComment_Get] AS' 
END
GO



ALTER proc [dbo].[FlockComment_Get]  
	@PulletFarmPlanCommentID int = null,
	@PulletFarmPlanID int = null,
	@ScreenName varchar(50), 
	@UserID varchar(100) = null
		
As  

declare @IncludeBlank bit = 0

select @PulletFarmPlanCommentID = nullif(@PulletFarmPlanCommentID, '')
	, @PulletFarmPlanID = nullif(@PulletFarmPlanID, '')
	, @ScreenName = nullif(@ScreenName, '')

if @PulletFarmPlanCommentID is null
	select @IncludeBlank = 1


select PulletFarmPlanCommentID = 0, 
	PulletFarmPlanID = @PulletFarmPlanID, 
	UserID = @UserID, 
	UpdatedDateTime = convert(date,getdate()),
	Comment = convert(varchar(2000), null), 
	ScreenName = @ScreenName, 
	FlockNumber = 
		case
			when ContractTypeID = (select ContractTypeID from ContractType where ContractType like 'Pullet%Only%') then 'Pullet Only Flock'
			else FlockNumber
		end
from PulletFarmPlan
where @IncludeBlank =1 and PulletFarmPlanID = @PulletFarmPlanID
union all
select PulletFarmPlanCommentID, pfpc.PulletFarmPlanID, UserID, UpdatedDateTime, Comment, ScreenName, 
FlockNumber = 
		case
			when ContractTypeID = (select ContractTypeID from ContractType where ContractType like 'Pullet%Only%') then 'Pullet Only Flock'
			else FlockNumber
		end
from PulletFarmPlanComment pfpc
inner join PulletFarmPlan pfp on pfpc.PulletFarmPlanID = pfp.PulletFarmPlanID
where PulletFarmPlanCommentID = isnull(@PulletFarmPlanCommentID, PulletFarmPlanCommentID)
and pfpc.PulletFarmPlanID = isnull(@PulletFarmPlanID, pfpc.PulletFarmPlanID)
and ScreenName = isnull(@ScreenName, ScreenName)
order by UpdatedDateTime 


GO
