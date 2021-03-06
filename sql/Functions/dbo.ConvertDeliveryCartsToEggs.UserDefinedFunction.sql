USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertDeliveryCartsToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[ConvertDeliveryCartsToEggs]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertDeliveryCartsToEggs]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConvertDeliveryCartsToEggs]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create function [dbo].[ConvertDeliveryCartsToEggs] (@DeliveryCarts int)
returns int
as
begin
	return @DeliveryCarts * 4320
end

' 
END

GO
