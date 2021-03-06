USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[rptDeliverySpecSheet_TEST]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[rptDeliverySpecSheet_TEST]
GO
/****** Object:  StoredProcedure [dbo].[rptDeliverySpecSheet_TEST]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rptDeliverySpecSheet_TEST]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[rptDeliverySpecSheet_TEST] AS' 
END
GO



ALTER proc [dbo].[rptDeliverySpecSheet_TEST] @DeliveryDate date = null
as

if @DeliveryDate is null
	set @DeliveryDate = '10/05/2016'

declare @DeliverySlips varchar(100) = ''

select @DeliverySlips = @DeliverySlips + ', ' + cast(DeliverySlipID as varchar)
from [Order] o
inner join OrderDeliverySlip ods on o.OrderID = ods.OrderID
where DeliveryDate = isnull(@DeliveryDate, DeliveryDate)
group by DeliverySlipID
order by DeliverySlipID


if left(@DeliverySlips,2) = ', '
	set @DeliverySlips = right(@DeliverySlips, len(@DeliverySlips)-2)


select o.OrderID, 
'Maple Lawn Associates, Inc.' as Supplier,
DeliveryDate, CustomerReferenceNbr, db.DestinationBuilding,
@DeliverySlips as DeliverySlips
from [Order] o
inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
where DeliveryDate = isnull(@DeliveryDate, DeliveryDate)
order by o.OrderID



GO
