USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ProjectedOrder_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ProjectedOrder_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[ProjectedOrder_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProjectedOrder_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ProjectedOrder_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[ProjectedOrder_InsertUpdate]  
 @I_vProjectedOrderID int
 ,@I_vDestinationID int
 ,@I_vDestinationBuildingID int
 ,@I_vSetDate date
 ,@I_vDeliveryDate date
 ,@I_vQty int
 ,@I_vContractTypeID int
 ,@I_vCustomIncubation bit = null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  


-- Clean up any outdated project orders
delete from ProjectedOrder where SetDate <= getdate()

select @I_vCustomIncubation = isnull(nullif(@I_vCustomIncubation, ''), 0)
 
if @I_vProjectedOrderID = 0  
begin   
	declare @ProjectedOrderID table (ProjectedOrderID int)   
	insert into ProjectedOrder(
	  DestinationID
	  , DestinationBuildingID
	  , SetDate
	  , DeliveryDate
	  , Qty
	  , ContractTypeID
	  , CustomIncubation
	  )  
	 output inserted.ProjectedOrderID into @ProjectedOrderID(ProjectedOrderID)  
	 select
	  @I_vDestinationID
	  , @I_vDestinationBuildingID
	  , @I_vSetDate
	  , @I_vDeliveryDate
	  , @I_vQty
	  , @I_vContractTypeID
	  , @I_vCustomIncubation


 select top 1 @I_vProjectedOrderID = ProjectedOrderID, @iRowID = ProjectedOrderID 
 from @ProjectedOrderID 
end  
else  
begin   
	update ProjectedOrder set
	  DestinationID = @I_vDestinationID
	  , DestinationBuildingID = @I_vDestinationBuildingID
	  , SetDate = @I_vSetDate
	  , DeliveryDate = @I_vDeliveryDate
	  , Qty = @I_vQty
	  , ContractTypeID = @I_vContractTypeID
	  , CustomIncubation = @I_vCustomIncubation
	 where ProjectedOrderID = @I_vProjectedOrderID
	 
	 select @iRowID = @I_vProjectedOrderID
end

select @I_vProjectedOrderID as ID,'forward' As referenceType


GO
