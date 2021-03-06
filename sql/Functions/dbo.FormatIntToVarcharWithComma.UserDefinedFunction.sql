USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[FormatIntToVarcharWithComma]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FormatIntToVarcharWithComma]
GO
/****** Object:  UserDefinedFunction [dbo].[FormatIntToVarcharWithComma]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FormatIntToVarcharWithComma]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[FormatIntToVarcharWithComma] (@Nbr int)
returns varchar(50)
as
begin

	declare @WhatsLeft varchar(50)
	declare @Return varchar(50)

	set @WhatsLeft = cast(@Nbr as varchar)
	set @Return = ''''

	while @WhatsLeft <> ''''
	begin
		if len(@WhatsLeft) > 3
		begin
			set @Return = '','' + right(@WhatsLeft,3) + @Return
			set @WhatsLeft = left(@WhatsLeft, len(@WhatsLeft) - 3)
		end
		else
		begin
			set @Return = @WhatsLeft + @Return
			set @WhatsLeft = ''''
		end

	end

	return @Return
end

' 
END

GO
