USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[ExceptionLog_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[ExceptionLog_GetList]
GO
/****** Object:  StoredProcedure [csb].[ExceptionLog_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[ExceptionLog_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[ExceptionLog_GetList] AS' 
END
GO


ALTER PROCEDURE [csb].[ExceptionLog_GetList]
	@SupportIntervalID int,
	@PagePartID int,
	@UserID int,
	@ExceptionSummaryFilter varchar(4000),
	@MethodFilter varchar(4000),
	@UrlFilter varchar(4000)
AS

declare @MAX_LENGTH int = 80

select l.ExceptionLogID, l.LogDateTime, p.XmlScreenID, u.FullName as UserFullName,
		case when LEN(l.ExceptionSummary) > @MAX_LENGTH 
			then SUBSTRING(l.ExceptionSummary, 0, @MAX_LENGTH) + '...' 
			else l.ExceptionSummary end as ExceptionSummary,
		l.Method,
		case when LEN(l.Url) > @MAX_LENGTH 
			then SUBSTRING(l.Url, 0, @MAX_LENGTH) + '...' 
			else l.Url end as Url
	from csb.ExceptionLog l
	join csb.SupportInterval si on si.SupportIntervalID = @SupportIntervalID
	left join csb.PagePart p on l.PagePartID = p.PagePartID
	left join csb.[User] u on l.UserID = u.UserID
	where l.LogDateTime > DATEADD(MINUTE, -si.MinuteCount, SYSDATETIME())
		and @PagePartID in (-1, l.PagePartID)
		and @UserID in (0, l.UserID)
		and l.ExceptionSummary like '%' + @ExceptionSummaryFilter + '%'
		and l.Method like '%' + @MethodFilter + '%'
		and l.Url like '%' + @UrlFilter + '%'
	order by l.LogDateTime desc, l.ExceptionLogID desc


GO
