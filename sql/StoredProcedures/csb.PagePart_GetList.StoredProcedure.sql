USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[PagePart_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[PagePart_GetList]
GO
/****** Object:  StoredProcedure [csb].[PagePart_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[PagePart_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[PagePart_GetList] AS' 
END
GO


ALTER procedure [csb].[PagePart_GetList]
	@IncludeAll bit = 0
as
	select p.XmlScreenID, p.PagePartID, 2 as Sequence
		from csb.PagePart p
		join csb.PagePartType pt on p.PagePartTypeID = pt.PagePartTypeID
		where pt.IsPrimaryPage = 1
	union
	select 'All', -1, 1
		where @IncludeAll = 1
	order by Sequence, XmlScreenID


GO
