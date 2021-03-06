USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[FormatFloatToMoney]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FormatFloatToMoney]
GO
/****** Object:  UserDefinedFunction [dbo].[FormatFloatToMoney]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FormatFloatToMoney]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[FormatFloatToMoney] (@Nbr Float)
returns varchar(50)
as
begin

	declare @WhatsLeft varchar(50)
	declare @Return varchar(50)
	declare @Change numeric(2,2)
	declare @Negative bit = 0

	set @Nbr = round(@Nbr,2)

	if @Nbr < 0 
	begin
		set @Negative = 1
		set @Nbr = ABS(@Nbr)
	end

	set @Change = round(@Nbr, 2) - Floor(@Nbr)

	set @WhatsLeft = cast(cast(@Nbr as int) as varchar)
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

	set @Return = @Return + right(cast(@Change as varchar), 3)

	
	if @Negative = 1
	begin
		set @Return = ''('' + @Return + '')''
	end
	
	return @Return
end
' 
END

GO
