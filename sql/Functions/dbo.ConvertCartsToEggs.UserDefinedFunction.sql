USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertCartsToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ConvertCartsToEggs]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertCartsToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertCartsToEggs]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

create function [dbo].[ConvertCartsToEggs] (@CartCnt int)
returns int
as
begin
	declare @EggCnt int

	if @CartCnt is null
		set @EggCnt = 0
	else
		set @EggCnt = isnull(@CartCnt,0) * 4320

	return @EggCnt
end

' 
END

GO
