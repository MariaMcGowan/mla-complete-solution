USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[SystemContstant_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SystemContstant_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[SystemContstant_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SystemContstant_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SystemContstant_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[SystemContstant_InsertUpdate] 
	@I_vSystemConstantID int = null,
    @I_vConstantName varchar(100) = null,
    @I_vConstantValue numeric(8,6) = null, 
	@O_iErrorState int=0 output,
	@oErrString varchar(255)='' output,
	@iRowID varchar(255)=NULL output

	as

if @I_vSystemConstantID = 0
begin
	-- This is a new system constant
	insert into SystemConstant(ConstantName, ConstantValue)
	select @I_vConstantName, @I_vConstantValue

	set @I_vSystemConstantID = SCOPE_IDENTITY() 
end
else
begin
	update SystemConstant
		set ConstantName = @I_vConstantName, 
		ConstantValue = @I_vConstantValue
	where SystemConstantID = @I_vSystemConstantID
end

set @iRowID = @I_vSystemConstantID


select @I_vSystemConstantID as SystemConstantID,'forward' As referenceType



GO
