USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[SystemConstant_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SystemConstant_Delete]
GO
/****** Object:  StoredProcedure [dbo].[SystemConstant_Delete]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SystemConstant_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SystemConstant_Delete] AS' 
END
GO



ALTER proc [dbo].[SystemConstant_Delete] 
	-- ID field
	@SystemConstantID int = null
as

select @SystemConstantID = nullif(@SystemConstantID, '')

if @SystemConstantID is not null
begin
	update SystemConstant set IsActive = 0 where SystemConstantID = @SystemConstantID
end



GO
