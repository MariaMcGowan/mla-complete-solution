USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ProjectedOrder_Filter]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ProjectedOrder_Filter]
GO
/****** Object:  StoredProcedure [dbo].[ProjectedOrder_Filter]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProjectedOrder_Filter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ProjectedOrder_Filter] AS' 
END
GO



ALTER proc [dbo].[ProjectedOrder_Filter]
As

select convert(date, null) as DeliveryDate_Start
	, convert(date, null) as DeliveryDate_End
	, convert(date, null) as SetDate_Start
	, convert(date, null) as SetDate_End
	, convert(int, null) as DayOfWeekID
	, convert(int, null) as DestinationBuildingID
	, convert(int, 1) as ContractTypeID


GO
