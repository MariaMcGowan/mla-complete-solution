USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[ActivityLog_GetListSummaryByPage]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[ActivityLog_GetListSummaryByPage]
GO
/****** Object:  StoredProcedure [csb].[ActivityLog_GetListSummaryByPage]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[ActivityLog_GetListSummaryByPage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[ActivityLog_GetListSummaryByPage] AS' 
END
GO

ALTER procedure [csb].[ActivityLog_GetListSummaryByPage]
	@SupportIntervalID int,
	@PagePartID int,
	@UserID int,
	@IpAddressFilter varchar(4000),
	@UrlFilter varchar(4000),
	@UserAgentFilter varchar(4000)
as

select p.PagePartID, p.XmlScreenID, MIN(l.LogDateTime) as FirstLogDateTime, 
		MAX(l.LogDateTime) as LastLogDateTime, COUNT(l.ActivityLogID) as AccessCount,
		COUNT(distinct l.UserID) as UserCount, 
		COUNT(distinct l.IpAddress) as IpAddressCount
	from csb.PagePart p
	join csb.PagePartType t on p.PagePartTypeID = t.PagePartTypeID
	join csb.SupportInterval si on si.SupportIntervalID = @SupportIntervalID
	left join csb.ActivityLog l on p.PagePartID = l.PagePartID
		and l.LogDateTime > DATEADD(MINUTE, -si.MinuteCount, SYSDATETIME())
		and @UserID in (0, l.UserID)
		and l.IpAddress like '%' + @IpAddressFilter + '%'
		and l.Url like '%' + @UrlFilter + '%'
		and l.UserAgent like '%' + @UserAgentFilter + '%'
	where (p.PagePartID = @PagePartID
			or (@PagePartID = -1 
				and (l.PagePartID is not null 
					or t.IsPrimaryPage = 1)))
	group by p.PagePartID, p.XmlScreenID
	order by COUNT(*) desc, LastLogDateTime desc, FirstLogDateTime desc, p.XmlScreenID

GO
