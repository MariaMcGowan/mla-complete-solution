USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[GetRackNumberOffset]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetRackNumberOffset]
GO
/****** Object:  UserDefinedFunction [dbo].[GetRackNumberOffset]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRackNumberOffset]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE function [dbo].[GetRackNumberOffset] (@OrderIncubatorID int)
returns int
as
begin

--declare @OrderIncubatorID int = 4008

	declare @IncubatorData table (OrderIncubatorID int, IncubatorNumber int, IncubatorRackCount int)

	declare @NextRackNumber int
	declare @DeliveryDate date
	declare @IncubatorNumber int = 0


	select @DeliveryDate = DeliveryDate
	from [Order] o
	inner join OrderIncubator oi on o.OrderID = oi.OrderID and oi.OrderIncubatorID = @OrderIncubatorID

	--1
	insert into @IncubatorData (OrderIncubatorID, IncubatorNumber, IncubatorRackCount)
	select lp.OrderIncubatorID1, 1, (select count(*) from OrderIncubatorCart where OrderIncubatorID = lp.OrderIncubatorID1)
	from LoadPlanning lp 
	where DeliveryDate = @DeliveryDate
	--2
	insert into @IncubatorData (OrderIncubatorID, IncubatorNumber, IncubatorRackCount)
	select lp.OrderIncubatorID2, 2, (select count(*) from OrderIncubatorCart where OrderIncubatorID = lp.OrderIncubatorID2)
	from LoadPlanning lp 
	where DeliveryDate = @DeliveryDate
	--3
	insert into @IncubatorData (OrderIncubatorID, IncubatorNumber, IncubatorRackCount)
	select lp.OrderIncubatorID3, 3, (select count(*) from OrderIncubatorCart where OrderIncubatorID = lp.OrderIncubatorID3)
	from LoadPlanning lp 
	where DeliveryDate = @DeliveryDate
	--4
	insert into @IncubatorData (OrderIncubatorID, IncubatorNumber, IncubatorRackCount)
	select lp.OrderIncubatorID4, 4, (select count(*) from OrderIncubatorCart where OrderIncubatorID = lp.OrderIncubatorID4)
	from LoadPlanning lp 
	where DeliveryDate = @DeliveryDate
	--5
	insert into @IncubatorData (OrderIncubatorID, IncubatorNumber, IncubatorRackCount)
	select lp.OrderIncubatorID5, 5, (select count(*) from OrderIncubatorCart where OrderIncubatorID = lp.OrderIncubatorID5)
	from LoadPlanning lp 
	where DeliveryDate = @DeliveryDate
	--6
	insert into @IncubatorData (OrderIncubatorID, IncubatorNumber, IncubatorRackCount)
	select lp.OrderIncubatorID6, 6, (select count(*) from OrderIncubatorCart where OrderIncubatorID = lp.OrderIncubatorID6)
	from LoadPlanning lp 
	where DeliveryDate = @DeliveryDate
	--7
	insert into @IncubatorData (OrderIncubatorID, IncubatorNumber, IncubatorRackCount)
	select lp.OrderIncubatorID7, 7, (select count(*) from OrderIncubatorCart where OrderIncubatorID = lp.OrderIncubatorID7)
	from LoadPlanning lp 
	where DeliveryDate = @DeliveryDate
	--8
	insert into @IncubatorData (OrderIncubatorID, IncubatorNumber, IncubatorRackCount)
	select lp.OrderIncubatorID8, 8, (select count(*) from OrderIncubatorCart where OrderIncubatorID = lp.OrderIncubatorID8)
	from LoadPlanning lp 
	where DeliveryDate = @DeliveryDate

	select @IncubatorNumber = IncubatorNumber from @IncubatorData
	where OrderIncubatorID = @OrderIncubatorID

	select @NextRackNumber = isnull(sum(IncubatorRackCount),0) + 1
	from @IncubatorData
	where IncubatorNumber < @IncubatorNumber

	return @NextRackNumber

	--select @IncubatorNumber as IncubatorNumber
	--select *
	--from @IncubatorData 
	--order by IncubatorNumber
end' 
END

GO
