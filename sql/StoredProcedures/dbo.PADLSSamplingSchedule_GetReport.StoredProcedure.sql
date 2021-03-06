USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PADLSSamplingSchedule_GetReport]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PADLSSamplingSchedule_GetReport]
GO
/****** Object:  StoredProcedure [dbo].[PADLSSamplingSchedule_GetReport]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSSamplingSchedule_GetReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PADLSSamplingSchedule_GetReport] AS' 
END
GO




ALTER proc [dbo].[PADLSSamplingSchedule_GetReport]  @PADLSSamplingScheduleID int
As    

select @PADLSSamplingScheduleID = nullif(@PADLSSamplingScheduleID, '')

declare @Tasks table (PADLSSamplingScheduleID int, TaskNumber int, Flock varchar(20), PADLSSamplingScheduleDetailID int, ItemText varchar(100), 
DateTargeted date, DateCompleted date, CompletedBy varchar(100))

insert into @Tasks (PADLSSamplingScheduleID, TaskNumber, Flock, PADLSSamplingScheduleDetailID, ItemText, DateTargeted, DateCompleted, CompletedBy)
select p.PADLSSamplingScheduleID
, TaskNumber = ROW_NUMBER () over (order by i.SortOrder)
, Flock
, PADLSSamplingScheduleDetailID
, ItemText
, DateTargeted
, DateCompleted
, CompletedBy	
from PADLSSamplingSchedule p
inner join PADLSTemplateItem i on p.PADLSTemplateID = i.PADLSTemplateID
inner join Flock fl on p.FlockID = fl.FlockID
left outer join PADLSSamplingScheduleDetail d on i.PADLSTemplateItemID = d.PADLSTemplateItemID and p.PADLSSamplingScheduleID = d.PADLSSamplingScheduleID
where @PADLSSamplingScheduleID is not null
and p.PADLSSamplingScheduleID = @PADLSSamplingScheduleID
and i.IsActive = 1



;with ReportData00 as
(
	select RowType = 'H', FlockCode = 'Flock Code'
	union all
	select RowType = 'Z', Flock
	from @Tasks
	where TaskNumber = 1
),
ReportData01 as
(
	select RowType = 'H', DateTargeted = ItemText, DateCompleted = 'Date Completed', CompletedBy = 'Completed By'
	from @Tasks 
	where TaskNumber = 1
	union all
	select RowType = 'Z', convert(varchar(10), DateTargeted, 101), convert(varchar(10), DateCompleted, 101), CompletedBy
	from @Tasks
	where TaskNumber = 1
),
ReportData02 as
(
	select RowType = 'H', DateTargeted = ItemText, DateCompleted = 'Date Completed', CompletedBy = 'Completed By'
	from @Tasks 
	where TaskNumber = 2
	union all
	select RowType = 'Z', convert(varchar(10), DateTargeted, 101), convert(varchar(10), DateCompleted, 101), CompletedBy
	from @Tasks
	where TaskNumber = 2
),
ReportData03 as
(
	select RowType = 'H', DateTargeted = ItemText, DateCompleted = 'Date Completed', CompletedBy = 'Completed By'
	from @Tasks 
	where TaskNumber = 3
	union all
	select RowType = 'Z', convert(varchar(10), DateTargeted, 101), convert(varchar(10), DateCompleted, 101), CompletedBy
	from @Tasks
	where TaskNumber = 3
),
ReportData04 as
(
	select RowType = 'H', DateTargeted = ItemText, DateCompleted = 'Date Completed', CompletedBy = 'Completed By'
	from @Tasks 
	where TaskNumber = 4
	union all
	select RowType = 'Z', convert(varchar(10), DateTargeted, 101), convert(varchar(10), DateCompleted, 101), CompletedBy
	from @Tasks
	where TaskNumber = 4
),
ReportData05 as
(
	select RowType = 'H', DateTargeted = ItemText, DateCompleted = 'Date Completed', CompletedBy = 'Completed By'
	from @Tasks 
	where TaskNumber = 5
	union all
	select RowType = 'Z', convert(varchar(10), DateTargeted, 101), convert(varchar(10), DateCompleted, 101), CompletedBy
	from @Tasks
	where TaskNumber = 5
),
ReportData06 as
(
	select RowType = 'H', DateTargeted = ItemText, DateCompleted = 'Date Completed', CompletedBy = 'Completed By'
	from @Tasks 
	where TaskNumber = 6
	union all
	select RowType = 'Z', convert(varchar(10), DateTargeted, 101), convert(varchar(10), DateCompleted, 101), CompletedBy
	from @Tasks
	where TaskNumber = 6
),
ReportData07 as
(
	select RowType = 'H', DateTargeted = ItemText, DateCompleted = 'Date Completed', CompletedBy = 'Completed By'
	from @Tasks 
	where TaskNumber = 7
	union all
	select RowType = 'Z', convert(varchar(10), DateTargeted, 101), convert(varchar(10), DateCompleted, 101), CompletedBy
	from @Tasks
	where TaskNumber = 7
),
ReportData08 as
(
	select RowType = 'H', DateTargeted = ItemText, DateCompleted = 'Date Completed', CompletedBy = 'Completed By'
	from @Tasks 
	where TaskNumber = 8
	union all
	select RowType = 'Z', convert(varchar(10), DateTargeted, 101), convert(varchar(10), DateCompleted, 101), CompletedBy
	from @Tasks
	where TaskNumber = 8
)

select d0.FlockCode
	, DateTargeted_01 = d1.DateTargeted, DateCompleted_01 = d1.DateCompleted, CompletedBy_01 = d1.CompletedBy
	, DateTargeted_02 = d2.DateTargeted, DateCompleted_02 = d2.DateCompleted, CompletedBy_02 = d2.CompletedBy
	, DateTargeted_03 = d3.DateTargeted, DateCompleted_03 = d3.DateCompleted, CompletedBy_03 = d3.CompletedBy
	, DateTargeted_04 = d4.DateTargeted, DateCompleted_04 = d4.DateCompleted, CompletedBy_04 = d4.CompletedBy
	, DateTargeted_05 = d5.DateTargeted, DateCompleted_05 = d5.DateCompleted, CompletedBy_05 = d5.CompletedBy
	, DateTargeted_06 = d6.DateTargeted, DateCompleted_06 = d6.DateCompleted, CompletedBy_06 = d6.CompletedBy
	, DateTargeted_07 = d7.DateTargeted, DateCompleted_07 = d7.DateCompleted, CompletedBy_07 = d7.CompletedBy
	, DateTargeted_08 = d8.DateTargeted, DateCompleted_08 = d8.DateCompleted, CompletedBy_08 = d8.CompletedBy
	, DynamicFormatting = 
		case
			when d0.RowType = 'H' then 'bold'
			else ''
		end
	, d0.RowType
from ReportData00 d0
left outer join ReportData01 d1 on d0.RowType = d1.RowType
left outer join ReportData02 d2 on d0.RowType = d2.RowType
left outer join ReportData03 d3 on d0.RowType = d3.RowType
left outer join ReportData04 d4 on d0.RowType = d4.RowType
left outer join ReportData05 d5 on d0.RowType = d5.RowType
left outer join ReportData06 d6 on d0.RowType = d6.RowType
left outer join ReportData07 d7 on d0.RowType = d7.RowType
left outer join ReportData08 d8 on d0.RowType = d8.RowType
order by d0.RowType



GO
