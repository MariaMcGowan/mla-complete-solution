USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[ActivityLog_Insert]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[ActivityLog_Insert]
GO
/****** Object:  StoredProcedure [csb].[ActivityLog_Insert]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[ActivityLog_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[ActivityLog_Insert] AS' 
END
GO

ALTER procedure [csb].[ActivityLog_Insert]
	@UserName varchar(255),
	@XmlScreenID varchar(255),
	@IsPost bit,
	@IpAddress varchar(39),
	@Url varchar(max),
	@UserAgent varchar(max)
as

declare @PROC_NAME varchar(255) = 'ActivityLog_Insert'

declare @UserID int = (
	select u.UserID
		from csb.[User] u
		where u.UserName = @UserName
	)
if @UserID is null begin
	declare @UserNotFoundMessage varchar(max) = 'User name not found: ' + @UserName
	exec csb.WarningLog_Insert @XmlScreenID=@XmlScreenID, @Source=@PROC_NAME, @Warning=@UserNotFoundMessage
end

declare @PagePartID int = (
	select p.PagePartID
		from csb.PagePart p
		where p.XmlScreenID = @XmlScreenID
	)
if @PagePartID is null begin
	declare @PagePartFoundMessage varchar(max) = 'XML screen ID not found: ' + @XmlScreenID
	exec csb.PagePart_Insert @PagePartID=@PagePartID output, @XmlScreenID=@XmlScreenID
	exec csb.WarningLog_Insert @UserID=@UserID, @Source=@PROC_NAME, @Warning=@PagePartFoundMessage
end

insert into csb.ActivityLog(LogDateTime, UserID, PagePartID, IsPost, IpAddress, Url, UserAgent) values
	(SYSDATETIME(), @UserID, @PagePartID, @IsPost, @IpAddress, @Url, @UserAgent)

GO
