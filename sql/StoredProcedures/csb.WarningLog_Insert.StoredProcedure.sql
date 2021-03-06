USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[WarningLog_Insert]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[WarningLog_Insert]
GO
/****** Object:  StoredProcedure [csb].[WarningLog_Insert]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[WarningLog_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[WarningLog_Insert] AS' 
END
GO

ALTER procedure [csb].[WarningLog_Insert]
	@UserName varchar(255) = null,
	@UserID int = null,
	@XmlScreenID varchar(255) = null,
	@PagePartID int = null,
	@Source varchar(max),
	@Warning varchar(max)
as
declare @MAX_LOG_ROWS int = 32000

declare @LogRowCount int = (
	select COUNT(*)
		from csb.WarningLog
	)
	
if @LogRowCount <= @MAX_LOG_ROWS begin

	if @UserID is null and @UserName is not null begin
		select @UserID = u.UserID
			from csb.[User] u
			where u.UserName = @UserName
	end

	if @PagePartID is null and @XmlScreenID is not null begin
		select @PagePartID = p.PagePartID
			from csb.PagePart p
			where p.XmlScreenID = @XmlScreenID
	end

	insert into csb.WarningLog(LogDateTime, UserID, PagePartID, Source, Warning) values
		(SYSDATETIME(), @UserID, @PagePartID, LEFT(@Source, 255), LEFT(@Warning, 255))

end

GO
