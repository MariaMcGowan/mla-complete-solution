USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FarmPickup_Find]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FarmPickup_Find]
GO
/****** Object:  StoredProcedure [dbo].[FarmPickup_Find]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FarmPickup_Find]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FarmPickup_Find] AS' 
END
GO



ALTER proc [dbo].[FarmPickup_Find]
@StartDate date = null, @EndDate date = null, @ContractTypeID int = null
as

	select @StartDate  = isnull(nullif(@StartDate,''), convert(date,getdate()))
	select @EndDate  = isnull(nullif(@EndDate,''), dateadd(MONTH, 1, @StartDate))
	select @ContractTypeID = nullif(@ContractTypeID, '')

	select 
		@StartDate as StartDate,
		@EndDate as EndDate,
		@ContractTypeID as ContractTypeID


GO
