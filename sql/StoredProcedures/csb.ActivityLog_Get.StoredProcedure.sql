USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[ActivityLog_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[ActivityLog_Get]
GO
/****** Object:  StoredProcedure [csb].[ActivityLog_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[ActivityLog_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[ActivityLog_Get] AS' 
END
GO

ALTER procedure [csb].[ActivityLog_Get]
	@ActivityLogID int
as

select l.ActivityLogID, l.LogDateTime, u.FullName as UserFullName,
		p.XmlScreenID, l.IsPost, l.IpAddress, l.Url, l.UserAgent
	from csb.ActivityLog l
	left join csb.[User] u on l.UserID = u.UserID
	left join csb.PagePart p on l.PagePartID = p.PagePartID
	where l.ActivityLogID = @ActivityLogID

GO
