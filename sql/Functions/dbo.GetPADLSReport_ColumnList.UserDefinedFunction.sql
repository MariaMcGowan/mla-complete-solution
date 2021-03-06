USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPADLSReport_ColumnList]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetPADLSReport_ColumnList]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPADLSReport_ColumnList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPADLSReport_ColumnList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[GetPADLSReport_ColumnList] ()
Returns
@ColumnList TABLE 
(
	ColumnName varchar(500)
)
AS
begin

	declare @TaskList TABLE 
	(
		TaskID int
		, PADLSTemplateTaskListID int
		, SortOrder int
		, ItemText varchar(200)
		, OmitDateTargetedFromReport bit default 0
	)

	insert into @TaskList(TaskID, PADLSTemplateTaskListID, SortOrder, ItemText, OmitDateTargetedFromReport)
	select TaskID, PADLSTemplateTaskListID, SortOrder, ItemText, OmitDateTargetedFromReport
	from dbo.GetPADLSTaskList()

	declare @TaskCount int, @Counter int, @ColumnName varchar(200), @OmitDateTargeted bit 

	select @TaskCount = count(*), @Counter = 0, @ColumnName = '''', @OmitDateTargeted = 0
	from @TaskList

	while @Counter < @TaskCount
	begin
		select @Counter = @Counter + 1

		select @ColumnName = '''', @OmitDateTargeted = 0

		select @ColumnName = ItemText, @OmitDateTargeted = OmitDateTargetedFromReport
		from @TaskList 
		where TaskID = @Counter

		if @OmitDateTargeted = 0
			insert into @ColumnList (ColumnName)
			select @ColumnName + '' <br> Date Targeted''

		insert into @ColumnList (ColumnName)
		select @ColumnName + '' <br> Date Completed''
	end
	
	return
end' 
END

GO
