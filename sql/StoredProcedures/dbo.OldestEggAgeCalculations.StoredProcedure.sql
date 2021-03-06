USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OldestEggAgeCalculations]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OldestEggAgeCalculations]
GO
/****** Object:  StoredProcedure [dbo].[OldestEggAgeCalculations]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OldestEggAgeCalculations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OldestEggAgeCalculations] AS' 
END
GO


ALTER proc [dbo].[OldestEggAgeCalculations] @EggAgeParams EggAgeParams READONLY
as 
begin
	set nocount on
	declare @ReturnData TABLE 
	(
		RowNumber int,
		SetDate date,
		CasesSet numeric(6,2) default 0, 
		CasesInCooler numeric(10,1),
		OldestEggAge int,
		CasesOfOldestEggAge numeric(10,1)
	)

	declare @OldestEggAge_01 TABLE 
	(
		RowNumber int,
		OldestEggAge int,
		CasesOfOldestEggAge numeric(10,1)
	)

	declare @OldestEggAge_02 TABLE 
	(
		RowNumber int,
		OldestEggAge int,
		CasesOfOldestEggAge numeric(10,1)
	)

	insert into @ReturnData (RowNumber, SetDate, CasesSet, CasesInCooler)
	select RowNumber, SetDate, CasesSet, CasesInCooler
	from @EggAgeParams

	-- @OldestEggAge_01 contains the Actual Oldest Egg Age
	insert into @OldestEggAge_01 (RowNumber, OldestEggAge, CasesOfOldestEggAge)	 
	select RowNumber, OldestEggAge, CasesOfOldestEggAge
	from dbo.CalculateOldestEggAgeFunction(10, @EggAgeParams)
	--exec dbo.CalculateOldestEggAge 10, @EggAgeParams

	-- @OldestEggAge_02 contains the oldest egg age that is required
	-- to show the cases of oldest egg age the way that Corey wants to 
	-- see it
	insert into @OldestEggAge_02 (RowNumber, OldestEggAge, CasesOfOldestEggAge)	 
	select RowNumber, OldestEggAge, CasesOfOldestEggAge
	from dbo.CalculateOldestEggAgeFunction(9, @EggAgeParams)
	--exec dbo.CalculateOldestEggAge 9, @EggAgeParams

	update @ReturnData set CasesOfOldestEggAge = 0-- where CasesOfOldestEggAge is null
	
	update rd set rd.OldestEggAge = o.OldestEggAge
	from @ReturnData rd
	inner join @OldestEggAge_01 o on rd.RowNumber = o.RowNumber

	update rd set rd.CasesOfOldestEggAge = o.CasesOfOldestEggAge
	from @ReturnData rd
	inner join @OldestEggAge_02 o on rd.RowNumber = o.RowNumber

	select RowNumber, OldestEggAge, CasesOfOldestEggAge
	from @ReturnData
	order by RowNumber
end


GO
