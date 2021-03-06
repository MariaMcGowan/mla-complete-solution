USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FarmEmbryoStandardYield_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FarmEmbryoStandardYield_Get]
GO
/****** Object:  StoredProcedure [dbo].[FarmEmbryoStandardYield_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FarmEmbryoStandardYield_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FarmEmbryoStandardYield_Get] AS' 
END
GO



ALTER proc [dbo].[FarmEmbryoStandardYield_Get]  
	@FarmID int
		
As    

	declare @WeekNbr int


	select @FarmID = nullif(@FarmID, '')

	create table #Display (		
		FarmEmbryoStandardYieldID int,
		FarmID int,
		WeekNumber int,
		CumulativeMortalityPercent numeric(8,4),
		CumulativeLivabilityPercent numeric(8,4),
		LayPercent numeric(8,4),
		SettableEggsPercentForWeek numeric(8,4),
		FloorEggPercent numeric(8,4),
		CaseWeight numeric(8,4),
		CandleoutPercent numeric(8,4)
		)


	set @WeekNbr = 16

	if @FarmID is not null
	begin
		while @WeekNbr <= 80
		begin
			insert into #Display(WeekNumber, FarmID, FarmEmbryoStandardYieldID) values (@WeekNbr, @FarmID, 0)
			set @WeekNbr = @WeekNbr + 1
		end

		update d
			set d.FarmEmbryoStandardYieldID = sy.FarmEmbryoStandardYieldID
			, d.CumulativeMortalityPercent = sy.CumulativeMortalityPercent
			, d.CumulativeLivabilityPercent = sy.CumulativeLivabilityPercent
			, d.LayPercent = sy.LayPercent
			, d.SettableEggsPercentForWeek = sy.SettableEggsPercentForWeek
			, d.FloorEggPercent = sy.FloorEggPercent
			, d.CaseWeight = sy.CaseWeight
			, d.CandleoutPercent = sy.CandleoutPercent
		from #Display d
		inner join FarmEmbryoStandardYield sy on d.WeekNumber = sy.WeekNumber and d.FarmID = sy.FarmID
	end

	select 
		FarmEmbryoStandardYieldID
		, FarmID
		, WeekNumber
		, CumulativeMortalityPercent = 
			case
				when CumulativeMortalityPercent is null then ''
				else convert(varchar(10), convert(numeric(8,2), CumulativeMortalityPercent * 100)) + '%'
			end
		, CumulativeLivabilityPercent = 
			case
				when CumulativeLivabilityPercent is null then ''
				else convert(varchar(10), convert(numeric(8,2), CumulativeLivabilityPercent * 100)) + '%'
			end
		, LayPercent = 
			case
				when LayPercent is null then ''
				else convert(varchar(10), convert(numeric(8,2), LayPercent * 100)) + '%'
			end
		, SettableEggsPercentForWeek =
			case
				when SettableEggsPercentForWeek is null then ''
				else convert(varchar(10), convert(numeric(8,2), SettableEggsPercentForWeek * 100)) + '%'
			end
		, FloorEggPercent = 
			case
				when FloorEggPercent is null then ''
				else convert(varchar(10), convert(numeric(8,2), FloorEggPercent * 100)) + '%'
			end
		, CaseWeight
		, CandleoutPercent = 
			case
				when CandleoutPercent is null then ''
				else convert(varchar(10), convert(numeric(8,2), CandleoutPercent * 100)) + '%'
			end
	from #Display d
	order by WeekNumber



GO
