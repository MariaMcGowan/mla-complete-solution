USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QtrlyPerformAuditTemplateSection_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QtrlyPerformAuditTemplateSection_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[QtrlyPerformAuditTemplateSection_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplateSection_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QtrlyPerformAuditTemplateSection_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[QtrlyPerformAuditTemplateSection_InsertUpdate]  
 @I_vQtrlyPerformAuditTemplateID int
 ,@I_vQtrlyPerformAuditTemplateSectionID int
 ,@I_vSectionText varchar(200) = null
 ,@I_vDeleteSection bit = 0
 ,@I_vSortOrder int = null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

select @I_vSectionText = nullif(@I_vSectionText, '')

if @I_vQtrlyPerformAuditTemplateSectionID = 0 
begin   

	declare @QtrlyPerformAuditTemplateSectionID table (QtrlyPerformAuditTemplateSectionID int)   
	insert into QtrlyPerformAuditTemplateSection (	
		QtrlyPerformAuditTemplateID
		, SectionText
		, IsActive
		, SortOrder
		)   
		output inserted.QtrlyPerformAuditTemplateSectionID into @QtrlyPerformAuditTemplateSectionID(QtrlyPerformAuditTemplateSectionID)  
	select 
		@I_vQtrlyPerformAuditTemplateID
		, @I_vSectionText
		, 1
		, @I_vSortOrder
	 where @I_vSectionText is not null

	select top 1 @I_vQtrlyPerformAuditTemplateSectionID = isnull(QtrlyPerformAuditTemplateSectionID,0), @iRowID = isnull(QtrlyPerformAuditTemplateSectionID,0)
	from @QtrlyPerformAuditTemplateSectionID
end  
else 
begin
	if @I_vDeleteSection = 1
	begin
		update QtrlyPerformAuditTemplateSection set IsActive = 0 where QtrlyPerformAuditTemplateSectionID = @I_vQtrlyPerformAuditTemplateSectionID
	end
	else
	begin
		update QtrlyPerformAuditTemplateSection set
		   SectionText = @I_vSectionText
		  ,SortOrder = @I_vSortOrder
		 where @I_vQtrlyPerformAuditTemplateSectionID = QtrlyPerformAuditTemplateSectionID   
		 and @I_vSectionText is not null
	 end
	 select @iRowID = @I_vQtrlyPerformAuditTemplateSectionID  
end

select @I_vQtrlyPerformAuditTemplateSectionID as ID,'forward' As referenceType


GO
