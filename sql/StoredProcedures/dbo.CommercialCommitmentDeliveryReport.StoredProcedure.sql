USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitmentDeliveryReport]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialCommitmentDeliveryReport]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitmentDeliveryReport]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDeliveryReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialCommitmentDeliveryReport] AS' 
END
GO



ALTER proc [dbo].[CommercialCommitmentDeliveryReport]  @CommercialCommitmentID int = null, @StartDate date = null, @EndDate date = null
as

declare @EggsPerCase int = 360;
select @CommercialCommitmentID = nullif(@CommercialCommitmentID, '')

if @CommercialCommitmentID is not null
begin
	select @StartDate = CommitmentDateStart, @EndDate = CommitmentDateEnd
	from CommercialCommitment
	where CommercialCommitmentID = @CommercialCommitmentID
end

declare @DateRange table (Date date index idxDate clustered)

insert into @DateRange
select *
from dbo.GetDateRange(@StartDate, @EndDate)
OPTION (MAXRECURSION 32747)

;with CommercialCommitments (CommercialCommitmentID, CommercialMarketID, CommitmentQty, Notes, CommitmentStatusID, CommitmentDateStart, CommitmentDateEnd) as 
(
	select CommercialCommitmentID, CommercialMarketID, CommitmentQty, Notes, CommitmentStatusID, 
	CommitmentDateStart = convert(date,CommitmentDateStart) , CommitmentDateEnd = convert(date, CommitmentDateEnd)
	from CommercialCommitment cc
	where IsNull(@CommercialCommitmentID,CommercialCommitmentID) = CommercialCommitmentID
	and exists (select 1 from @DateRange where Date between cc.CommitmentDateStart and cc.CommitmentDateEnd)
),
Deliveries (CommercialCommitmentID, CommercialCommitmentDeliveryID, DeliveryDate, DeliveryQuantity, DeliveryQuantity_InCases, DeliveryNotes, Driver, Truck) as 
(
	select cc.CommercialCommitmentID, 
	CommercialCommitmentDeliveryID, 
	DeliveryDate = convert(date,DeliveryDate), 
	DeliveryQuantity, 
	DeliveryQuantity_InCases = DeliveryQuantity / (@EggsPerCase * 1.0), 
	DeliveryNotes, 
	Driver = c.Contact, 
	t.Truck
	from CommercialCommitments cc 
	inner join CommercialCommitmentDelivery ccd on cc.CommercialCommitmentID = ccd.CommercialCommitmentID
	left outer join Contact c on ccd.DriverID = c.ContactID
	left outer join Truck t on ccd.TruckID = t.TruckID
	where isnull(DeliveryQuantity,0) <> 0
	
),
DeliverySummary (CommercialCommitmentID, TotalDelivered, TotalDelivered_InCases) as 
(
	select CommercialCommitmentID, sum(DeliveryQuantity) as TotalDelivered, 
	TotalDelivered_InCases = sum(DeliveryQuantity) / (@EggsPerCase * 1.0)
	from Deliveries 
	group by CommercialCommitmentID
)

select CommercialMarket, 
CommercialCommitmentDesc = 'For ' + convert(varchar(10), CommitmentDateStart, 101) + ' - ' + convert(varchar(10), CommitmentDateEnd, 101),
CommitmentDateStart, 
CommitmentDateEnd,
CommitmentQty, 
CommitmentQty_InCases = CommitmentQty /  (@EggsPerCase * 1.0), 
Notes, 
CommitmentStatus,
DeliveryDate, 
DeliveryQuantity, 
DeliveryQuantity_InCases,
DeliveryNotes, 
Driver,
Truck,
TotalDelivered, 
TotalDelivered_InCases
from CommercialCommitments cc
inner join CommercialMarket cm on cc.CommercialMarketID = cm.CommercialMarketID
inner join CommitmentStatus cs on cc.CommitmentStatusID = cs.CommitmentStatusID
inner join Deliveries d on d.CommercialCommitmentID = cc.CommercialCommitmentID
inner join DeliverySummary ds on ds.CommercialCommitmentID = cc.CommercialCommitmentID
where cc.CommercialCommitmentID = @CommercialCommitmentID



GO
