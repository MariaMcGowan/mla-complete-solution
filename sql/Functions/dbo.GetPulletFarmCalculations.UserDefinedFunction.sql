USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPulletFarmCalculations]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetPulletFarmCalculations]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPulletFarmCalculations]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPulletFarmCalculations]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create FUNCTION [dbo].[GetPulletFarmCalculations]
(
	-- Add the parameters for the function here
	@FarmID int,
	@Week int, 
	@CurrentPulletQty int, 
	@16WeekPulletQty int,
	@ConservativeFactor numeric(10,6)
)
RETURNS 
@Values TABLE 
(
	-- Add the column definitions for the TABLE variable here
	CalcTotalEggsPerDay int,
	CalcFloorEggsPerDay int,
	CalcCommercialEggsPerDay int,
	CalcSettableEggsPerDay int, 
	CalcSellableEggsPerDay int,
	EggWeightClassificationID int
)
AS
BEGIN

	-- Must have either the Current Pullet Qty or the 16 Week Pullet Qty
	declare 
		@LivabilityPercent numeric(10,8),
		@LayPercent numeric(10,8),
		@SettableEggPercent numeric(10,8),
		@FloorEggPercent numeric(10,8),
		@CandleoutPercent numeric(10,8),
		@CalcTotalEggsPerDay int,
		@CalcFloorEggsPerDay int,
		@CalcCommercialEggsPerDay int,
		@CalcSettableEggsPerDay int,
		@CalcSellableEggsPerDay int,
		@CaseWeight numeric(8,4),
		--@ConservativeFactor numeric(10,6),
		@ReturnString varchar(200),
		@EggWeightClassificationID int


	if @ConservativeFactor = 0 
	begin
		select @ConservativeFactor = isnull(ConservativeFactor,1)
		from Farm
		where FarmID = @FarmID
	end

	if not exists (select 1 from FarmEmbryoStandardYield where FarmID = @FarmID)
	begin
		select top 1 @FarmID = FarmID from FarmEmbryoStandardYield order by FarmID
	end

	select 
		@LivabilityPercent = isnull(CumulativeLivabilityPercent,0), 
		--@LayPercent = isnull(LayPercent,0), 
		@LayPercent = isnull(LayPercent,0) * @ConservativeFactor, -- MCM 07/19/2019
		@FloorEggPercent = isnull(FloorEggPercent,0),
		@SettableEggPercent = isnull(SettableEggsPercentForWeek,0),
		@CaseWeight = isnull(CaseWeight,0),
		@CandleoutPercent = isnull(CandleoutPercent, 0),
		@EggWeightClassificationID = 
		case
			when CaseWeight < 36 then 1
			when CaseWeight < 43 then 2
			when CaseWeight < 49 then 3
			else 4
		end
	from FarmEmbryoStandardYield
	where FarmID = @FarmID  and WeekNumber = @Week

	if @16WeekPulletQty is not null
	begin
		select @CalcTotalEggsPerDay = round((@16WeekPulletQty * @LivabilityPercent * @LayPercent),0)
	end
	else
	begin
		select @CalcTotalEggsPerDay = round((@CurrentPulletQty * @LayPercent),0)
	end

	select @CalcFloorEggsPerDay = round((@CalcTotalEggsPerDay * @FloorEggPercent), 0),
		@CalcSettableEggsPerDay = round((@CalcTotalEggsPerDay * @SettableEggPercent),0)

	select @CalcCommercialEggsPerDay = @CalcTotalEggsPerDay - @CalcFloorEggsPerDay - @CalcSettableEggsPerDay


	select @CalcSellableEggsPerDay = round((@CalcSettableEggsPerDay * @CandleoutPercent),0)

	insert into @Values (CalcTotalEggsPerDay, CalcFloorEggsPerDay, CalcCommercialEggsPerDay, CalcSettableEggsPerDay, CalcSellableEggsPerDay, EggWeightClassificationID)
	values (@CalcTotalEggsPerDay, @CalcFloorEggsPerDay, @CalcCommercialEggsPerDay, @CalcSettableEggsPerDay, @CalcSellableEggsPerDay, @EggWeightClassificationID) 

	return 
END

' 
END

GO
