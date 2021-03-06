USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[UserTable_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[UserTable_InsertUpdate]
GO
/****** Object:  StoredProcedure [csb].[UserTable_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[UserTable_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[UserTable_InsertUpdate] AS' 
END
GO


ALTER PROC [csb].[UserTable_InsertUpdate] (
	@I_vUserTableID int
	, @I_vUserID varchar(255)
	, @I_veMailAddress varchar(255)
	, @I_vUserGroupID int = 1
	, @I_vContactName varchar(255)
	, @I_vInactive bit = 0
	, @O_iErrorState int=0 output 
	, @oErrString varchar(255)='' output
	, @iRowID int=0 output
) 
AS
	
IF (SELECT COUNT(*) FROM csb.UserTable WHERE UserTableID=@I_vUserTableID) > 0
BEGIN
	UPDATE csb.UserTable
	Set
		UserID = @I_vUserID
		, eMailAddress = @I_veMailAddress
		, UserGroupID = @I_vUserGroupID
		, ContactName = @I_vContactName
		, Inactive = @I_vInactive
	WHERE 
		UserTableID = @I_vUserTableID
END
ELSE
BEGIN
	INSERT INTO csb.UserTable (
		UserID
		, eMailAddress
		, UserGroupID
		, ContactName
		, Inactive
	) VALUES (
		@I_vUserID
		, @I_veMailAddress
		, @I_vUserGroupID
		, @I_vContactName
		, (CASE WHEN @I_vInactive = 'True' THEN 1 ELSE 0 END)
	)
END

GO
