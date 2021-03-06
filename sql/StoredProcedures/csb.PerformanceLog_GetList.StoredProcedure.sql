USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[PerformanceLog_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[PerformanceLog_GetList]
GO
/****** Object:  StoredProcedure [csb].[PerformanceLog_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[PerformanceLog_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[PerformanceLog_GetList] AS' 
END
GO


ALTER procedure [csb].[PerformanceLog_GetList]
	@SupportIntervalID int,
	@PagePartID int,
	@UserID int,
	@PerformanceLogEntryTypeID int,
	@SourceFilter varchar(4000),
	@SourceDetailFilter varchar(4000)
as

declare @MAX_LENGTH int = 80

select l.PerformanceLogID, l.LogDateTime, p.XmlScreenID, u.FullName as UserFullName,
		l.Milliseconds, t.Name as PerformanceLogEntryTypeName,
		case when LEN(l.Source) > @MAX_LENGTH 
			then SUBSTRING(l.Source, 0, @MAX_LENGTH) + '...' 
			else l.Source end as Source,
		case when LEN(l.SourceDetail) > @MAX_LENGTH 
			then SUBSTRING(l.SourceDetail, 0, @MAX_LENGTH) + '...' 
			else l.SourceDetail end as SourceDetail
	from csb.PerformanceLog l
	join csb.PerformanceLogEntryType t 
		on l.PerformanceLogEntryTypeID = t.PerformanceLogEntryTypeID
	join csb.SupportInterval si on si.SupportIntervalID = @SupportIntervalID
	left join csb.PagePart p on l.PagePartID = p.PagePartID
	left join csb.[User] u on l.UserID = u.UserID
	where l.LogDateTime > DATEADD(MINUTE, -si.MinuteCount, SYSDATETIME())
		and @PagePartID in (-1, l.PagePartID)
		and @UserID in (0, l.UserID)
		and @PerformanceLogEntryTypeID in (-1, l.PerformanceLogEntryTypeID)
		and l.Source like '%' + @SourceFilter + '%'
		and l.SourceDetail like '%' + @SourceDetailFilter + '%'
	order by l.LogDateTime desc, l.PerformanceLogID desc


GO
