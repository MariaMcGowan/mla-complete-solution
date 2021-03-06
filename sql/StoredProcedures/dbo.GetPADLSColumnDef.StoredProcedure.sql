USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[GetPADLSColumnDef]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetPADLSColumnDef]
GO
/****** Object:  StoredProcedure [dbo].[GetPADLSColumnDef]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPADLSColumnDef]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPADLSColumnDef] AS' 
END
GO



ALTER proc [dbo].[GetPADLSColumnDef]
as


set nocount off

declare @TaskCount int, @Counter int, @ItemText varchar(200), @Omit bit, @SortOrder int

declare @Task table (TaskID int, PADLSTemplateTaskListID int, SortOrder int, ItemText varchar(200), OmitDateTargetedFromReport bit default 1)
declare @ColumnDef table (field varchar(200), label varchar(200), type varchar(20), SortOrder int)

insert into @Task(TaskID, PADLSTemplateTaskListID, SortOrder, ItemText, OmitDateTargetedFromReport)
select TaskID, PADLSTemplateTaskListID, SortOrder, ItemText, OmitDateTargetedFromReport
from dbo.GetPADLSTaskList()


insert into @ColumnDef (field, label, type, SortOrder)
select 'Flock', 'Flock', '', 0


select @TaskCount = count(*) from @Task
select @Counter = 0

while @Counter < @TaskCount
begin
	select @Counter = @Counter + 1

	select @ItemText = ItemText, @Omit = OmitDateTargetedFromReport, @SortOrder = SortOrder
	from @Task
	where TaskID = @Counter

	if @Omit = 0
	begin
		insert into @ColumnDef (field, label, type, SortOrder)
		select field = replace('Task{NN}_TargetedDate', '{NN}', right('00' + convert(varchar(4), @Counter),2))
		, label = @ItemText + ' Date Targeted'
		, type = ''
		, SortOrder = @SortOrder
	end

	insert into @ColumnDef (field, label, type, SortOrder)
	select field = replace('Task{NN}_CompletedDate', '{NN}', right('00' + convert(varchar(4), @Counter),2))
	, label = @ItemText + ' Date Completed'
	, type = ''
	, SortOrder = @SortOrder
end

select * from @ColumnDef order by SortOrder






GO
