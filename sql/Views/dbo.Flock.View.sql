USE [MLA]
GO
/****** Object:  View [dbo].[Flock]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP VIEW IF EXISTS [dbo].[Flock]
GO
/****** Object:  View [dbo].[Flock]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Flock]'))
EXEC dbo.sp_executesql @statement = N'
create View [dbo].[Flock] 
--with SCHEMABINDING
as 
select 
	FlockID = PulletFarmPlanID
	, Flock = FlockNumber
	, FarmID
	, MaleBreed
	, FemaleBreed
	, HatchDate = coalesce(ActualHatchDate, PlannedHatchDate)
	, HousingDate = PulletFacility_RemoveDate
	, Date_24Weeks = coalesce(Actual24WeekDate, Planned24WeekDate)
	, Date_65Weeks = coalesce(Actual65WeekDate, Planned65WeekDate)
	, RemovalDate = ProductionFarm_RemoveDate
	--, SortOrder = datediff(day,''1990-1-1'',coalesce(Actual16WeekDate, Planned16WeekDate)) * -1
	, SortOrder = Row_number() OVER(ORDER BY FlockNumber) 
	, Test = 
		case
			when nullif(OverwrittenIsActiveFlag,0) is not null then ''OverwrittenIsActiveFlag''
			when getdate() > dateadd(week, 5, coalesce(Actual65WeekDate, Planned65WeekDate)) then ''Expired''
			when getdate() < coalesce(Actual16WeekDate, Planned16WeekDate) then ''Not Ready Yet''
			when PulletFarmPlanID = 
				(
					select top 1 pfp1.PulletFarmPlanID
					from dbo.PulletFarmPlan pfp1 
					where getdate() between coalesce(pfp1.Actual16WeekDate, pfp1.Planned16WeekDate, convert(date,''01/01/1900'',101)) and coalesce(pfp1.ActualEndDate, pfp1.Actual65WeekDate, pfp1.PlannedEndDate)
					and pfp1.FarmID = pfp.FarmID
					order by coalesce(pfp1.Actual16WeekDate, pfp1.Planned16WeekDate, convert(date,''01/01/1900'',101)) desc
				) then ''Found 1''
			else ''Nothing Left''
		end
	, IsActive = 
		case
			when nullif(OverwrittenIsActiveFlag,0) is not null then convert(bit, OverwrittenIsActiveFlag)
			when getdate() > dateadd(week, 4, coalesce(Actual65WeekDate, Planned65WeekDate)) then convert(bit,0)
			when getdate() < coalesce(Actual16WeekDate, Planned16WeekDate) then convert(bit, 0)
			when PulletFarmPlanID = 
				(
					select top 1 pfp1.PulletFarmPlanID
					from dbo.PulletFarmPlan pfp1 
					where getdate() between coalesce(pfp1.Actual16WeekDate, pfp1.Planned16WeekDate, convert(date,''01/01/1900'',101)) and coalesce(pfp1.ActualEndDate, pfp1.Actual65WeekDate, pfp1.PlannedEndDate)
					and pfp1.FarmID = pfp.FarmID
					order by coalesce(pfp1.Actual16WeekDate, pfp1.Planned16WeekDate, convert(date,''01/01/1900'',101)) desc
				) then convert(bit,1)
			else convert(bit, 0)
		end
	, PreActivation = 
		case
			when getdate() < coalesce(Actual16WeekDate, Planned16WeekDate) then convert(bit, 1)
			else 0
		end
	, ct.ContractTypeID
	, ct.ContractType
	, PulletFarmPlanID
	, PulletFacilityID
from dbo.PulletFarmPlan pfp
inner join dbo.ContractType ct on pfp.ContractTypeID = ct.ContractTypeID
' 
GO
