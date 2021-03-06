USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ApplyWgtConversion]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ApplyWgtConversion]
GO
/****** Object:  UserDefinedFunction [dbo].[ApplyWgtConversion]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ApplyWgtConversion]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

create function [dbo].[ApplyWgtConversion] (@Wgt numeric(10,4))
returns numeric(10,4)
as
begin
	declare @ConvertedWgt numeric(10,4)

	set @ConvertedWgt = isnull(@Wgt,0) * (16/30)

	return @ConvertedWgt
end

' 
END

GO
