USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialEggPlanning]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialEggPlanning]
GO
/****** Object:  StoredProcedure [dbo].[CommercialEggPlanning]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialEggPlanning]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialEggPlanning] AS' 
END
GO



ALTER proc [dbo].[CommercialEggPlanning] @StartDate date, @EndDate date
as

--declare @StartDate date, @EndDate date
--select @StartDate = convert(date, getdate())
--select @EndDate = dateadd(year,2,@StartDate)

declare @Data table 
(
	RowID int, 
	Date date, 
	PlannedCommercialEggs int,
	ActualCommercialEggs int,
	CommercialEggs int,
	PlannedOrderQty int,
	ActualOrderQty int,
	OrderQty int,
	CommercialEggs_AfterOrders int
)

--declare @Actuals table 
--(
--	Date date, 
--	ActualCommercialEggs int
--)

-- Let's start with weekly planning info
--declare @PulletFarmPlan_WeeklySchedule table (WeekEndingDate date, StartDate date, EndDate date, CalcCommercialEggsPerDay int, DayCount int, CalcCommercialEggsForWeek int)

--insert into @PulletFarmPlan_WeeklySchedule (WeekEndingDate, CalcCommercialEggsPerDay)
--select 
--WeekEndingDate
--CalcCommercialEggsPerDay,
--DayCount, 
--CalcCommercialEggsPerDay * DayCount
--from dbo.PulletFarmPlan pf
--inner join dbo.PulletFarmPlan_WeeklySchedule ws on pf.PulletFarmPlanID = ws.PulletFarmPlanID
--group by WeekEndingDate


--update @PulletFarmPlan_WeeklySchedule set StartDate = dateadd(day,-6,WeekEndingDate), EndDate = WeekEndingDate

insert into @Data (
	RowID,
	Date, 
	PlannedCommercialEggs,
	ActualCommercialEggs,
	CommercialEggs
)
select ROW_NUMBER() OVER (order by Date),
Date,
sum(isnull(pfpd.CalcCommercialEggs,0)),
sum(isnull(pfpd.ActualCommercialEggs,0)),
CommercialEggs = sum(coalesce(pfpd.CalcCommercialEggs,pfpd.ActualCommercialEggs,0))

from PulletFarmPlanDetail pfpd
inner join PulletFarmPlan_WeeklySchedule ws on ws.PulletFarmPlanID = pfpd.PulletFarmPlanID and ws.WeekNumber = pfpd.WeekNumber
where Date between @StartDate and @EndDate
group by Date


update @Data set CommercialEggs_AfterOrders = CommercialEggs - OrderQty

SELECT RowID, Date, CommercialEggs, OrderQty, CommercialEggs_AfterOrders, 
  CommercialEggs_AfterOrders_RunningTotal = SUM(CommercialEggs_AfterOrders) OVER (ORDER BY RowID ROWS UNBOUNDED PRECEDING)
FROM @Data
ORDER BY RowID;







GO
