USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[PerformanceLog_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[PerformanceLog_Get]
GO
/****** Object:  StoredProcedure [csb].[PerformanceLog_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[PerformanceLog_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[PerformanceLog_Get] AS' 
END
GO


ALTER procedure [csb].[PerformanceLog_Get]
	@PerformanceLogID int
as

select l.PerformanceLogID, l.LogDateTime, u.FullName as UserFullName,
		p.XmlScreenID, l.Milliseconds, t.Name as PerformanceLogEntryTypeName, 
		l.Source, l.SourceDetail
	from csb.PerformanceLog l
	join csb.PerformanceLogEntryType t 
		on l.PerformanceLogEntryTypeID = t.PerformanceLogEntryTypeID
	left join csb.[User] u on l.UserID = u.UserID
	left join csb.PagePart p on l.PagePartID = p.PagePartID
	where l.PerformanceLogID = @PerformanceLogID


GO
