USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_CreateOrderIncubator]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[LoadPlanning_CreateOrderIncubator]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_CreateOrderIncubator]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning_CreateOrderIncubator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[LoadPlanning_CreateOrderIncubator] AS' 
END
GO



ALTER proc [dbo].[LoadPlanning_CreateOrderIncubator]
@LoadPlanningID int
,@IncubatorNumber int
as

select convert(int,null) as OrderID
	,convert(int,null) as IncubatorID
	,@IncubatorNumber as IncubatorNumber
	,@LoadPlanningID as LoadPlanningID



GO
