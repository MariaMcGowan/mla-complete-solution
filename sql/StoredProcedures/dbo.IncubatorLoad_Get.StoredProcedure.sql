USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorLoad_Get]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorLoad_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorLoad_Get] AS' 
END
GO


ALTER proc [dbo].[IncubatorLoad_Get]
@OrderIncubatorID int
,@IncubatorNumber int = ''
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
,convert(varchar,o.DeliveryDate,22) as DeliveryDate
,oi.SetDate As SetDate
,oi.ProfileNumber
,db.DestinationBuilding
,convert(date,oi.StartDateTime) as StartDate
--,convert(time,oi.StartDateTime) as StartTime
,convert(varchar(10),oi.StartDateTime, 108) as StartTime
,oi.ProgramBy
--,case when sb.setByName = '' then '{add}' else sb.setByName end As SetByName
,oi.CheckedByPrimary
,oi.CheckedBySecondary
,oi.CandleDate As CandleDate
,@IncubatorID as IncubatorID
,@OrderID as OrderID
,@OrderIncubatorID as OrderIncubatorID
,'' as BlankField
,convert(bit, 0) as ShowLoadPlanning
,@IncubatorNumber as IncubatorNumber
from
[Order] o
left outer join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
left outer join OrderIncubator oi on o.OrderID = oi.OrderID and oi.IncubatorID = @IncubatorID
--left outer join @setBy sb on sb.OrderIncubatorID = oi.OrderIncubatorID
where @OrderID = o.OrderID
order by DeliveryDate desc, o.LotNbr



GO
