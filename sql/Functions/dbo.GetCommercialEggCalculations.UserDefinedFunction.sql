USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCommercialEggCalculations]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetCommercialEggCalculations]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCommercialEggCalculations]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommercialEggCalculations]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create FUNCTION [dbo].[GetCommercialEggCalculations]
(
	-- Add the parameters for the function here
	@FarmID int,
	@16WeekPulletQty int
)
RETURNS 
@Values TABLE 
(
	-- Add the column definitions for the TABLE variable here
	WeekNumber int,
	CalcCommercialEggsPerDay int,
	CalcSettableEggsPerDay int,
	EggWeightClassificationID int
)
AS
BEGIN
	declare @Data Table (WeekNumber int, 
		CalcTotalEggsPerDay int, 
		FloorEggPercent numeric(10,8),
		CalcFloorEggsPerDay int,
		SettableEggPercent numeric(10,8),
		CalcSettableEggsPerDay int,
		EggWeightClassificationID int)

	-- Must have either the Current Pullet Qty or the 16 Week Pullet Qty
	if not exists (select 1 from FarmEmbryoStandardYield where FarmID = @FarmID)
	begin
		select top 1 @FarmID = FarmID from FarmEmbryoStandardYield order by FarmID
	end




	insert into @Data (WeekNumber, CalcTotalEggsPerDay, FloorEggPercent, EggWeightClassificationID, SettableEggPercent)
	select WeekNumber, CalcTotalEggsPerDay = round((@16WeekPulletQty * CumulativeLivabilityPercent * LayPercent),0), FloorEggPercent,
	case
		when CaseWeight < 36 then 1
		when CaseWeight < 43 then 2
		when CaseWeight < 49 then 3
		else 4
	end, SettableEggsPercentForWeek
	from FarmEmbryoStandardYield
	where FarmID = @FarmID
	
	update @Data set CalcFloorEggsPerDay = round((CalcTotalEggsPerDay * FloorEggPercent),0), 
	CalcSettableEggsPerDay = round((CalcTotalEggsPerDay * SettableEggPercent),0)

	insert into @Values (WeekNumber, CalcSettableEggsPerDay, CalcCommercialEggsPerDay, EggWeightClassificationID)
	select WeekNumber, CalcSettableEggsPerDay,
	CalcCommercialEggsPerDay = isnull(CalcTotalEggsPerDay,0) - isnull(CalcFloorEggsPerDay,0) - isnull(CalcSettableEggsPerDay, 0), 
	EggWeightClassificationID
	from @Data


	return 
END
' 
END

GO
