USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[ActivityLog_GetListSummaryBySupportSubInterval]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[ActivityLog_GetListSummaryBySupportSubInterval]
GO
/****** Object:  StoredProcedure [csb].[ActivityLog_GetListSummaryBySupportSubInterval]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[ActivityLog_GetListSummaryBySupportSubInterval]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[ActivityLog_GetListSummaryBySupportSubInterval] AS' 
END
GO

ALTER procedure [csb].[ActivityLog_GetListSummaryBySupportSubInterval]
	@SupportIntervalID int,
	@SupportSubIntervalID int,
	@PagePartID int,
	@UserID int,
	@IpAddressFilter varchar(4000),
	@UrlFilter varchar(4000),
	@UserAgentFilter varchar(4000)
as

select LEFT(CONVERT(varchar(19), l.LogDateTime, 120), 
			ISNULL(ssi.SignificantLength, ssid.SignificantLength))
			+ ISNULL(ssi.InsignificantSuffix, ssid.InsignificantSuffix) as SubInterval, 
		MIN(l.LogDateTime) as FirstLogDateTime, 
		MAX(l.LogDateTime) as LastLogDateTime, COUNT(*) as AccessCount,
		COUNT(distinct l.UserID) as UserCount, 
		COUNT(distinct l.PagePartID) as PageCount, 
		COUNT(distinct l.IpAddress) as IpAddressCount
	from csb.ActivityLog l
	join csb.SupportInterval si on si.SupportIntervalID = @SupportIntervalID
	join csb.SupportSubInterval ssid on si.DefaultSupportSubIntervalID = ssid.SupportSubIntervalID
	left join csb.SupportSubInterval ssi on ssi.SupportSubIntervalID = @SupportSubIntervalID
	where l.LogDateTime > DATEADD(MINUTE, -si.MinuteCount, SYSDATETIME())
		and @PagePartID in (-1, l.PagePartID)
		and @UserID in (0, l.UserID)
		and l.IpAddress like '%' + @IpAddressFilter + '%'
		and l.Url like '%' + @UrlFilter + '%'
		and l.UserAgent like '%' + @UserAgentFilter + '%'
	group by LEFT(CONVERT(varchar(19), l.LogDateTime, 120), 
			ISNULL(ssi.SignificantLength, ssid.SignificantLength))
			+ ISNULL(ssi.InsignificantSuffix, ssid.InsignificantSuffix)
	order by SubInterval desc

GO
