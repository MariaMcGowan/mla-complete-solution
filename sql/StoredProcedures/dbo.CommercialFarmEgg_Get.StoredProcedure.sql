USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialFarmEgg_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialFarmEgg_Get]
GO
/****** Object:  StoredProcedure [dbo].[CommercialFarmEgg_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialFarmEgg_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialFarmEgg_Get] AS' 
END
GO



ALTER proc [dbo].[CommercialFarmEgg_Get] @CommercialFarmEggID int = null, 
	@Date date = null, 
	@FarmID int = null
as

	select @CommercialFarmEggID = isnull(nullif(@CommercialFarmEggID, ''),0), 
		@Date = isnull(nullif(@Date, ''), '01/01/1900'),
		@FarmID = isnull(nullif(@FarmID, ''), 0)
	
	select *
	from CommercialFarmEgg 
	where (@CommercialFarmEggID > 0 and CommercialFarmEggID = @CommercialFarmEggID)
	or
	(Date = @Date and FarmID = @FarmID)



GO
