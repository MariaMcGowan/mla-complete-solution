USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPlannedEmbryoQty]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetPlannedEmbryoQty]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPlannedEmbryoQty]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPlannedEmbryoQty]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[GetPlannedEmbryoQty] (@FarmID int, @Week int, @PulletQty int)
returns int
as
begin
	declare @Return int

	if not exists (select 1 from FarmEmbryoStandardYield where FarmID = @FarmID)
	begin
		select top 1 @FarmID = FarmID from FarmEmbryoStandardYield order by FarmID
	end

	select @Return = Ceiling(SettableEggsPercentForWeek * @PulletQty)
	from FarmEmbryoStandardYield
	where FarmID = @FarmID 
	and WeekNumber = @Week

	return @Return

end
' 
END

GO
