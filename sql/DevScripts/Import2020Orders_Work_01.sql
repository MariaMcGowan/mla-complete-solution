DROP PROCEDURE IF EXISTS dbo.BulkInsertOrders
GO

create proc dbo.BulkInsertOrders @UserID varchar(255)
as
declare 
	  @ID int
	, @DestinationBuildingID int
	, @DeliveryDate date
	, @SetDate date
	, @OrderQty int
	, @Bldg_9 int
	, @Bldg_32 int
	, @Bldg_37 int
	, @Bldg_59 int
	, @Bldg_75 int
	, @Bldg_79 int
	, @Bldg_MA int
	, @Bldg_NJ int
	, @O_iErrorState int
	, @oErrString varchar(255)
	, @iRowID varchar(255)

declare @ProcessBulkOrders table (
	  ID int
	, DeliveryDate date
	, SetDate date
	, Bldg_9 int
	, Bldg_32 int
	, Bldg_37 int
	, Bldg_59 int
	, Bldg_75 int
	, Bldg_79 int
	, Bldg_MA int
	, Bldg_NJ int
)

insert into @ProcessBulkOrders (
	  ID
	, DeliveryDate
	, SetDate 
	, Bldg_9
	, Bldg_32
	, Bldg_37
	, Bldg_59
	, Bldg_75
	, Bldg_79
	, Bldg_MA
	, Bldg_NJ
)
select 
	  ID
	, DeliveryDate
	, SetDate 
	, Bldg_9
	, Bldg_32
	, Bldg_37
	, Bldg_59
	, Bldg_75
	, Bldg_79
	, Bldg_MA
	, Bldg_NJ
from stage_BulkOrders
where UserID = @UserID and Processed = 0

while exists (select 1 from @ProcessBulkOrders)
begin
	select @DestinationBuildingID = 0
	, @DeliveryDate = '1/1/1900'
	, @SetDate = '1/1/1900'
	, @OrderQty = 0
	, @O_iErrorState = 0
	, @oErrString = ''
	, @iRowID = ''

	select top 1 
		  @ID = ID
		, @DeliveryDate = DeliveryDate
		, @SetDate = SetDate 
		, @Bldg_9 = Bldg_9
		, @Bldg_32 = Bldg_32
		, @Bldg_37 = Bldg_37
		, @Bldg_59 = Bldg_59
		, @Bldg_75 = Bldg_75
		, @Bldg_79 = Bldg_79
		, @Bldg_MA = Bldg_MA
		, @Bldg_NJ = Bldg_NJ
	from @ProcessBulkOrders

	if isnull(nullif(@Bldg_9, ''),0) > 0
	begin
		select @OrderQty = @Bldg_9, @DestinationBuildingID = DestinationBuildingID
		from DestinationBuilding
		where DestinationBuildingID = '9'

		exec Order_InsertUpdate 
			  @I_vOrderID = 0
			, @I_vIncubationDayCnt = 11
			, @I_vDestinationID = 1
			, @I_vCustomerReferenceNbr = 'Bulk Order Entry'
			, @I_vPlannedQty = @OrderQty
			, @I_vDestinationBuildingID = @DestinationBuildingID
			, @I_vOrderStatusID = 1
			, @I_vDeliveryDate = @DeliveryDate
			, @I_vPlannedSetDate = @SetDate
			, @I_vUserName = @UserID


	end


	from @ProcessBulkOrders
	where ID = @ID



	exec Order_InsertUpdate @I_vOrderID = 0, @I_vIncubationDayCnt = 11, @I_vDestinationID = 1, @I_vCustomerReferenceNbr = 'Order Entry', @I_vPlannedQty = 102000, @I_vDestinationBuildingID = 7,   @I_vOrderStatusID = 1, @I_vDeliveryDate = '08/31/2020', @I_vPlannedSetDate = '08/19/2020', @I_vUserName ='THESUMMITGRP\mmcgowan'
end
