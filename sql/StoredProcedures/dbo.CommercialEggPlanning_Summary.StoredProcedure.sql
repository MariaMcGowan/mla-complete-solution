USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialEggPlanning_Summary]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialEggPlanning_Summary]
GO
/****** Object:  StoredProcedure [dbo].[CommercialEggPlanning_Summary]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialEggPlanning_Summary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialEggPlanning_Summary] AS' 
END
GO



ALTER proc [dbo].[CommercialEggPlanning_Summary] @StartDate date, @EndDate date
as

--declare @StartDate date, @EndDate date
--select @StartDate = convert(date, getdate())
--select @EndDate = dateadd(year,2,@StartDate)

select @StartDate = isnull(nullif(@StartDate, ''),convert(date, getdate()))
select @EndDate = isnull(nullif(@EndDate, ''),dateadd(year,2,@StartDate))

declare @Data table 
(
	WeekEndingDate date index idxWeekEndingDate Clustered
)

declare @Eggs table 
(
	WeekEndingDate date index idxWeekEndingDate Clustered, 
	EggWeightClass01 int,
	EggWeightClass02 int,
	EggWeightClass03 int,
	EggWeightClass04 int
)
declare @Orders table
(
	WeekEndingDate date index idxWeekEndingDate Clustered, 
	EggWeightClass01 int,
	EggWeightClass02 int,
	EggWeightClass03 int,
	EggWeightClass04 int
)


if datepart(dw,@StartDate) <> 7
begin
	-- Jump to the first saturday after the start date
	select @StartDate = dateadd(dd, 7 - datepart(dw,@StartDate),@StartDate)
end

if datepart(dw,@EndDate) <> 7
begin
	-- Jump to the first saturday after the end date
	select @EndDate = dateadd(dd, 7 - datepart(dw,@EndDate),@EndDate)
end


--select @EndDate = dateadd(week,60,@StartDate)
;With DateSequence( Date ) as
(
	Select @StartDate as Date
		union all
	Select dateadd(wk, 1, Date)
		from DateSequence
		where Date < @EndDate
)


insert into @Data (WeekEndingDate)
select Date
from DateSequence
option (MAXRECURSION 1000)


insert into @Eggs (WeekEndingDate, EggWeightClass01, EggWeightClass02, EggWeightClass03, EggWeightClass04)
select WeekEndingDate, [1], [2], [3], [4]
from 
(
  select WeekEndingDate, CommercialEggs = sum(CommercialEggs), EggWeightClassificationID
  from RollingDailySchedule
  where WeekEndingDate between @StartDate and @EndDate
  group by WeekEndingDate, EggWeightClassificationID
) src
pivot
(
  sum(CommercialEggs)
  for EggWeightClassificationID in ([1], [2], [3], [4])
) piv;


insert into @Orders (WeekEndingDate, EggWeightClass01, EggWeightClass02, EggWeightClass03, EggWeightClass04)
select WeekEndingDate, [1], [2], [3], [4]
from 
(
  select ccd.WeekEndingDate, Qty = sum(ccd.CommittedQty), EggWeightClassificationID
  from CommercialCommitment cc
  inner join CommercialCommitmentDetail ccd on cc.CommercialCommitmentID = ccd.CommercialCommitmentID
  --inner join dbo.DateByWeekEndingDate(@StartDate, @EndDate) d on cc.CommitmentDateStart  = d.Date
  where ccd.WeekEndingDate between @StartDate and @EndDate
  and cc.CommitmentStatusID <> 6
  group by ccd.WeekEndingDate, EggWeightClassificationID
) src
pivot
(
  sum(Qty)
  for EggWeightClassificationID in ([1], [2], [3], [4])
) piv;



select d.WeekEndingDate, 
TotalCommercialEggs = isnull(e.EggWeightClass01,0) + isnull(e.EggWeightClass02,0) + isnull(e.EggWeightClass03,0) + isnull(e.EggWeightClass04,0),
CommercialEggs_01 = e.EggWeightClass01, 
CommercialEggs_02 = e.EggWeightClass02, 
CommercialEggs_03 = e.EggWeightClass03, 
CommercialEggs_04 = e.EggWeightClass04,
TotalOrderEggs = nullif(isnull(o.EggWeightClass01,0) + isnull(o.EggWeightClass02,0) + isnull(o.EggWeightClass03,0) + isnull(o.EggWeightClass04,0),0),
OrderEggs_01 = o.EggWeightClass01, 
OrderEggs_02 = o.EggWeightClass02, 
OrderEggs_03 = o.EggWeightClass03, 
OrderEggs_04 = o.EggWeightClass04,
TotalRemainingEggs = 
	(isnull(e.EggWeightClass01,0) + isnull(e.EggWeightClass02,0) + isnull(e.EggWeightClass03,0) + isnull(e.EggWeightClass04,0)) - 
	(isnull(o.EggWeightClass01,0) + isnull(o.EggWeightClass02,0) + isnull(o.EggWeightClass03,0) + isnull(o.EggWeightClass04,0)),
RemainingEggs_01 = nullif(isnull(e.EggWeightClass01,0) - isnull(o.EggWeightClass01,0), 0),
RemainingEggs_02 = nullif(isnull(e.EggWeightClass02,0) - isnull(o.EggWeightClass02,0), 0),
RemainingEggs_03 = nullif(isnull(e.EggWeightClass03,0) - isnull(o.EggWeightClass03,0), 0),
RemainingEggs_04 = nullif(isnull(e.EggWeightClass04,0) - isnull(o.EggWeightClass04,0),0),
TotalRemainingEggs_Format = 
	case
		when 
			(isnull(e.EggWeightClass01,0) + isnull(e.EggWeightClass02,0) + isnull(e.EggWeightClass03,0) + isnull(e.EggWeightClass04,0)) - 
			(isnull(o.EggWeightClass01,0) + isnull(o.EggWeightClass02,0) + isnull(o.EggWeightClass03,0) + isnull(o.EggWeightClass04,0)) < 0
		then 'Red'
		else 'Black'
	end,
RemainingEggs_01_Format = 
	case
		when isnull(e.EggWeightClass01,0) - isnull(o.EggWeightClass01,0) < 0 then 'Red'
		else 'Black'
	end,
RemainingEggs_02_Format = 
	case
		when isnull(e.EggWeightClass02,0) - isnull(o.EggWeightClass02,0) < 0 then 'Red'
		else 'Black'
	end,
RemainingEggs_03_Format = 
	case
		when isnull(e.EggWeightClass03,0) - isnull(o.EggWeightClass03,0) < 0 then 'Red'
		else 'Black'
	end,
RemainingEggs_04_Format = 
	case
		when isnull(e.EggWeightClass04,0) - isnull(o.EggWeightClass04,0) < 0 then 'Red'
		else 'Black'
	end
from @Data d
left outer join @Eggs e on d.WeekEndingDate = e.WeekEndingDate
left outer join @Orders o on d.WeekEndingDate = o.WeekEndingDate


GO
