USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PADLSTemplateItem_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PADLSTemplateItem_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[PADLSTemplateItem_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PADLSTemplateItem_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[PADLSTemplateItem_InsertUpdate]  
 @I_vPADLSTemplateID int
 ,@I_vPADLSTemplateItemID int
 ,@I_vPADLSTemplateTaskListID int = null
 ,@I_vItemText varchar(200) = null
 ,@I_vAgeInDays int = null
 ,@I_vOmitDateTargetedFromReport bit = 0
 ,@I_vIsActive bit = null
 ,@I_vSortOrder int = null
 ,@I_vDeleteItem bit = null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

select @I_vItemText = nullif(@I_vItemText, ''),
	@I_vPADLSTemplateTaskListID = nullif(@I_vPADLSTemplateTaskListID, ''),
	@I_vOmitDateTargetedFromReport = isnull(nullif(@I_vOmitDateTargetedFromReport, ''), 0),
	@I_vIsActive = isnull(nullif(@I_vIsActive, ''), 1)

if @I_vPADLSTemplateItemID = 0
begin  
	-- It must be a new item
	-- Need to add it to the Task List first
	declare @PADLSTemplateTaskListID table (PADLSTemplateTaskListID int)   
	insert into PADLSTemplateTaskList (InitialTaskDescription)
	output inserted.PADLSTemplateTaskListID into @PADLSTemplateTaskListID(PADLSTemplateTaskListID)  
	select @I_vItemText
	where @I_vItemText is not null

	select top 1 @I_vPADLSTemplateTaskListID = isnull(PADLSTemplateTaskListID,0)
	from @PADLSTemplateTaskListID

	declare @PADLSTemplateItemID table (PADLSTemplateItemID int)   
	insert into PADLSTemplateItem (	
		PADLSTemplateID
		, PADLSTemplateTaskListID
		, ItemText
		, AgeInDays
		, OmitDateTargetedFromReport
		, IsActive
		, SortOrder
		)   
		output inserted.PADLSTemplateItemID into @PADLSTemplateItemID(PADLSTemplateItemID)  
	select 
		@I_vPADLSTemplateID
		, @I_vPADLSTemplateTaskListID
		, @I_vItemText
		, @I_vAgeInDays
		, @I_vOmitDateTargetedFromReport
		, 1
		, @I_vSortOrder
	where @I_vItemText is not null

	select top 1 @I_vPADLSTemplateItemID = isnull(PADLSTemplateItemID,0), @iRowID = isnull(PADLSTemplateItemID,0)
	from @PADLSTemplateItemID
end  
else
begin
	-- Should this row be removed?
	if @I_vDeleteItem = 1
	begin
		update PADLSTemplateItem set IsActive = 0 where PADLSTemplateItemID = @I_vPADLSTemplateItemID   
	end
	else
	begin
		update PADLSTemplateItem set
			ItemText = @I_vItemText
			, AgeInDays = @I_vAgeInDays
			, OmitDateTargetedFromReport = @I_vOmitDateTargetedFromReport
			, IsActive = @I_vIsActive
			, SortOrder = @I_vSortOrder
			where @I_vPADLSTemplateItemID = PADLSTemplateItemID and @I_vItemText is not null
	 
		select @iRowID = @I_vPADLSTemplateItemID  
	end
end

select @I_vPADLSTemplateItemID as ID,'forward' As referenceType


GO
