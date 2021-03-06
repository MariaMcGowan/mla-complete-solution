USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertTraysToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ConvertTraysToEggs]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertTraysToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertTraysToEggs]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[ConvertTraysToEggs] (@Trays int)
returns int
as
begin
	return convert(int,ROUND(@Trays * 36,0))
end

' 
END

GO
