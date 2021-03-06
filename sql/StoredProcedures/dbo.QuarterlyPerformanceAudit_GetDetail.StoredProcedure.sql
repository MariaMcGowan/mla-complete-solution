USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_GetDetail]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QuarterlyPerformanceAudit_GetDetail]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_GetDetail]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAudit_GetDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QuarterlyPerformanceAudit_GetDetail] AS' 
END
GO




ALTER proc [dbo].[QuarterlyPerformanceAudit_GetDetail]  @QuarterlyPerformanceAuditID int = null, @SectionNumber int = null
As    

select @QuarterlyPerformanceAuditID = nullif(@QuarterlyPerformanceAuditID, '')
	, @SectionNumber = nullif(@SectionNumber, '')

declare @QtrlyPerformAuditTemplateID int
declare @Sections table (QtrlyPerformAuditTemplateSectionID int, QtrlyPerformAuditTemplateID int, SectionNumber int, SectionText varchar(200))

select @QtrlyPerformAuditTemplateID	= QtrlyPerformAuditTemplateID
from QuarterlyPerformanceAudit 
where QuarterlyPerformanceAuditID = @QuarterlyPerformanceAuditID


insert into @Sections (QtrlyPerformAuditTemplateSectionID, QtrlyPerformAuditTemplateID, SectionNumber, SectionText)
select QtrlyPerformAuditTemplateSectionID, QtrlyPerformAuditTemplateID, SectionNumber = ROW_NUMBER() over (order by SortOrder), SectionText
from QtrlyPerformAuditTemplateSection
where QtrlyPerformAuditTemplateID = @QtrlyPerformAuditTemplateID
and IsActive = 1
order by SortOrder


select a.QuarterlyPerformanceAuditID, 
i.QtrlyPerformAuditTemplateItemID, ItemText, ItemSortOrder = i.SortOrder, 
SectionNumber, SectionText, d.QuarterlyPerformanceAuditDetailID, 
--d.ItemAcceptable
its.ItemStatus, d.ItemStatusID, a.AuditStatusID, AuditStatus, Comments
from QuarterlyPerformanceAudit a
inner join @Sections s on a.QtrlyPerformAuditTemplateID = s.QtrlyPerformAuditTemplateID
inner join QtrlyPerformAuditTemplateItem i on s.QtrlyPerformAuditTemplateSectionID = i.QtrlyPerformAuditTemplateSectionID
left outer join QuarterlyPerformanceAuditDetail d on i.QtrlyPerformAuditTemplateItemID = d.QtrlyPerformAuditTemplateItemID and a.QuarterlyPerformanceAuditID = d.QuarterlyPerformanceAuditID
left outer join AuditStatus st on a.AuditStatusID = st.AuditStatusID
left outer join ItemStatus its on d.ItemStatusID = its.ItemStatusID
where @QuarterlyPerformanceAuditID is not null
and a.QtrlyPerformAuditTemplateID = @QtrlyPerformAuditTemplateID
and a.QuarterlyPerformanceAuditID = @QuarterlyPerformanceAuditID
and s.SectionNumber = isnull(@SectionNumber, s.SectionNumber)
and i.IsActive = 1



GO
