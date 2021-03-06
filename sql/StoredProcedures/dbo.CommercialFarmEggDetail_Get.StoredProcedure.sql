USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialFarmEggDetail_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialFarmEggDetail_Get]
GO
/****** Object:  StoredProcedure [dbo].[CommercialFarmEggDetail_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialFarmEggDetail_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialFarmEggDetail_Get] AS' 
END
GO



ALTER proc [dbo].[CommercialFarmEggDetail_Get] @CommercialFarmEggID int = null, @CommercialFarmEggDetailID int = null
as

	select @CommercialFarmEggID = nullif(@CommercialFarmEggID, ''),
			@CommercialFarmEggDetailID = isnull(nullif(@CommercialFarmEggDetailID, ''), 0)

	select d.*, ec.EggClassification, ewc.EggWeightClassification
	from CommercialFarmEggDetail d
	inner join EggClassification ec on d.EggClassificationID = ec.EggClassificationID
	inner join EggWeightClassification ewc on d.EggWeightClassificationID = ewc.EggWeightClassificationID
	where (@CommercialFarmEggDetailID > 0 and CommercialFarmEggDetailID = @CommercialFarmEggDetailID)
	or (@CommercialFarmEggID = CommercialFarmEggID)




GO
