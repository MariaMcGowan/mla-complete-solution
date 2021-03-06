USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QtrlyPerformAuditTemplateItem_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QtrlyPerformAuditTemplateItem_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[QtrlyPerformAuditTemplateItem_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplateItem_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QtrlyPerformAuditTemplateItem_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[QtrlyPerformAuditTemplateItem_InsertUpdate]  
 @I_vQtrlyPerformAuditTemplateSectionID int
 ,@I_vQtrlyPerformAuditTemplateItemID int
 ,@I_vItemText varchar(200) = null
 ,@I_vIsActive bit = null
 ,@I_vSortOrder int = null
 ,@I_vDeleteItem bit = 0
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

select @I_vItemText = nullif(@I_vItemText, ''),
	@I_vIsActive = isnull(nullif(@I_vIsActive, ''), 0)

if @I_vQtrlyPerformAuditTemplateItemID = 0 
begin   

	declare @QtrlyPerformAuditTemplateItemID table (QtrlyPerformAuditTemplateItemID int)   
	insert into QtrlyPerformAuditTemplateItem (	
		QtrlyPerformAuditTemplateSectionID
		, ItemText
		, IsActive
		, SortOrder
		)   
		output inserted.QtrlyPerformAuditTemplateItemID into @QtrlyPerformAuditTemplateItemID(QtrlyPerformAuditTemplateItemID)  
	select 
		@I_vQtrlyPerformAuditTemplateSectionID
		, @I_vItemText
		, 1
		, @I_vSortOrder
	where @I_vItemText is not null

	select top 1 @I_vQtrlyPerformAuditTemplateItemID = isnull(QtrlyPerformAuditTemplateItemID,0), @iRowID = isnull(QtrlyPerformAuditTemplateItemID,0)
	from @QtrlyPerformAuditTemplateItemID
end  
else
begin   
	if @I_vDeleteItem = 1
	begin
		update QtrlyPerformAuditTemplateItem set IsActive = 0 where QtrlyPerformAuditTemplateItemID = @I_vQtrlyPerformAuditTemplateItemID
	end
	else
	begin
		update QtrlyPerformAuditTemplateItem set
		   ItemText = @I_vItemText
		  ,IsActive = @I_vIsActive
		  ,SortOrder = @I_vSortOrder
		 where @I_vQtrlyPerformAuditTemplateItemID = QtrlyPerformAuditTemplateItemID   
		 and @I_vItemText is not null
	end

	 select @iRowID = @I_vQtrlyPerformAuditTemplateItemID  
end

select @I_vQtrlyPerformAuditTemplateItemID as ID,'forward' As referenceType


GO
