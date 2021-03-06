USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitmentDelivery_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialCommitmentDelivery_Get]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitmentDelivery_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDelivery_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialCommitmentDelivery_Get] AS' 
END
GO



ALTER proc [dbo].[CommercialCommitmentDelivery_Get]  @CommercialCommitmentID int = null, @CommercialCommitmentDeliveryID int = null
as

declare @EggsPerCase int = 360;
select @CommercialCommitmentID = nullif(@CommercialCommitmentID, ''),
	@CommercialCommitmentDeliveryID = nullif(@CommercialCommitmentDeliveryID, '')

if @CommercialCommitmentDeliveryID is null
begin
	select CommercialCommitmentID = @CommercialCommitmentID, 
	CommercialCommitmentDeliveryID = convert(int, 0), 
	DeliveryDate = convert(date, null), 
	DeliveryQuantity = convert(int, null), 
	DeliveryQuantity_InCases = convert(numeric(10,1), null),
	DeliveryNotes = convert(varchar(500), null), 
	Driver = convert(varchar(100), null), 
	Truck = convert(varchar(20), null)
	union all
	select CommercialCommitmentID, 
	CommercialCommitmentDeliveryID, 
	DeliveryDate, 
	DeliveryQuantity, 
	DeliveryQuantity_InCases = DeliveryQuantity / (@EggsPerCase * 1.0), 
	DeliveryNotes, 
	Driver = c.Contact, 
	t.Truck
	from CommercialCommitmentDelivery ccd 
	left outer join Contact c on ccd.DriverID = c.ContactID
	left outer join Truck t on ccd.TruckID = t.TruckID
	where CommercialCommitmentID = @CommercialCommitmentID AND DeliveryQuantity <> 0
end
else
begin
	select CommercialCommitmentID, 
	CommercialCommitmentDeliveryID, 
	DeliveryDate, 
	DeliveryQuantity, 
	DeliveryQuantity_InCases = DeliveryQuantity / (@EggsPerCase * 1.0), 
	DeliveryNotes, 
	Driver = c.Contact, 
	t.Truck
	from CommercialCommitmentDelivery ccd 
	left outer join Contact c on ccd.DriverID = c.ContactID
	left outer join Truck t on ccd.TruckID = t.TruckID
	where CommercialCommitmentDeliveryID = @CommercialCommitmentDeliveryID --AND DeliveryQuantity <> 0
end


GO
