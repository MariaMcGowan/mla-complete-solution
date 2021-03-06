USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderHoldingIncubator_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderHoldingIncubator_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderHoldingIncubator_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderHoldingIncubator_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderHoldingIncubator_Get] AS' 
END
GO


ALTER proc [dbo].[OrderHoldingIncubator_Get]
@OrderID int
,@OrderHoldingIncubatorID int = null
,@IncludeNew bit = 1
As

declare @summation table (PlannedQtySum int, ActualQtySum int, OrderHoldingIncubatorID int)

insert into @summation
select sum(IsNull(odc.PlannedQty,0)), sum(IsNull(odc.ActualQty,0)), dc.OrderHoldingIncubatorID 
from OrderDeliveryCart odc
inner join DeliveryCart dc on odc.DeliveryCartID = dc.DeliveryCartID
inner join OrderHoldingIncubator ohi on dc.OrderHoldingIncubatorID = ohi.OrderHoldingIncubatorID
where OrderID = @OrderID
group by dc.OrderHoldingIncubatorID

select
	ohi.OrderHoldingIncubatorID
	, OrderID
	, ohi.HoldingIncubatorID
	, i.HoldingIncubator
	, PlannedQty
	, ActualQty
	, ProfileNumber
	, convert(date,StartDateTime) as StartDate
	, convert(varchar,convert(time,StartDateTime),100) as StartTime
	, convert(varchar,StartDateTime,22) as StartDateTime
	, ProgramBy
	, CheckedByPrimary
	, CheckedBySecondary
	, case when sm.OrderHoldingIncubatorID is null then 'Assign Carts'
		else 'Edit Carts (' + convert(varchar,sm.PlannedQtySum) + ' planned, ' + convert(varchar,sm.ActualQtySum) + ' actual)'
		end As AssignCartsDisplay
from OrderHoldingIncubator ohi
inner join HoldingIncubator i on ohi.HoldingIncubatorID = i.HoldingIncubatorID
left outer join @summation sm on ohi.OrderHoldingIncubatorID = sm.OrderHoldingIncubatorID
where @OrderID = OrderID
and IsNull(@OrderHoldingIncubatorID,ohi.OrderHoldingIncubatorID) = ohi.OrderHoldingIncubatorID
union all
select
	OrderHoldingIncubatorID = convert(int,0)
	, OrderID = @OrderID
	, HoldingIncubatorID = convert(int,null)
	, HoldingIncubator = ''
	, PlannedQty = convert(int,null)
	, ActualQty = convert(int,null)
	, ProfileNumber = convert(int,null)
	, StartDate = convert(date,null)
	, StartTime = convert(varchar,'12:00PM')
	, StartDateTime = convert(varchar,null)
	, ProgramBy = convert(int,null)
	, CheckedByPrimary = convert(int,null)
	, CheckedBySecondary = convert(int,null)
	, AssignCartsDisplay = null
where @IncludeNew = 1



GO
