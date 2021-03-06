USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_Find]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialCommitment_Find]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_Find]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitment_Find]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialCommitment_Find] AS' 
END
GO



ALTER proc [dbo].[CommercialCommitment_Find]
@StartDate date = null, @EndDate date = null
as

	select @StartDate  = isnull(nullif(@StartDate,''), convert(date,getdate()))
	select @EndDate  = isnull(nullif(@EndDate,''), dateadd(yy, 2, @StartDate))

	select 
		convert(int, null) as CommercialMarketID,
		@StartDate as StartDate,
		@EndDate as EndDate



GO
