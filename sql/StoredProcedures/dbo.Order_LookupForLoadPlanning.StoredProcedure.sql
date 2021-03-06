USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Order_LookupForLoadPlanning]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Order_LookupForLoadPlanning]
GO
/****** Object:  StoredProcedure [dbo].[Order_LookupForLoadPlanning]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_LookupForLoadPlanning]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Order_LookupForLoadPlanning] AS' 
END
GO
ALTER proc [dbo].[Order_LookupForLoadPlanning]
@LoadPlanningID int
AS

select LotNbr,OrderID
	from [ORDER] o
	where OrderStatusID <> (select OrderStatusID from OrderStatus where OrderStatus = 'Cancelled')
	and o.LoadPlanningID = @LoadPlanningID


GO
