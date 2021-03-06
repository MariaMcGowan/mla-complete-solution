USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubator_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderIncubator_Get]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubator_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubator_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderIncubator_Get] AS' 
END
GO


ALTER proc [dbo].[OrderIncubator_Get]
@OrderID int
,@OrderIncubatorID int = null
,@UserName varchar(100)
,@IncludeNew bit = 1
As

--declare @setBy table (OrderIncubatorID int, SetByName nvarchar(255))
--insert into @setBy
--select OrderIncubatorID, null
--from OrderIncubator
--where OrderID = @OrderID
--declare @currentName nvarchar(255), @currentID int

--while exists (select 1 from @setBy where SetByName is null)
--begin
--	select top 1 @currentID = OrderIncubatorID, @currentName = '' from @setBy where SetByName is null
--	select @currentName = @currentName + case when @currentName = '' then '' else ', ' end
--		+ IsNull(rtrim(c.FirstName),'') + IsNull(' ' + rtrim(c.LastName),'')
--	from OrderIncubatorEggsSetBy setBy
--	inner join Contact c on setBy.ContactID = c.ContactID
--	where setBy.OrderIncubatorID = @currentID
--	update @setBy set SetByName = @currentName where OrderIncubatorID = @currentID
--end

declare @summation table (PlannedQtySum int, ActualQtySum int, OrderIncubatorID int)
insert into @summation
select sum(IsNull(ocic.PlannedQty,0)), sum(IsNull(ocic.ActualQty,0)), ocic.OrderIncubatorID 
from OrderIncubatorCart ocic
inner join OrderIncubator oci on ocic.OrderIncubatorID = oci.OrderIncubatorID
where OrderID = OrderID
group by ocic.OrderIncubatorID

select
	oci.OrderIncubatorID
	, OrderID
	, oci.IncubatorID
	, i.Incubator
	, PlannedQty
	, ActualQty
	, ProfileNumber
	, convert(date,StartDateTime) as StartDate
	, convert(varchar,convert(time,StartDateTime),100) as StartTime
	, convert(varchar,StartDateTime,22) as StartDateTime
	, ProgramBy
	, CheckedByPrimary
	, CheckedBySecondary
	--, case when s.SetByName = '' then '{add}' else s.SetByName end As SetByName
	, case when sm.OrderIncubatorID is null then 'Assign Carts'
		else 'Edit Carts (' + convert(varchar,sm.PlannedQtySum) + ' planned, ' + convert(varchar,sm.ActualQtySum) + ' actual)'
		end As AssignCartsDisplay
	, @UserName as UserName
from OrderIncubator oci
inner join Incubator i on oci.IncubatorID = i.IncubatorID
--left outer join @setBy s on s.OrderIncubatorID = oci.OrderIncubatorID
left outer join @summation sm on oci.OrderIncubatorID = sm.OrderIncubatorID
where @OrderID = OrderID
and IsNull(@OrderIncubatorID,oci.OrderIncubatorID) = oci.OrderIncubatorID
union all
select
	OrderIncubatorID = convert(int,0)
	, OrderID = @OrderID
	, IncubatorID = convert(int,null)
	, Incubator = ''
	, PlannedQty = convert(int,null)
	, ActualQty = convert(int,null)
	, ProfileNumber = convert(int,null)
	, StartDate = convert(date,null)
	, StartTime = convert(varchar,'12:00PM')
	, StartDateTime = convert(varchar,null)
	, ProgramBy = convert(int,null)
	, CheckedByPrimary = convert(int,null)
	, CheckedBySecondary = convert(int,null)
--, SetByName = null
	, AssignCartsDisplay = null
	, @UserName as UserName
where @IncludeNew = 1
order by Incubator



GO
