USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[ActivityLog_GetListSummaryByUser]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[ActivityLog_GetListSummaryByUser]
GO
/****** Object:  StoredProcedure [csb].[ActivityLog_GetListSummaryByUser]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[ActivityLog_GetListSummaryByUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[ActivityLog_GetListSummaryByUser] AS' 
END
GO

ALTER procedure [csb].[ActivityLog_GetListSummaryByUser]
	@SupportIntervalID int,
	@PagePartID int,
	@UserID int,
	@IpAddressFilter varchar(4000),
	@UrlFilter varchar(4000),
	@UserAgentFilter varchar(4000)
as

select u.UserID, u.FullName, MIN(l.LogDateTime) as FirstLogDateTime, 
		MAX(l.LogDateTime) as LastLogDateTime, COUNT(l.ActivityLogID) as AccessCount,
		COUNT(distinct l.PagePartID) as PageCount, 
		COUNT(distinct l.IpAddress) as IpAddressCount
	from csb.[User] u
	join csb.SupportInterval si on si.SupportIntervalID = @SupportIntervalID
	left join csb.ActivityLog l on u.UserID = l.UserID
		and l.LogDateTime > DATEADD(MINUTE, -si.MinuteCount, SYSDATETIME())
		and l.IpAddress like '%' + @IpAddressFilter + '%'
		and l.Url like '%' + @UrlFilter + '%'
		and l.UserAgent like '%' + @UserAgentFilter + '%'
		and @PagePartID in (-1, l.PagePartID)
	where @UserID in (0, u.UserID)
	group by u.UserID, u.FullName
	order by COUNT(*) desc, LastLogDateTime desc, FirstLogDateTime desc, u.FullName

GO
