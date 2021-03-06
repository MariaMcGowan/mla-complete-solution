USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertRacksToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ConvertRacksToEggs]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertRacksToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertRacksToEggs]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

create function [dbo].[ConvertRacksToEggs] (@RackCnt int)
returns int
as
begin
	declare @EggCnt int

	set @EggCnt = @RackCnt * 4608

	return @EggCnt
end

' 
END

GO
