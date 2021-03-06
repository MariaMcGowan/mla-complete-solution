USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_GetPrint]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorLoad_GetPrint]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_GetPrint]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorLoad_GetPrint]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorLoad_GetPrint] AS' 
END
GO


ALTER proc [dbo].[IncubatorLoad_GetPrint]
@OrderIncubatorID int
,@UserName nvarchar(255) = ''
AS

declare @IncubatorID int, @OrderID int
select @IncubatorID = IncubatorID, @OrderID = OrderID from OrderIncubator where OrderIncubatorID = @OrderIncubatorID

--declare @setBy table (OrderIncubatorID int, SetByName nvarchar(255))
--insert into @setBy
--select OrderIncubatorID, null
--from OrderIncubator oci
--where OrderIncubatorID = @OrderIncubatorID

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


Select
o.LotNbr As LotNumber
--,convert(varchar,o.DeliveryDate,22) as DeliveryDate
,o.DeliveryDate
,CandleDateDeliveryDateClass = 
	case
		when datediff(day, oi.CandleDate, o.DeliveryDate) <> 11 then 'yellowBackground'
		else ''
	end
,oi.SetDate As SetDate
,oi.ProfileNumber
,db.DestinationBuilding
,convert(date,oi.StartDateTime) as StartDate
,substring(convert(varchar,convert(time,oi.StartDateTime),24),1,5) as StartTime
,programBy.Contact as ProgramBy
--,case when sb.setByName = '' then '{add}' else sb.setByName end As SetByName
,checkedByPrimary.Contact as checkedByPrimary
,checkedBySecondary.Contact as checkedBySecondary
,oi.CandleDate As CandleDate
,i.Incubator as Incubator
,@OrderID as OrderID
,@OrderIncubatorID as OrderIncubatorID
,'' as BlankField
,convert(bit, 0) as ShowLoadPlanning
from
[Order] o
left outer join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
left outer join OrderIncubator oi on o.OrderID = oi.OrderID and oi.IncubatorID = @IncubatorID
--left outer join @setBy sb on sb.OrderIncubatorID = oi.OrderIncubatorID
left outer join Contact programBy on oi.ProgramBy = programBy.ContactID
left outer join Contact checkedByPrimary on oi.CheckedByPrimary = checkedByPrimary.ContactID
left outer join Contact checkedBySecondary on oi.CheckedBySecondary = checkedBySecondary.ContactID
left outer join Incubator i on i.IncubatorID = @IncubatorID
where @OrderID = o.OrderID



GO
