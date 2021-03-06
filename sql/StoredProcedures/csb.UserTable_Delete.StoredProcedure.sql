USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[UserTable_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[UserTable_Delete]
GO
/****** Object:  StoredProcedure [csb].[UserTable_Delete]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[UserTable_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[UserTable_Delete] AS' 
END
GO
ALTER proc [csb].[UserTable_Delete]
@I_vUserTableID int
, @O_iErrorState int=0 output 
, @oErrString varchar(255)='' output
, @iRowID int=0 output
AS

delete from csb.UserTable where UserTableID = @I_vUserTableID
GO
