USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QtrlyPerformAuditTemplateSection_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QtrlyPerformAuditTemplateSection_Get]
GO
/****** Object:  StoredProcedure [dbo].[QtrlyPerformAuditTemplateSection_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplateSection_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QtrlyPerformAuditTemplateSection_Get] AS' 
END
GO



ALTER proc [dbo].[QtrlyPerformAuditTemplateSection_Get]  @QtrlyPerformAuditTemplateID int = null, @QtrlyPerformAuditTemplateSectionID int = null, @IncludeBlank bit = 0
As    

select @QtrlyPerformAuditTemplateID = nullif(@QtrlyPerformAuditTemplateID, '')

select QtrlyPerformAuditTemplateSectionID
	, QtrlyPerformAuditTemplateID
	, SectionText
	, SortOrder
	, IsActive
	, DeleteSection = convert(bit, 0)
from QtrlyPerformAuditTemplateSection
where IsActive = 1
and QtrlyPerformAuditTemplateID = isnull(@QtrlyPerformAuditTemplateID, QtrlyPerformAuditTemplateID)
and QtrlyPerformAuditTemplateSectionID = isnull(@QtrlyPerformAuditTemplateSectionID, QtrlyPerformAuditTemplateSectionID)
union all
select QtrlyPerformAuditTemplateSectionID = convert(int, 0)
	, QtrlyPerformAuditTemplateID = @QtrlyPerformAuditTemplateID
	, SectionText = convert(varchar(200), null)
	, SortOrder = 100 + isnull((select max(SortOrder) from QtrlyPerformAuditTemplateSection where IsActive = 1 and QtrlyPerformAuditTemplateID = @QtrlyPerformAuditTemplateID),0)
	, IsActive = convert(bit, null)
	, DeleteSection = convert(bit, 0)
where @IncludeBlank = 1
order by SortOrder


GO
