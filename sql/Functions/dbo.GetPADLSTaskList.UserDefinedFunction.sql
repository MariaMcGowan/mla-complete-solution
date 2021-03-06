USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPADLSTaskList]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetPADLSTaskList]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPADLSTaskList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPADLSTaskList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE function [dbo].[GetPADLSTaskList] ()
RETURNS 
@TaskList TABLE 
(
	TaskID int
	, PADLSTemplateTaskListID int
	, SortOrder int
	, ItemText varchar(200)
	, OmitDateTargetedFromReport bit default 0
)
AS
begin
	declare @PADLSTemplateID int 

	select top 1 @PADLSTemplateID = PADLSTemplateID
	from PADLSTemplate
	where IsActive = 1
	order by PADLSTemplateID desc

	insert into @TaskList(TaskID, PADLSTemplateTaskListID, SortOrder, ItemText, OmitDateTargetedFromReport)
	select row_number() over (order by SortOrder), PADLSTemplateTaskListID, SortOrder, ItemText, pti.OmitDateTargetedFromReport
	from PADLSTemplateItem pti
	where pti.IsActive = 1 and PADLSTemplateID = @PADLSTemplateID

	return
end' 
END

GO
