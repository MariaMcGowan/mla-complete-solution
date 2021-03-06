USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCalculatedHenQty]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetCalculatedHenQty]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCalculatedHenQty]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCalculatedHenQty]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE function [dbo].[GetCalculatedHenQty] (@FarmID int, @TargetEmbryoCount int, @RoundToNearest int = 1)
returns int
as
begin
	if not exists (select 1 from FarmEmbryoStandardYield where FarmID = @FarmID)
	begin
		select top 1 @FarmID = FarmID from FarmEmbryoStandardYield order by FarmID
	end

	declare @CalculatedHenCount int
	declare @SettableEggsPercentForWeek numeric(8,4)

	select @SettableEggsPercentForWeek = SettableEggsPercentForWeek
	from FarmEmbryoStandardYield
	where FarmID = @FarmID and WeekNumber = 24

	select @CalculatedHenCount = Round(@TargetEmbryoCount / @SettableEggsPercentForWeek, 0)
	
	-- Round up to nearest hundred
	select @CalculatedHenCount = floor((@CalculatedHenCount + (@RoundToNearest - 1)) / @RoundToNearest) * @RoundToNearest

	return @CalculatedHenCount

end

' 
END

GO
