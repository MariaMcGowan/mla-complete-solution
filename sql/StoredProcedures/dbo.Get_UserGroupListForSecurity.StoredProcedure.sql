USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Get_UserGroupListForSecurity]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Get_UserGroupListForSecurity]
GO
/****** Object:  StoredProcedure [dbo].[Get_UserGroupListForSecurity]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_UserGroupListForSecurity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Get_UserGroupListForSecurity] AS' 
END
GO



ALTER PROC [dbo].[Get_UserGroupListForSecurity]
AS
	select ID=UserID
		   ,Name=case when isnull(ContactName, '')='' then UserID else ContactName end
		   ,[Type]=CONVERT(varchar(255), 'user')
       
	from csb.UserTable
	UNION
	select UserGroup,UserGroup,'group'
	from csb.UserGroup
	order by [Type], Name 



GO
