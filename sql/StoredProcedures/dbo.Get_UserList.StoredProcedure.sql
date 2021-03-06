USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Get_UserList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Get_UserList]
GO
/****** Object:  StoredProcedure [dbo].[Get_UserList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_UserList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Get_UserList] AS' 
END
GO



ALTER PROC [dbo].[Get_UserList]
	@IncludeNew bit=0
AS
	SET NOCOUNT ON
	select [UserTableID]
		  ,[UserID]
		  ,[eMailAddress]
		  ,[UserGroupID]
		  ,[ContactName]
		  ,[Inactive]
	from csb.UserTable
	UNION
	select 0, '{new record}', NULL,0
		   ,NULL
		   ,NULL
	where @IncludeNew=1
	order by 1



GO
