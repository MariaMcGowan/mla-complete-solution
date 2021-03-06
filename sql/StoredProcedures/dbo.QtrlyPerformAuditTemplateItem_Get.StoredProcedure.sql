USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QtrlyPerformAuditTemplateItem_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QtrlyPerformAuditTemplateItem_Get]
GO
/****** Object:  StoredProcedure [dbo].[QtrlyPerformAuditTemplateItem_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplateItem_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QtrlyPerformAuditTemplateItem_Get] AS' 
END
GO



ALTER proc [dbo].[QtrlyPerformAuditTemplateItem_Get]  @QtrlyPerformAuditTemplateSectionID int, @IncludeBlank bit = 0
As    

select @QtrlyPerformAuditTemplateSectionID = nullif(@QtrlyPerformAuditTemplateSectionID, '')

select QtrlyPerformAuditTemplateItemID
	, QtrlyPerformAuditTemplateSectionID
	, ItemText
	, SortOrder
	, DeleteItem = convert(bit, 0)
from QtrlyPerformAuditTemplateItem
where IsActive = 1
and QtrlyPerformAuditTemplateSectionID = @QtrlyPerformAuditTemplateSectionID
union all
select QtrlyPerformAuditTemplateItemID = convert(int, 0)
	, QtrlyPerformAuditTemplateSectionID = @QtrlyPerformAuditTemplateSectionID
	, ItemText = convert(varchar(200), null)
	, SortOrder = 100 + isnull((select max(SortOrder) from QtrlyPerformAuditTemplateItem where IsActive = 1 and QtrlyPerformAuditTemplateSectionID = @QtrlyPerformAuditTemplateSectionID),0)
	, DeleteItem = convert(bit, 0)
where @IncludeBlank = 1
order by SortOrder


GO
