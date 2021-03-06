USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PADLSTemplateItem_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PADLSTemplateItem_Get]
GO
/****** Object:  StoredProcedure [dbo].[PADLSTemplateItem_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PADLSTemplateItem_Get] AS' 
END
GO



ALTER proc [dbo].[PADLSTemplateItem_Get]  @PADLSTemplateID int, @IncludeBlank bit = 0
As    

select @PADLSTemplateID = nullif(@PADLSTemplateID, '')


declare @BlankRows int = 0
	, @Loop int = 0
declare @Data table (PADLSTemplateItemID int, PADLSTemplateID int, PADLSTemplateItemTaskNumberID int, 
OriginalTaskText varchar(100), ItemText varchar(100), OmitDateTargetedFromReport bit, AgeInDays int, SortOrder int, DeleteItem bit)

if @IncludeBlank = 1
	select @BlankRows = 5

insert into @Data (PADLSTemplateItemID, PADLSTemplateID,PADLSTemplateItemTaskNumberID, OriginalTaskText, ItemText, OmitDateTargetedFromReport, AgeInDays, SortOrder, DeleteItem)
select PADLSTemplateItemID
	, PADLSTemplateID
	, i.PADLSTemplateTaskListID
	, tn.InitialTaskDescription
	, ItemText
	, OmitDateTargetedFromReport
	, AgeInDays
	, SortOrder
	, DeleteItem = convert(bit,0)
from PADLSTemplateItem i
left outer join PADLSTemplateTaskList tn on i.PADLSTemplateTaskListID = tn.PADLSTemplateTaskListID
where PADLSTemplateID = @PADLSTemplateID and IsActive = 1
and PADLSTemplateID = @PADLSTemplateID

While @BlankRows  > 0
begin
	select @Loop = @Loop + 1

	insert into @Data (PADLSTemplateItemID, PADLSTemplateID, ItemText, AgeInDays, SortOrder, DeleteItem)
	select PADLSTemplateItemID = convert(int, 0)
		, PADLSTemplateID = @PADLSTemplateID
		, ItemText = convert(varchar(200), null)
		, AgeInDays = convert(int, null)
		, SortOrder = (100  * @Loop) + isnull((select max(SortOrder) from PADLSTemplateItem where IsActive = 1 and PADLSTemplateID = @PADLSTemplateID),0)
		,DeleteItem = convert(bit,0)

	select @BlankRows = @BlankRows - 1
end

select *
from @Data 
order by SortOrder


GO
