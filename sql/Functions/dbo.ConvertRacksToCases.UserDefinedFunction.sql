USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertRacksToCases]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ConvertRacksToCases]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertRacksToCases]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertRacksToCases]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

create function [dbo].[ConvertRacksToCases] (@RackCnt int)
returns int
as
begin
	declare @CaseCnt int

	if @RackCnt is null
		set @CaseCnt = 0
	else
		set @CaseCnt = (@RackCnt * 4608) / 360

	return @CaseCnt
end

' 
END

GO
