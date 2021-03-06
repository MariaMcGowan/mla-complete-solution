USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertEggsToTrays]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ConvertEggsToTrays]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertEggsToTrays]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertEggsToTrays]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[ConvertEggsToTrays] (@Eggs int)
returns numeric(19,5)
as
begin
	return convert(numeric(19,5),IsNull(@Eggs,0) / 36)
end

' 
END

GO
