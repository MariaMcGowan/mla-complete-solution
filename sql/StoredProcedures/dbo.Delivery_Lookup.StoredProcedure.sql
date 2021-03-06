USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Delivery_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Delivery_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[Delivery_Lookup]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Delivery_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Delivery_Lookup] AS' 
END
GO


ALTER proc [dbo].[Delivery_Lookup]
	@OrderID int = null
	,@IncludeBlank bit = 1
	,@IncludeAll bit = 0
As

select DeliveryDescription,DeliveryID,1 as SortOrder
from Delivery d
inner join OrderDeliver od on d.DeliveryID = od.DeliveryID
where IsNull(@OrderID,OrderID) = OrderID

union all
select '','',0
where @IncludeBlank = 1

union all
select 'All','',0
where @IncludeAll = 1

Order by 1


GO
