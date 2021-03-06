USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QtrlyPerformAuditTemplate_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QtrlyPerformAuditTemplate_Get]
GO
/****** Object:  StoredProcedure [dbo].[QtrlyPerformAuditTemplate_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplate_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QtrlyPerformAuditTemplate_Get] AS' 
END
GO



ALTER proc [dbo].[QtrlyPerformAuditTemplate_Get]  @QtrlyPerformAuditTemplateID int = null, @IncludeBlank bit = 0
As    

select @QtrlyPerformAuditTemplateID = nullif(@QtrlyPerformAuditTemplateID, '')

select 
	QtrlyPerformAuditTemplateID
	, QtrlyPerformAuditTemplateDescr
	, IsActive
from QtrlyPerformAuditTemplate
where IsActive = 1 and  QtrlyPerformAuditTemplateID = isnull(@QtrlyPerformAuditTemplateID, QtrlyPerformAuditTemplateID)
union all
select 
	QtrlyPerformAuditTemplateID = convert(int, 0)
	, QtrlyPerformAuditTemplateDescr = convert(varchar(200), null)
	, IsActive = convert(bit, null)
where @IncludeBlank = 1


GO
