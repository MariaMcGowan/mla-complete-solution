USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[UserGroup_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[UserGroup_Delete]
GO
/****** Object:  StoredProcedure [csb].[UserGroup_Delete]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[UserGroup_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[UserGroup_Delete] AS' 
END
GO


ALTER procedure [csb].[UserGroup_Delete]
@I_vUserGroupID int
, @O_iErrorState int=0 output 
, @oErrString varchar(255)='' output
, @iRowID int=0 output
AS

delete from csb.UserGroup where UserGroupID = @I_vUserGroupID


GO
