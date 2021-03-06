USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertDeliveryShelvesToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ConvertDeliveryShelvesToEggs]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertDeliveryShelvesToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertDeliveryShelvesToEggs]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[ConvertDeliveryShelvesToEggs] (@Shelves int)
returns int
as
begin
	return convert(int,ROUND(@Shelves * 1080,0))
end

' 
END

GO
