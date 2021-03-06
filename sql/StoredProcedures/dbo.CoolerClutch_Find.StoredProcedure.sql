USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CoolerClutch_Find]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CoolerClutch_Find]
GO
/****** Object:  StoredProcedure [dbo].[CoolerClutch_Find]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoolerClutch_Find]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CoolerClutch_Find] AS' 
END
GO



ALTER proc [dbo].[CoolerClutch_Find]
as

	select 
		FlockID = convert(int, null)
		, LayDate_Start = convert(date, null)
		, LayDate_End = convert(date, null)
		, ChangeDate_Start = convert(date, null)
		, ChangeDate_End = convert(date, null)
		, QuantityChangeReasonID = convert(int, null)


GO
