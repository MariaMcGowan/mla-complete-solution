USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PADLSTemplate_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PADLSTemplate_Get]
GO
/****** Object:  StoredProcedure [dbo].[PADLSTemplate_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplate_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PADLSTemplate_Get] AS' 
END
GO



ALTER proc [dbo].[PADLSTemplate_Get]  @PADLSTemplateID int = null, @IncludeBlank bit = 0
As    

select @PADLSTemplateID = nullif(@PADLSTemplateID, '')

select 
	PADLSTemplateID
	, PADLSTemplateDescr
	, IsActive
from PADLSTemplate
where IsActive = 1
and PADLSTemplateID = isnull(@PADLSTemplateID, PADLSTemplateID)
union all
select 
	PADLSTemplateID = convert(int, 0)
	, PADLSTemplateDescr = convert(varchar(200), null)
	, IsActive = convert(bit, null)
where @IncludeBlank = 1


GO
