USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlan_GetNew]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlan_GetNew]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlan_GetNew]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan_GetNew]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlan_GetNew] AS' 
END
GO



ALTER proc [dbo].[PulletFarmPlan_GetNew]
	@Planned24WeekDate date = null,
	@FarmID int = null
As  


declare @PulletCountAt16Weeks int,
	@PlannedEndDate date,
	@FarmNumber int

select 
	@Planned24WeekDate = nullif(@Planned24WeekDate, ''),
	@FarmID= nullif(@FarmID, '')

select @PulletCountAt16Weeks = DefaultPulletQty, @FarmNumber = FarmNumber
from Farm
where FarmID = @FarmID

if isnull(@PulletCountAt16Weeks,0) = 0
begin
	select @PulletCountAt16Weeks = isnull(ConstantValue, 30000)
	from SystemConstant
	where ConstantName like '%Default%pullet%quantity%'
end


select @PlannedEndDate = dateadd(week, 41,@Planned24WeekDate)

select FarmNumber = @FarmNumber, 
	PulletQtyAt16Weeks = @PulletCountAt16Weeks,
	TwentyFourWeekDate = @Planned24WeekDate,
	EndDate = @PlannedEndDate,
	Planned65WeekDate = @PlannedEndDate,
	PlannedPulletFarmPlanID = 0



GO
