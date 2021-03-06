USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[StripOutMoneyFormat]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[StripOutMoneyFormat]
GO
/****** Object:  UserDefinedFunction [dbo].[StripOutMoneyFormat]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StripOutMoneyFormat]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[StripOutMoneyFormat] (@Nbr varchar(255))
returns money
as
begin
	return convert(money, replace(replace(replace(replace(@Nbr, ''$'', ''''), '','', ''''), '')'', ''''), ''('', ''-''))
end' 
END

GO
