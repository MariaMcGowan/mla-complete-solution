USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QtrlyPerformAuditTemplate_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QtrlyPerformAuditTemplate_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[QtrlyPerformAuditTemplate_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplate_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QtrlyPerformAuditTemplate_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[QtrlyPerformAuditTemplate_InsertUpdate]  
 @I_vQtrlyPerformAuditTemplateID int
 ,@I_vQtrlyPerformAuditTemplateDescr nvarchar(200)=null
 ,@I_vIsActive bit = null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

if @I_vQtrlyPerformAuditTemplateID = 0  
begin   
	declare @CopyQtrlyPerformAuditTemplateID int

	select @CopyQtrlyPerformAuditTemplateID = QtrlyPerformAuditTemplateID
	from QtrlyPerformAuditTemplate
	where IsActive = 1

	select @I_vQtrlyPerformAuditTemplateDescr = isnull(nullif(@I_vQtrlyPerformAuditTemplateDescr, ''), 'Quarterly Performance Audit Template Created on ' + convert(varchar(20), getdate(), 101))

	declare @QtrlyPerformAuditTemplateID table (QtrlyPerformAuditTemplateID int)   
	insert into QtrlyPerformAuditTemplate (	QtrlyPerformAuditTemplateDescr, IsActive )   
		output inserted.QtrlyPerformAuditTemplateID into @QtrlyPerformAuditTemplateID(QtrlyPerformAuditTemplateID)  
	select @I_vQtrlyPerformAuditTemplateDescr, 1

	select top 1 @I_vQtrlyPerformAuditTemplateID = QtrlyPerformAuditTemplateID, @iRowID = @I_vQtrlyPerformAuditTemplateID 
	from @QtrlyPerformAuditTemplateID

	-- Copy Sections
	insert into QtrlyPerformAuditTemplateSection (QtrlyPerformAuditTemplateID, SectionText, IsActive, SortOrder)
	select @I_vQtrlyPerformAuditTemplateID, SectionText, IsActive, SortOrder
	from QtrlyPerformAuditTemplateSection
	where QtrlyPerformAuditTemplateID = @CopyQtrlyPerformAuditTemplateID and IsActive = 1

	-- Copy Items
	insert into QtrlyPerformAuditTemplateItem (QtrlyPerformAuditTemplateSectionID, ItemText, IsActive, SortOrder)
	select newSection.QtrlyPerformAuditTemplateSectionID, ItemText, origItem.IsActive, origItem.SortOrder
	from QtrlyPerformAuditTemplateItem origItem
	inner join QtrlyPerformAuditTemplateSection origSection on origItem.QtrlyPerformAuditTemplateSectionID = origSection.QtrlyPerformAuditTemplateSectionID
	inner join QtrlyPerformAuditTemplateSection newSection on origSection.QtrlyPerformAuditTemplateID = @CopyQtrlyPerformAuditTemplateID
		and newSection.QtrlyPerformAuditTemplateID = @I_vQtrlyPerformAuditTemplateID
		and origSection.SectionText = newSection.SectionText
	where origSection.IsActive = 1 and origItem.IsActive = 1

	update QtrlyPerformAuditTemplate set IsActive = 
		case
			when QtrlyPerformAuditTemplateID = @I_vQtrlyPerformAuditTemplateID then 1
			else 0
		end

end  
else  
begin   
	update QtrlyPerformAuditTemplate set
	   QtrlyPerformAuditTemplateDescr = @I_vQtrlyPerformAuditTemplateDescr,
	   IsActive  = @I_vIsActive
	 where @I_vQtrlyPerformAuditTemplateID = QtrlyPerformAuditTemplateID   
	 
	 select @iRowID = @I_vQtrlyPerformAuditTemplateID  
end

select @I_vQtrlyPerformAuditTemplateID as ID,'forward' As referenceType


GO
