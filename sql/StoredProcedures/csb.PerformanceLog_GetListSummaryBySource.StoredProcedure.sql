USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[PerformanceLog_GetListSummaryBySource]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[PerformanceLog_GetListSummaryBySource]
GO
/****** Object:  StoredProcedure [csb].[PerformanceLog_GetListSummaryBySource]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[PerformanceLog_GetListSummaryBySource]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[PerformanceLog_GetListSummaryBySource] AS' 
END
GO


ALTER procedure [csb].[PerformanceLog_GetListSummaryBySource]
	@SupportIntervalID int,
	@PagePartID int,
	@UserID int,
	@PerformanceLogEntryTypeID int,
	@SourceFilter varchar(4000),
	@SourceDetailFilter varchar(4000)
as

declare @MAX_LENGTH int = 80

select case when LEN(l.Source) > @MAX_LENGTH 
			then SUBSTRING(l.Source, 0, @MAX_LENGTH) + '...' 
			else l.Source end as Source,
		t.Name as PerformanceLogEntryTypeName, 
		MIN(l.LogDateTime) as FirstLogDateTime, 
		MAX(l.LogDateTime) as LastLogDateTime, 
		COUNT(*) as LogEntryCount,
		COUNT(distinct l.UserID) as UserCount, 
		COUNT(distinct l.PagePartID) as PageCount, 
		AVG(l.Milliseconds) as MillisecondsAverage, 
		SUM(cast(l.Milliseconds as bigint)) as MillisecondsSum, 
		MIN(l.Milliseconds) as MillisecondsMin, 
		MAX(l.Milliseconds) as MillisecondsMax
	from csb.PerformanceLog l
	join csb.PerformanceLogEntryType t on l.PerformanceLogEntryTypeID = t.PerformanceLogEntryTypeID
	join csb.SupportInterval si on si.SupportIntervalID = @SupportIntervalID
	left join csb.PagePart p on l.PagePartID = p.PagePartID
	where l.LogDateTime > DATEADD(MINUTE, -si.MinuteCount, SYSDATETIME())
		and @PagePartID in (-1, l.PagePartID)
		and @UserID in (0, l.UserID)
		and @PerformanceLogEntryTypeID in (-1, l.PerformanceLogEntryTypeID)
		and l.Source like '%' + @SourceFilter + '%'
		and l.SourceDetail like '%' + @SourceDetailFilter + '%'
	group by l.Source, t.Name
	order by SUM(cast(l.Milliseconds as bigint)) desc, COUNT(*) desc


GO
