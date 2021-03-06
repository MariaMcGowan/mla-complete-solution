USE [MLA]
GO
/****** Object:  View [dbo].[AccumulatedEggCnt]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP VIEW IF EXISTS [dbo].[AccumulatedEggCnt]
GO
/****** Object:  View [dbo].[AccumulatedEggCnt]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AccumulatedEggCnt]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[AccumulatedEggCnt] as 

select DatePart(Year,DeliveryDate) as Year, sum(odc.ActualQty) as AccumulatedEggCnt
from [Order] o
inner join OrderHoldingIncubator ohi on o.OrderID = ohi.OrderID
inner join DeliveryCart dc on dc.OrderHoldingIncubatorID = ohi.OrderHoldingIncubatorID
inner join OrderDeliveryCart odc on dc.DeliveryCartID = odc.DeliveryCartID
where DeliveryDate < getdate() and OrderStatusID <> 5 --Cancelled
group by DatePart(Year,DeliveryDate)
' 
GO
