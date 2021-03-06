USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitmentDelivery_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialCommitmentDelivery_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitmentDelivery_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDelivery_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialCommitmentDelivery_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[CommercialCommitmentDelivery_InsertUpdate]  
 @I_vCommercialCommitmentDeliveryID int
 ,@I_vCommercialCommitmentID int =null
 ,@I_vDeliveryDate date = null
 ,@I_vDeliveryQuantity_InCases numeric(10,1) = null
 ,@I_vDeliveryNotes varchar(500) = null
 ,@I_vDriverID int = null
 ,@I_vTruckID int = null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

 declare @EggsPerCase int = 360

if @I_vCommercialCommitmentDeliveryID = 0  
begin   
	declare @CommercialCommitmentDeliveryID table (CommercialCommitmentDeliveryID int)   
	insert into CommercialCommitmentDelivery(
	  CommercialCommitmentID
	  ,DeliveryDate
	  ,DeliveryQuantity
	  ,DeliveryNotes
	  ,DriverID
	  ,TruckID
	 )   
	 output inserted.CommercialCommitmentDeliveryID into @CommercialCommitmentDeliveryID(CommercialCommitmentDeliveryID)  
	 select
	  @I_vCommercialCommitmentID
	  ,@I_vDeliveryDate
	  ,case
			when isnull(@I_vDeliveryQuantity_InCases,0) = 0 then 0
			else @I_vDeliveryQuantity_InCases * @EggsPerCase
		 end
	  ,@I_vDeliveryNotes
	  ,@I_vDriverID
	  ,@I_vTruckID

 select top 1 @I_vCommercialCommitmentDeliveryID = CommercialCommitmentDeliveryID, @iRowID = CommercialCommitmentDeliveryID 
 from @CommercialCommitmentDeliveryID 
end  
else  
begin   
	update CommercialCommitmentDelivery set
	  DeliveryDate = @I_vDeliveryDate
	  ,DeliveryQuantity = 
			case
				when isnull(@I_vDeliveryQuantity_InCases,0) = 0 then 0
				else @I_vDeliveryQuantity_InCases * @EggsPerCase
			end
	  ,DeliveryNotes = @I_vDeliveryNotes
	  ,DriverID= @I_vDriverID
	  ,TruckID = @I_vTruckID
	 where CommercialCommitmentDeliveryID = @I_vCommercialCommitmentDeliveryID   
	 
	 select @iRowID = @I_vCommercialCommitmentDeliveryID  
end

select @I_vCommercialCommitmentDeliveryID as ID,'forward' As referenceType



GO
