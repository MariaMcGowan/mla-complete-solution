USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[GetPADLSReport]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetPADLSReport]
GO
/****** Object:  StoredProcedure [dbo].[GetPADLSReport]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPADLSReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPADLSReport] AS' 
END
GO



ALTER proc [dbo].[GetPADLSReport]
as

set nocount off

declare @TaskCount int = 0
	, @PADLSTemplateTaskListID int
	, @PADLSTemplateID int
	, @Omit bit
	, @Task varchar(200)
	, @Counter int = 0
	, @SQL varchar(4000)

select top 1 @PADLSTemplateID  = PADLSTemplateID 
from PADLSTemplate
where IsActive = 1
order by PADLSTemplateID desc

create table #Data (PADLSSamplingScheduleID int primary key, PADLSTemplateID int, FlockID int, Flock varchar(20), FarmNumber varchar(10), HatchDate date
, Task01_PADLSTemplateTaskListID int, Task01_Task varchar(200), Task01_TargetedDate date, Task01_OmitDateTargetedFromReport bit default 1, Task01_CompletedDate date, Task01_Visible bit default 0
, Task02_PADLSTemplateTaskListID int, Task02_Task varchar(200), Task02_TargetedDate date, Task02_OmitDateTargetedFromReport bit default 1, Task02_CompletedDate date, Task02_Visible bit default 0
, Task03_PADLSTemplateTaskListID int, Task03_Task varchar(200), Task03_TargetedDate date, Task03_OmitDateTargetedFromReport bit default 1, Task03_CompletedDate date, Task03_Visible bit default 0
, Task04_PADLSTemplateTaskListID int, Task04_Task varchar(200), Task04_TargetedDate date, Task04_OmitDateTargetedFromReport bit default 1, Task04_CompletedDate date, Task04_Visible bit default 0
, Task05_PADLSTemplateTaskListID int, Task05_Task varchar(200), Task05_TargetedDate date, Task05_OmitDateTargetedFromReport bit default 1, Task05_CompletedDate date, Task05_Visible bit default 0
, Task06_PADLSTemplateTaskListID int, Task06_Task varchar(200), Task06_TargetedDate date, Task06_OmitDateTargetedFromReport bit default 1, Task06_CompletedDate date, Task06_Visible bit default 0
, Task07_PADLSTemplateTaskListID int, Task07_Task varchar(200), Task07_TargetedDate date, Task07_OmitDateTargetedFromReport bit default 1, Task07_CompletedDate date, Task07_Visible bit default 0
, Task08_PADLSTemplateTaskListID int, Task08_Task varchar(200), Task08_TargetedDate date, Task08_OmitDateTargetedFromReport bit default 1, Task08_CompletedDate date, Task08_Visible bit default 0
, Task09_PADLSTemplateTaskListID int, Task09_Task varchar(200), Task09_TargetedDate date, Task09_OmitDateTargetedFromReport bit default 1, Task09_CompletedDate date, Task09_Visible bit default 0
, Task10_PADLSTemplateTaskListID int, Task10_Task varchar(200), Task10_TargetedDate date, Task10_OmitDateTargetedFromReport bit default 1, Task10_CompletedDate date, Task10_Visible bit default 0
, Task11_PADLSTemplateTaskListID int, Task11_Task varchar(200), Task11_TargetedDate date, Task11_OmitDateTargetedFromReport bit default 1, Task11_CompletedDate date, Task11_Visible bit default 0
, Task12_PADLSTemplateTaskListID int, Task12_Task varchar(200), Task12_TargetedDate date, Task12_OmitDateTargetedFromReport bit default 1, Task12_CompletedDate date, Task12_Visible bit default 0
, Task13_PADLSTemplateTaskListID int, Task13_Task varchar(200), Task13_TargetedDate date, Task13_OmitDateTargetedFromReport bit default 1, Task13_CompletedDate date, Task13_Visible bit default 0
, Task14_PADLSTemplateTaskListID int, Task14_Task varchar(200), Task14_TargetedDate date, Task14_OmitDateTargetedFromReport bit default 1, Task14_CompletedDate date, Task14_Visible bit default 0
, Task15_PADLSTemplateTaskListID int, Task15_Task varchar(200), Task15_TargetedDate date, Task15_OmitDateTargetedFromReport bit default 1, Task15_CompletedDate date, Task15_Visible bit default 0
, Task16_PADLSTemplateTaskListID int, Task16_Task varchar(200), Task16_TargetedDate date, Task16_OmitDateTargetedFromReport bit default 1, Task16_CompletedDate date, Task16_Visible bit default 0
, Task17_PADLSTemplateTaskListID int, Task17_Task varchar(200), Task17_TargetedDate date, Task17_OmitDateTargetedFromReport bit default 1, Task17_CompletedDate date, Task17_Visible bit default 0
, Task18_PADLSTemplateTaskListID int, Task18_Task varchar(200), Task18_TargetedDate date, Task18_OmitDateTargetedFromReport bit default 1, Task18_CompletedDate date, Task18_Visible bit default 0
, Task19_PADLSTemplateTaskListID int, Task19_Task varchar(200), Task19_TargetedDate date, Task19_OmitDateTargetedFromReport bit default 1, Task19_CompletedDate date, Task19_Visible bit default 0
, Task20_PADLSTemplateTaskListID int, Task20_Task varchar(200), Task20_TargetedDate date, Task20_OmitDateTargetedFromReport bit default 1, Task20_CompletedDate date, Task20_Visible bit default 0
)

insert into #Data (PADLSSamplingScheduleID, PADLSTemplateID, FlockID, Flock, FarmNumber, HatchDate)
select PADLSSamplingScheduleID, PADLSTemplateID, pss.FlockID, Flock, FarmNumber, HatchDate
from PADLSSamplingSchedule pss
inner join Flock fl on pss.FlockID = fl.FlockID
inner join Farm f on fl.FarmID = f.FarmID

-- Get list of all applicable tasks
create table #Task (TaskID int primary key, PADLSTemplateTaskListID int, SortOrder int, ItemText varchar(200), OmitDateTargetedFromReport bit default 1)

insert into #Task(TaskID, PADLSTemplateTaskListID, SortOrder, ItemText, OmitDateTargetedFromReport)
select TaskID, PADLSTemplateTaskListID, SortOrder, ItemText, OmitDateTargetedFromReport
from dbo.GetPADLSTaskList()

select @TaskCount = count(*) from #Task

while @Counter < @TaskCount
begin
	select @Counter = @Counter + 1
	
	select @PADLSTemplateTaskListID = PADLSTemplateTaskListID, @Task = ItemText, @Omit = OmitDateTargetedFromReport
	from #Task
	where TaskID = @Counter 

	-- Loop through the latest template to make sure that we have all of the task columns visible
	set @SQL = 
	'update d set 
		d.Task{NN}_Task = ''@Task'',
		d.Task{NN}_Visible = 1,
		d.Task{NN}_OmitDateTargetedFromReport = @Omit,
		d.Task{NN}_PADLSTemplateTaskListID = @PADLSTemplateTaskListID
	from #Data d
	where exists (select 1 from PADLSTemplateItem where PADLSTemplateID = @PADLSTemplateID and PADLSTemplateTaskListID = @PADLSTemplateTaskListID)'

	select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @Counter),2))
	select @SQL = replace(@SQL, '@Task', @Task)
	select @SQL = replace(@SQL, '@Omit', @Omit)
	select @SQL = replace(@SQL, '@PADLSTemplateID', convert(varchar(4), @PADLSTemplateID))
	select @SQL = replace(@SQL, '@PADLSTemplateTaskListID', convert(varchar(4), @PADLSTemplateTaskListID))
	print @SQL
	execute (@SQL)

	-- Get data from PADLS
	set @SQL = 
	'update d set 
		d.Task{NN}_TargetedDate = t.DateTargeted,
		d.Task{NN}_CompletedDate = t.DateCompleted
	from #Data d
	inner join 
	(
		select p.PADLSSamplingScheduleID, i.PADLSTemplateTaskListID, 
		DateTargeted = 
		case
			when de.DateTargeted is not null then de.DateTargeted
			when ItemText like ''%Spent%Fowl%Blood%'' then dateadd(day,-14,coalesce(f.RemovalDate, f.Date_65Weeks))
			when isnull(i.AgeInDays,0) > 0 then dateadd(day,i.AgeInDays, f.HatchDate)
			else convert(date,null)
		end, de.DateCompleted
		from PADLSSamplingSchedule p
		inner join PADLSTemplateItem i on p.PADLSTemplateID = i.PADLSTemplateID
		left outer join PADLSSamplingScheduleDetail de on i.PADLSTemplateItemID = de.PADLSTemplateItemID and p.PADLSSamplingScheduleID = de.PADLSSamplingScheduleID
		inner join Flock f on p.FlockID = f.FlockID
		where i.PADLSTemplateTaskListID = @PADLSTemplateTaskListID
	) t on d.PADLSSamplingScheduleID = t.PADLSSamplingScheduleID'

	select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @Counter),2))
	select @SQL = replace(@SQL, '@PADLSTemplateTaskListID', convert(varchar(4), @PADLSTemplateTaskListID))
	print @SQL
	execute (@SQL)

	--- Synch up the visibility
	set @SQL = 
	'update d set 
		d.Task{NN}_OmitDateTargetedFromReport = 1
	from #Data d
	where Task{NN}_Visible = 0'

	select @SQL = replace(@SQL, '{NN}', right('00' + convert(varchar(4), @Counter),2))
	print @SQL
	execute (@SQL)
end


select *
from #Data
order by FarmNumber, HatchDate desc


GO
