USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetLotNbrForOrder]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetLotNbrForOrder]
GO
/****** Object:  UserDefinedFunction [dbo].[GetLotNbrForOrder]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLotNbrForOrder]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE function [dbo].[GetLotNbrForOrder] (@OrderID int)
returns varchar(20)
as
begin
	declare @DestinationBuilding varchar(2)
		, @DeliveryDate date
		, @LotNbr varchar(20)

	select @DestinationBuilding = db.DestinationBuilding
		, @DeliveryDate = o.DeliveryDate
	from [Order] o
	inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
	where OrderID = @OrderID

	select @LotNbr = convert(varchar(2), right(datepart(year, @DeliveryDate),2)) 
		+ right(''00'' + @DestinationBuilding,2)
		+ right(''000'' + convert(varchar(3), datepart(DAYOFYEAR, @DeliveryDate)),3)

	return @LotNbr
end


' 
END

GO
