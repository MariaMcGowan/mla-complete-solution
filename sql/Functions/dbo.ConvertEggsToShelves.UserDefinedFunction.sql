USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertEggsToShelves]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ConvertEggsToShelves]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertEggsToShelves]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertEggsToShelves]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

create function [dbo].[ConvertEggsToShelves] (@EggCnt int)
returns int
as
begin
	declare @ShelfCnt int

	if @EggCnt is null
		set @ShelfCnt = 0
	else
		set @ShelfCnt = round(@EggCnt / 144,0,1)

	return @ShelfCnt
end

' 
END

GO
