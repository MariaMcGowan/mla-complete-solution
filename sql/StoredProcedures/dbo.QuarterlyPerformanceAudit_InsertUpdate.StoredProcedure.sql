USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QuarterlyPerformanceAudit_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAudit_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QuarterlyPerformanceAudit_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[QuarterlyPerformanceAudit_InsertUpdate]  
     @I_vQuarterlyPerformanceAuditID int
	,@I_vFlockID int = null
	,@I_vInspectedBy varchar(200) = null
	,@I_vDateCreated datetime = null
    ,@I_vQtrlyPerformAuditTemplateID int = null
	,@I_vComments varchar(1000)= null
	,@I_vAuditStatusID int = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output  
 
AS

select @I_vQuarterlyPerformanceAuditID = isnull(nullif(@I_vQuarterlyPerformanceAuditID, ''),0)
	, @I_vFlockID = nullif(@I_vFlockID, '')
	, @I_vQtrlyPerformAuditTemplateID = nullif(@I_vQtrlyPerformAuditTemplateID, '')
	, @I_vInspectedBy = nullif(@I_vInspectedBy, '')
	, @I_vDateCreated = nullif(@I_vDateCreated, '')

if @I_vQuarterlyPerformanceAuditID = 0
begin
	select top 1 @I_vQtrlyPerformAuditTemplateID = QtrlyPerformAuditTemplateID 
	from QtrlyPerformAuditTemplate
	where IsActive = 1
	order by QtrlyPerformAuditTemplateID desc

	declare @QuarterlyPerformanceAuditID table (QuarterlyPerformanceAuditID int)
	insert into dbo.QuarterlyPerformanceAudit (		
		 FlockID
		, QtrlyPerformAuditTemplateID
		, QuarterlyPerformanceAudit
		, DateCreated
		, Comments
	)
	output inserted.QuarterlyPerformanceAuditID into @QuarterlyPerformanceAuditID(QuarterlyPerformanceAuditID)
	select	
		@I_vFlockID
		, @I_vQtrlyPerformAuditTemplateID
		, 'Quarterly Performance for ' + (select flock from flock where FlockID = @I_vFlockID) + '; ' + convert(varchar(20), getdate(), 101)
		, getdate()
		, @I_vComments

	select top 1 @I_vQuarterlyPerformanceAuditID = QuarterlyPerformanceAuditID, @iRowID = QuarterlyPerformanceAuditID from @QuarterlyPerformanceAuditID

	insert into QuarterlyPerformanceAuditDetail(QuarterlyPerformanceAuditID, QtrlyPerformAuditTemplateItemID)
	select @I_vQuarterlyPerformanceAuditID, i.QtrlyPerformAuditTemplateItemID
	from QtrlyPerformAuditTemplateSection s
	inner join QtrlyPerformAuditTemplateItem i on s.QtrlyPerformAuditTemplateSectionID = i.QtrlyPerformAuditTemplateSectionID
	where s.QtrlyPerformAuditTemplateID = @I_vQtrlyPerformAuditTemplateID
	and s.IsActive = 1
	and i.IsActive = 1
	order by s.SortOrder, i.SortOrder
end
else
begin
	update QuarterlyPerformanceAudit 
		set Comments = @I_vComments
		, InspectedBy = @I_vInspectedBy
		, DateCreated = @I_vDateCreated
		, AuditStatusID = @I_vAuditStatusID
	where QuarterlyPerformanceAuditID = @I_vQuarterlyPerformanceAuditID
end

select @I_vQuarterlyPerformanceAuditID as ID,'forward' As referenceType


GO
