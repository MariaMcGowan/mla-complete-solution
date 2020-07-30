/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_GetReport]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QuarterlyPerformanceAudit_GetReport]
GO
/****** Object:  StoredProcedure [dbo].[QuarterlyPerformanceAudit_GetReport]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAudit_GetReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QuarterlyPerformanceAudit_GetReport] AS' 
END
GO




ALTER proc [dbo].[QuarterlyPerformanceAudit_GetReport]  @QuarterlyPerformanceAuditID int
As    

select a.QuarterlyPerformanceAuditID, f.FarmNumber,
a.DateCreated, a.InspectedBy,
i.QtrlyPerformAuditTemplateItemID, ItemText, ItemSortOrder = i.SortOrder, 
SectionNumber = s.QtrlyPerformAuditTemplateSectionID, SectionText, d.QuarterlyPerformanceAuditDetailID, 
Acceptable = 
	case
		when isnull(it.ItemStatus, '') = 'Acceptable' then 'X'
		when isnull(it.ItemStatus, '') = 'N/A' then 'N/A'
		else ''
	end, 
Unacceptable = 
	case
		when isnull(it.ItemStatus, '') = 'Unacceptable' then 'X'
		when isnull(it.ItemStatus, '') = 'N/A' then 'N/A'
		else ''
	end, 
AuditStatus, Comments, QuarterlyPerformanceAudit
from QuarterlyPerformanceAudit a
inner join Flock fl on a.FlockID = fl.FlockID
inner join Farm f on fl.FarmID = f.FarmID
inner join QtrlyPerformAuditTemplateSection s on a.QtrlyPerformAuditTemplateID = s.QtrlyPerformAuditTemplateID
inner join QtrlyPerformAuditTemplateItem i on s.QtrlyPerformAuditTemplateSectionID = i.QtrlyPerformAuditTemplateSectionID
left outer join QuarterlyPerformanceAuditDetail d on i.QtrlyPerformAuditTemplateItemID = d.QtrlyPerformAuditTemplateItemID and a.QuarterlyPerformanceAuditID = d.QuarterlyPerformanceAuditID
left outer join AuditStatus st on a.AuditStatusID = st.AuditStatusID
left outer join ItemStatus it on d.ItemStatusID = it.ItemStatusID
where a.QuarterlyPerformanceAuditID = @QuarterlyPerformanceAuditID
and i.IsActive = 1



GO
