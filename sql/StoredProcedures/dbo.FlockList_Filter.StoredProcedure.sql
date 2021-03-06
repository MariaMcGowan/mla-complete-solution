USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FlockList_Filter]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FlockList_Filter]
GO
/****** Object:  StoredProcedure [dbo].[FlockList_Filter]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlockList_Filter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FlockList_Filter] AS' 
END
GO


ALTER proc [dbo].[FlockList_Filter]
As

select 
	FarmID = convert(int, 0)
	, IsActive = convert(int, -1)
	, ContractTypeID = convert(int, 0)
	, HatchDateStart = convert(date, null)
	, HatchDateEnd = convert(date, null)
	, HousingDateStart = convert(date, null)
	, HousingDateEnd = convert(date, null)
	, RemovalDateStart = convert(date, null)
	, RemovalDateEnd = convert(date, null)


GO
