USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertToNumeric]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ConvertToNumeric]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertToNumeric]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertToNumeric]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[ConvertToNumeric]
(
	-- Add the parameters for the function here
	@Text varchar(255)--, @Decimals int
)
RETURNS float
AS
BEGIN
	
	declare @Work as varchar(255)
	declare @Return float

	set @Work = @Text
	set @Work = replace(replace(replace(replace(@Work, '','', ''''), '' '', ''''), ''-'',''''), ''%'','''')
	set @Work = replace(replace(@Work, char(10), ''''), char(13), '''')


	if isnumeric(@Work) = 0
	begin
		set @Return = null
	end
	else
	begin
		set @Return = cast(@Work as float)

		if right(@Text,1) = ''%''
		begin
			set @Return = @Return / 100
		end
	end
			

	RETURN @Return

END
' 
END

GO
