USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertIncubatorCartColumnsToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ConvertIncubatorCartColumnsToEggs]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertIncubatorCartColumnsToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertIncubatorCartColumnsToEggs]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[ConvertIncubatorCartColumnsToEggs] (@IncubatorCartColumn numeric(19,5))
returns numeric(19,5)
as
begin
	declare @EggCount int

	if @IncubatorCartColumn is null
		set @EggCount = 0
	else
		set @EggCount = isnull(@IncubatorCartColumn,0) * 2304

	return @EggCount
end

' 
END

GO
