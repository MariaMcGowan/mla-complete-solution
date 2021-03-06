USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_ShowAvailable]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialCommitment_ShowAvailable]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_ShowAvailable]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitment_ShowAvailable]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialCommitment_ShowAvailable] AS' 
END
GO



ALTER proc [dbo].[CommercialCommitment_ShowAvailable] @StartDate date, @EndDate date
As    

declare @Data table (WeekEndingDate date, FarmID int, EggWeightClassificationID int, 
CommercialEggs int, CommittedEggs int)

insert into @Data (WeekEndingDate, FarmID, EggWeightClassificationID, CommercialEggs)
select WeekEndingDate, FarmID, EggWeightClassificationID, sum(CommercialEggs)
from RollingDailySchedule 
where WeekEndingDate between @StartDate and @EndDate
group by WeekEndingDate, FarmID, EggWeightClassificationID


insert into @Data (WeekEndingDate, FarmID, EggWeightClassificationID, CommittedEggs)
select WeekEndingDate, FarmID, EggWeightClassificationID, sum(CommittedQty) as CommittedEggs
from CommercialCommitmentDetail ccd
inner join PulletFarmPlan pfp on ccd.PulletFarmPlanID = pfp.PulletFarmPlanID
group by WeekEndingDate, FarmID, EggWeightClassificationID


select WeekEndingDate, FarmNumber, EggWeightClassification, 
sum(CommercialEggs) as CommercialEggs, sum(CommittedEggs) as CommittedEggs, 
sum(CommercialEggs) - sum(CommittedEggs) as AvailableEggs
from @Data d
inner join Farm f on d.FarmID = f.FarmID
left outer join EggWeightClassification ewc on d.EggWeightClassificationID = ewc.EggWeightClassificationID
group by WeekEndingDate, FarmNumber, EggWeightClassification
order by WeekEndingDate, FarmNumber, EggWeightClassification


GO
