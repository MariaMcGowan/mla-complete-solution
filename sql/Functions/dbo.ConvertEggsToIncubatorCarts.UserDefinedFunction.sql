USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertEggsToIncubatorCarts]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ConvertEggsToIncubatorCarts]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertEggsToIncubatorCarts]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertEggsToIncubatorCarts]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[ConvertEggsToIncubatorCarts] (@EggCount int)
returns numeric(19,5)
as
begin
	declare @CartCount numeric(19,5)

	if @EggCount is null
		set @CartCount = 0
	else
		set @CartCount = convert(numeric(19,5),convert(numeric(19,5),isnull(@EggCount,0)) / 4608)

	return @CartCount
end

' 
END

GO
