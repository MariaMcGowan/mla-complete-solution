USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[UserGroup_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[UserGroup_InsertUpdate]
GO
/****** Object:  StoredProcedure [csb].[UserGroup_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[UserGroup_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[UserGroup_InsertUpdate] AS' 
END
GO

ALTER procedure [csb].[UserGroup_InsertUpdate]
@I_vUserGroupID int
,@I_vUserGroup nvarchar(255)
, @O_iErrorState int=0 output 
, @oErrString varchar(255)='' output
, @iRowID int=0 output
AS

If @I_vUserGroupID = 0
begin
	insert into csb.UserGroup (UserGroup)
		select @I_vUserGroup
	select @I_vUserGroupID = SCOPE_IDENTITY(), @iRowID = SCOPE_IDENTITY()
end
else
begin
	update csb.UserGroup
	set UserGroup = @I_vUserGroup
	where UserGroupID = @I_vUserGroupID

	select @iRowID = @I_vUserGroupID
end


GO
