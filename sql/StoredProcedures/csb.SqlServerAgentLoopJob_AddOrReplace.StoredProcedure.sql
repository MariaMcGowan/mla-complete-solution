USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[SqlServerAgentLoopJob_AddOrReplace]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[SqlServerAgentLoopJob_AddOrReplace]
GO
/****** Object:  StoredProcedure [csb].[SqlServerAgentLoopJob_AddOrReplace]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[SqlServerAgentLoopJob_AddOrReplace]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[SqlServerAgentLoopJob_AddOrReplace] AS' 
END
GO

ALTER procedure [csb].[SqlServerAgentLoopJob_AddOrReplace]
	@ServerName sysname,
	@DatabaseName sysname,
	@OwnerLoginName sysname,
	@JobCategoryName sysname,
	@JobName sysname,
	@JobDescription nvarchar(512),
	@Command nvarchar(max)
as

print '
Add job category ' + @JobCategoryName + '...'
if not exists(
		select name 
			from msdb.dbo.syscategories 
			where name = @JobCategoryName 
				and category_class = 1
		) begin
	exec msdb.dbo.sp_add_category  @class='JOB', @type='LOCAL', @name=@JobCategoryName
end

set @JobName = @DatabaseName + ' - ' + @JobName
print '
Delete ' + @JobName + '...'
if exists (
		select 1
			from msdb.dbo.sysjobs j
			where j.name = @JobName
		) begin
	exec msdb.dbo.sp_delete_job @job_name=@JobName
end

print '
Add ' + @JobName + '...'
declare @JobId binary(16)
exec msdb.dbo.sp_add_job  @job_name=@JobName, @enabled=1, @notify_level_eventlog=0, 
		@notify_level_email=0, @notify_level_netsend=0, @notify_level_page=0, 
		@delete_level=0, @description=@JobDescription, 
		@category_name=@JobCategoryName, @owner_login_name=@OwnerLoginName, 
		@job_id=@JobId output

print '
Add job step to ' + @JobName + '...'
set @Command = 'while 1 = 1 begin
	' + @Command + '
	waitfor delay ''00:00:00.100''
end'
exec msdb.dbo.sp_add_jobstep  @job_id=@JobId, @step_name='Loop', @step_id=1, 
		@cmdexec_success_code=0, @on_success_action=1, @on_success_step_id=0, 
		@on_fail_action=2, @on_fail_step_id=0, @retry_attempts=0, 
		@retry_interval=0, @os_run_priority=0, @subsystem='TSQL', 
		@database_name=@DatabaseName, @flags=0, @command=@Command

print '
Update ' + @JobName + ' to start at step one...'
exec msdb.dbo.sp_update_job @job_id=@JobId, @start_step_id=1

print '
Add job server for ' + @JobName + '...'
exec msdb.dbo.sp_add_jobserver @job_id=@JobId, @server_name=@ServerName

GO
