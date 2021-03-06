USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[rptDeliverySpecSheet]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[rptDeliverySpecSheet]
GO
/****** Object:  StoredProcedure [dbo].[rptDeliverySpecSheet]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rptDeliverySpecSheet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[rptDeliverySpecSheet] AS' 
END
GO



ALTER proc [dbo].[rptDeliverySpecSheet] @DeliveryDate date = null, @LotNbr varchar(100) = null

--declare @DeliveryDate date = null, @LotNbr varchar(100) = null
--select @DeliveryDate = '02/20/2017', @LotNbr = ''
as

select @DeliveryDate = nullif(@DeliveryDate, '')
	, @LotNbr = nullif(@LotNbr, '')

declare @DeliverySlipCounter int = 0
declare @DeliverySlipCounterString varchar(2)
declare @FlockCounter int = 0
declare @FlockCounterString varchar(2)
declare @OrderID int

declare @Flock varchar(20)
declare @DeliverySlip varchar(10)
declare @Wgt numeric(5,1)
declare @Wks numeric(5,1)
declare @SQL varchar(4000)
declare @Delivery01 varchar(10)
declare @Delivery02 varchar(10)
declare @Delivery03 varchar(10)
declare @Delivery04 varchar(10)
declare @LoadPlanningID int


create table #FlockVariables (OrderID int, 
						Flock01 varchar(20), Wgt01 numeric(5,1), Wks01 numeric(5,1), 
						Flock02 varchar(20), Wgt02 numeric(5,1), Wks02 numeric(5,1), 
						Flock03 varchar(20), Wgt03 numeric(5,1), Wks03 numeric(5,1), 
						Flock04 varchar(20), Wgt04 numeric(5,1), Wks04 numeric(5,1), 
						Flock05 varchar(20), Wgt05 numeric(5,1), Wks05 numeric(5,1), 
						Flock06 varchar(20), Wgt06 numeric(5,1), Wks06 numeric(5,1), 
						Flock07 varchar(20), Wgt07 numeric(5,1), Wks07 numeric(5,1), 
						Flock08 varchar(20), Wgt08 numeric(5,1), Wks08 numeric(5,1), 
						Flock09 varchar(20), Wgt09 numeric(5,1), Wks09 numeric(5,1), 
						Flock10 varchar(20), Wgt10 numeric(5,1), Wks10 numeric(5,1), 
						Flock11 varchar(20), Wgt11 numeric(5,1), Wks11 numeric(5,1), 
						Flock12 varchar(20), Wgt12 numeric(5,1), Wks12 numeric(5,1), 
						Flock13 varchar(20), Wgt13 numeric(5,1), Wks13 numeric(5,1), 
						Flock14 varchar(20), Wgt14 numeric(5,1), Wks14 numeric(5,1), 
						Flock15 varchar(20), Wgt15 numeric(5,1), Wks15 numeric(5,1), 
						Flock16 varchar(20), Wgt16 numeric(5,1), Wks16 numeric(5,1)
						)

declare @OrderFlockInfo table (OrderID int, RowNbr int, Flock varchar(20), Wgt numeric(5,1), Wks numeric(5,1))

create table #DeliverySlipVariables (OrderID int, DeliverySlip01 varchar(10), DeliverySlip02 varchar(10),
													DeliverySlip03 varchar(10), DeliverySlip04 varchar(10))

declare @OrderDeliverySlipInfo table (OrderID int, RowNbr int, DeliverySlip varchar(10))

declare @FlockAge table (FlockID int, Flock varchar(100), LayDate Date, HatchDate Date, FlockAge numeric(5,1), LoadPlanningID int)

declare @OrderList table (OrderID int, LoadPlanningID int, Processed bit)

insert into @OrderList (OrderID, LoadPlanningID, Processed)
select OrderID, LoadPlanningID, 0 
from [Order]
where OrderStatusID <> 5
and isnull(LotNbr, '') <> ''
and isnull(DeliveryDate, '01/01/1900') <> '01/01/1900'
and (DeliveryDate = isnull(@DeliveryDate, '01/01/1900') or LotNbr = isnull(@LotNbr, 'XXXXXXXX'))


-- Modified by MCM on 1/10/2019
-- Get Flock Age for all load plans in the Order List
-- Get Flock Age for ALL orders for that delivery date
insert into @FlockAge (FlockID, Flock, LayDate, HatchDate, FlockAge, LoadPlanningID)	
select fl.FlockID, fl.Flock, Max(cl.LayDate) as LayDate, fl.HatchDate, round(datediff(D, fl.HatchDate, max(cl.LayDate)) / 7.00,1) as FlockAge, LoadPlanningID
from [Order] o
inner join OrderIncubator oi on o.OrderID = oi.OrderID
inner join OrderIncubatorCart oic on oi.OrderIncubatorID = oic.OrderIncubatorID
inner join Clutch cl on oic.ClutchID = cl.ClutchID
inner join Flock fl on fl.FlockID = cl.FlockID
where oic.ActualQty > 0 and exists (select 1 from @OrderList where LoadPlanningID = o.LoadPlanningID)
group by o.LoadPlanningID, fl.FlockID, Flock, HatchDate
order by 2, 3


-- Fill in Delivery Slip variables
-- Report requires 4 values
while exists (select 1 from @OrderList where Processed=0)
begin
	select top 1 @OrderID = OrderID, @LoadPlanningID = LoadPlanningID
	from @OrderList
	where Processed = 0
	order by OrderID

	execute RecalcOrderFlockActualQty @OrderID = @OrderID

	-- Get Delivery Slip tables ready
	delete from @OrderDeliverySlipInfo
	insert into @OrderDeliverySlipInfo (OrderID, RowNbr, DeliverySlip)
	select distinct OrderID, ROW_NUMBER() OVER (ORDER BY DeliverySlip) AS RowNbr, DeliverySlip
	from OrderDelivery od
	inner join Delivery d on od.DeliveryID = d.DeliveryID
	where OrderID = @OrderID and isnull(ActualQty,0) > 0
	group by DeliverySlip, OrderID
	order by DeliverySlip
		
	insert into #DeliverySlipVariables (OrderID) values (@OrderID)
	
	-- Define Delivery Slip variables.  Note - the report requires 4, no more, no less
	while @DeliverySlipCounter < 4
	begin
		set @DeliverySlipCounter = @DeliverySlipCounter+ 1
		set @DeliverySlipCounterString = right('00' + cast(@DeliverySlipCounter as varchar),2)

		select @DeliverySlip = null

		select @DeliverySlip = isnull(DeliverySlip,'')
		--select DeliverySlip
		from @OrderDeliverySlipInfo
		where RowNbr = @DeliverySlipCounter

		set @SQL = 
		'update #DeliverySlipVariables set DeliverySlip' + @DeliverySlipCounterString + ' = ''' + cast(@DeliverySlip as varchar) + '''' +
		' where OrderID = ' + cast(@OrderID as varchar)

		print @SQL
		execute (@SQL)
	end

	-- Get Flock ready
	delete from @OrderFlockInfo
	insert into @OrderFlockInfo (OrderID, RowNbr, Flock, Wgt, Wks)
	select ol.OrderID, ROW_NUMBER() OVER (ORDER BY fl.Flock) AS RowNbr,
	fl.Flock, isnull(lpd.weightPreConversion,0) *16/30 as Wgt, 
	fla.FlockAge as wks
	from @OrderList ol
	inner join OrderFlock ofl on ol.OrderID = ofl.OrderID
	inner join Flock fl on ofl.FlockID = fl.FlockID
	inner join LoadPlanning_Detail lpd on lpd.LoadPlanningID = ol.LoadPlanningID and lpd.FlockID = fl.FlockID
	inner join @FlockAge fla on fl.FlockID = fla.FlockID and ol.LoadPlanningID = fla.LoadPlanningID
	where ofl.ActualQty > 0 and ol.OrderID = @OrderID
	order by fl.Flock, ol.LoadPlanningID



	insert into #FlockVariables (OrderID)
	select @OrderID

	-- Define Flock variables.  Note - the report requires 16, no more, no less
	while @FlockCounter < 16
	begin
		set @FlockCounter = @FlockCounter+ 1
		set @FlockCounterString = right('00' + cast(@FlockCounter as varchar),2)

		select @Flock = null, @Wgt = null, @Wks = null

		select @Flock = isnull(Flock,''), @Wgt = isnull(Wgt,0.0), @Wks = isnull(Wks,0.0)
		from @OrderFlockInfo ofi
		inner join @OrderList ol on ofi.OrderID = ol.OrderID
		where RowNbr = @FlockCounter and ofi.OrderID = @OrderID

		set @SQL = 
		'update #FlockVariables set Flock' + @FlockCounterString + ' = ''' + @Flock + '''' +
		', Wgt' + @FlockCounterString + ' = ' + cast(@Wgt as varchar) + 
		', Wks' + @FlockCounterString + ' = ' + cast(@Wks as varchar) + 
		' where OrderID = ' + cast(@OrderID as varchar)

		print @SQL
		execute (@SQL)
	end

	update @OrderList set Processed = 1 where OrderID = @OrderID	
	set @FlockCounter = 0
	set @DeliverySlipCounter = 0
end

select o.LoadPlanningID, o.OrderID, 
'Maple Lawn Associates, Inc.' as Supplier,
CONVERT(char(10), o.DeliveryDate,101) as DeliveryDate, CustomerReferenceNbr, db.DestinationBuilding,
DeliverySlips, 
DeliverySpecComments,
case
	when isnull(DeliverySpecComments, '') = '' then convert(bit, 1)
	else convert(bit, 0)
end as NAForComments,
isnull(DeliverySlip01, '') as DeliverySlip01, 
isnull(DeliverySlip02, 'N/A') as DeliverySlip02, 
isnull(DeliverySlip03, '') as DeliverySlip03, 
isnull(DeliverySlip04, '') as DeliverySlip04, 
-- 01
isnull(Flock01, '') as Flock01, 
case 
	when Wgt01 is null then ''
	else cast(Wgt01 as varchar(9)) 
end as Wgt01, 
case 
	when Wks01 is null then ''
	else cast(Wks01 as varchar(9)) 
end as Wks01, 
-- 02
isnull(Flock02, '') as Flock02, 
case 
	when Wgt02 is null then ''
	else cast(Wgt02 as varchar(9)) 
end as Wgt02, 
case 
	when Wks02 is null then ''
	else cast(Wks02 as varchar(9)) 
end as Wks02, 
-- 03
isnull(Flock03, '') as Flock03, 
case 
	when Wgt03 is null then ''
	else cast(Wgt03 as varchar(9)) 
end as Wgt03, 
case 
	when Wks03 is null then ''
	else cast(Wks03 as varchar(9)) 
end as Wks03, 
-- 04
isnull(Flock04, '') as Flock04, 
case 
	when Wgt04 is null then ''
	else cast(Wgt04 as varchar(9)) 
end as Wgt04, 
case 
	when Wks04 is null then ''
	else cast(Wks04 as varchar(9)) 
end as Wks04, 
-- 05
isnull(Flock05, '') as Flock05, 
case 
	when Wgt05 is null then ''
	else cast(Wgt05 as varchar(9)) 
end as Wgt05, 
case 
	when Wks05 is null then ''
	else cast(Wks05 as varchar(9)) 
end as Wks05, 
-- 06
isnull(Flock06, '') as Flock06, 
case 
	when Wgt06 is null then ''
	else cast(Wgt06 as varchar(9)) 
end as Wgt06, 
case 
	when Wks06 is null then ''
	else cast(Wks06 as varchar(9)) 
end as Wks06, 
-- 07
isnull(Flock07, '') as Flock07, 
case 
	when Wgt07 is null then ''
	else cast(Wgt07 as varchar(9)) 
end as Wgt07, 
case 
	when Wks07 is null then ''
	else cast(Wks07 as varchar(9)) 
end as Wks07, 
-- 08
isnull(Flock08, '') as Flock08, 
case 
	when Wgt08 is null then ''
	else cast(Wgt08 as varchar(9)) 
end as Wgt08, 
case 
	when Wks08 is null then ''
	else cast(Wks08 as varchar(9)) 
end as Wks08, 
-- 09
isnull(Flock09, '') as Flock09, 
case 
	when Wgt09 is null then ''
	else cast(Wgt09 as varchar(9)) 
end as Wgt09, 
case 
	when Wks09 is null then ''
	else cast(Wks09 as varchar(9)) 
end as Wks09, 
-- 10
isnull(Flock10, '') as Flock10, 
case 
	when Wgt10 is null then ''
	else cast(Wgt10 as varchar(9)) 
end as Wgt10, 
case 
	when Wks10 is null then ''
	else cast(Wks10 as varchar(9)) 
end as Wks10, 
-- 11
isnull(Flock11, '') as Flock11, 
case 
	when Wgt11 is null then ''
	else cast(Wgt11 as varchar(9)) 
end as Wgt11, 
case 
	when Wks11 is null then ''
	else cast(Wks11 as varchar(9)) 
end as Wks11, 
-- 12
isnull(Flock12, '') as Flock12, 
case 
	when Wgt12 is null then ''
	else cast(Wgt12 as varchar(9)) 
end as Wgt12, 
case 
	when Wks12 is null then ''
	else cast(Wks12 as varchar(9)) 
end as Wks12, 
-- 13
isnull(Flock13, '') as Flock13, 
case 
	when Wgt13 is null then ''
	else cast(Wgt13 as varchar(9)) 
end as Wgt13, 
case 
	when Wks13 is null then ''
	else cast(Wks13 as varchar(9)) 
end as Wks13, 
-- 14
isnull(Flock14, '') as Flock14, 
case 
	when Wgt14 is null then ''
	else cast(Wgt14 as varchar(9)) 
end as Wgt14, 
case 
	when Wks14 is null then ''
	else cast(Wks14 as varchar(9)) 
end as Wks14, 
-- 15
isnull(Flock15, '') as Flock15, 
case 
	when Wgt15 is null then ''
	else cast(Wgt15 as varchar(9)) 
end as Wgt15, 
case 
	when Wks15 is null then ''
	else cast(Wks15 as varchar(9)) 
end as Wks15, 
-- 16
isnull(Flock16, '') as Flock16, 
case 
	when Wgt16 is null then ''
	else cast(Wgt16 as varchar(9)) 
end as Wgt16, 
case 
	when Wks16 is null then ''
	else cast(Wks16 as varchar(9)) 
end as Wks16
from [Order] o
inner join @OrderList ol on o.OrderID = ol.OrderID
inner join #FlockVariables fl on o.OrderID = fl.OrderID
inner join #DeliverySlipVariables dl on o.OrderID = dl.OrderID
inner join DestinationBuilding db on o.DestinationBuildingID = db.DestinationBuildingID
left outer join 
(
	select ord.OrderID, 
	STUFF((
			select (' / ' + DeliverySlip)
			from OrderDelivery od
			inner join Delivery d on od.DeliveryID = d.DeliveryID
			where OrderID = ord.OrderID and isnull(ActualQty,0) > 0
			group by DeliverySlip
			order by DeliverySlip
			FOR XML PATH('')), 1, 2, ''
		) DeliverySlips
	from [Order] ord
	where exists (select 1 from @OrderList where OrderID = ord.OrderID)
) f on o.OrderID = f.OrderID
order by o.LoadPlanningID, o.OrderID

drop table #FlockVariables
drop table #DeliverySlipVariables


GO
