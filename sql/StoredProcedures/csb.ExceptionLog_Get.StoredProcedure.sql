USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[ExceptionLog_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[ExceptionLog_Get]
GO
/****** Object:  StoredProcedure [csb].[ExceptionLog_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[ExceptionLog_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[ExceptionLog_Get] AS' 
END
GO


ALTER procedure [csb].[ExceptionLog_Get]
	@ExceptionLogID int
as

select l.ExceptionLogID, l.LogDateTime, u.FullName as UserFullName,
		p.XmlScreenID, l.Method, l.Url, l.ExceptionSummary,
		l.ExceptionDetails, l.FormVariables, l.ServerVariables
	from csb.ExceptionLog l
	left join csb.[User] u on l.UserID = u.UserID
	left join csb.PagePart p on l.PagePartID = p.PagePartID
	where l.ExceptionLogID = @ExceptionLogID


GO
