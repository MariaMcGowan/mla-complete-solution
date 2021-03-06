USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PredictEggFlows_Find]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PredictEggFlows_Find]
GO
/****** Object:  StoredProcedure [dbo].[PredictEggFlows_Find]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PredictEggFlows_Find]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PredictEggFlows_Find] AS' 
END
GO



ALTER proc [dbo].[PredictEggFlows_Find]
@StartDate date = null, @EndDate date = null, @ContractTypeID int = null, @ShowFarms bit = null
as

	declare @CoolerInventory int	

	select @CoolerInventory= sum(cc.ActualQty) 
	from CoolerClutch cc
	inner join Clutch c on cc.ClutchID = c.ClutchID
	inner join Flock f on c.FlockID = f.FlockID
	where cc.ActualQty > 0

	select @StartDate  = isnull(nullif(@StartDate,''), convert(date,getdate()))
	select @EndDate  = isnull(nullif(@EndDate,''), dateadd(MONTH, 6, @StartDate))
	select 
		@ContractTypeID = isnull(nullif(@ContractTypeID, ''), 1),
		@ShowFarms = isnull(nullif(@ShowFarms, ''), 1)

	
	select 
		@StartDate as StartDate,
		@EndDate as EndDate,
		@ContractTypeID as ContractTypeID,
		@ShowFarms as ShowFarms,
		CoolerInventory = @CoolerInventory,
		CoolerInventory_Cases = convert(numeric(10,2), dbo.ConvertEggsToCases(@CoolerInventory))


GO
