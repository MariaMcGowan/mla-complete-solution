USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetLotNbr]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetLotNbr]
GO
/****** Object:  UserDefinedFunction [dbo].[GetLotNbr]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLotNbr]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

create function [dbo].[GetLotNbr] (@DestinationBuildingID int, @DestinationBuilding varchar(3), @DeliveryDate date)
returns varchar(20)
as
begin
	select @DestinationBuildingID = isnull(nullif(@DestinationBuildingID, ''''),0)
	select @DestinationBuilding = isnull(nullif(@DestinationBuilding, ''''),''XX'')
	select @DeliveryDate = isnull(nullif(@DeliveryDate, ''''), getdate())

	declare @LotNbr varchar(20)

	if @DestinationBuildingID > 0
	begin
		select @DestinationBuilding = DestinationBuilding
		from DestinationBuilding
		where DestinationBuildingID = @DestinationBuildingID
	end
	else
	begin
		if left(@DestinationBuilding, 1) = ''B''
		begin
			select @DestinationBuilding = right(@DestinationBuilding, len(@DestinationBuilding)-1)
		end
	end
	
	select @LotNbr = convert(varchar(2), right(datepart(year, @DeliveryDate),2)) 
		+ right(''00'' + @DestinationBuilding,2)
		+ right(''000'' + convert(varchar(3), datepart(DAYOFYEAR, @DeliveryDate)),3)

	return @LotNbr
end


' 
END

GO
