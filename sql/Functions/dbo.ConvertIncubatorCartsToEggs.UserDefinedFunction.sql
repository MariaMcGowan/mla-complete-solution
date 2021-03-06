USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertIncubatorCartsToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ConvertIncubatorCartsToEggs]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertIncubatorCartsToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertIncubatorCartsToEggs]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[ConvertIncubatorCartsToEggs] (@Racks int)
returns int
as
begin
	return convert(int,ROUND(@Racks * 4608,0))
end

' 
END

GO
