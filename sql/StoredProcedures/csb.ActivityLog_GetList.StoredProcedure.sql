USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[ActivityLog_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[ActivityLog_GetList]
GO
/****** Object:  StoredProcedure [csb].[ActivityLog_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[ActivityLog_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[ActivityLog_GetList] AS' 
END
GO

ALTER procedure [csb].[ActivityLog_GetList]
	@SupportIntervalID int,
	@PagePartID int,
	@UserID int,
	@IpAddressFilter varchar(4000),
	@UrlFilter varchar(4000),
	@UserAgentFilter varchar(4000)
as

declare @MAX_LENGTH int = 80

select l.ActivityLogID, l.LogDateTime, p.XmlScreenID, u.FullName as UserFullName,
		l.IsPost,
		l.IpAddress,
		case when LEN(l.Url) > @MAX_LENGTH 
			then SUBSTRING(l.Url, 0, @MAX_LENGTH) + '...' 
			else l.Url end as Url,
		case when LEN(l.UserAgent) > @MAX_LENGTH 
			then SUBSTRING(l.UserAgent, 0, @MAX_LENGTH) + '...' 
			else l.UserAgent end as UserAgent
	from csb.ActivityLog l
	join csb.SupportInterval si on si.SupportIntervalID = @SupportIntervalID
	left join csb.PagePart p on l.PagePartID = p.PagePartID
	left join csb.[User] u on l.UserID = u.UserID
	where l.LogDateTime > DATEADD(MINUTE, -si.MinuteCount, SYSDATETIME())
		and @PagePartID in (-1, l.PagePartID)
		and @UserID in (0, l.UserID)
		and l.IpAddress like '%' + @IpAddressFilter + '%'
		and l.Url like '%' + @UrlFilter + '%'
		and l.UserAgent like '%' + @UserAgentFilter + '%'
	order by l.LogDateTime desc, l.ActivityLogID desc

GO
