USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Contract_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Contract_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Contract_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contract_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Contract_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[Contract_InsertUpdate]  
 @I_vContractID int
 ,@I_vCustomerID int
 ,@I_vContractTypeID int
 ,@I_vEffectiveDateStart date
 ,@I_vEffectiveDateEnd date
 ,@I_vCaseWeightMin numeric(10,4)
 ,@I_vIsActive bit = 1
 ,@I_vFlockAgeInWeeksMax int
 ,@I_vProductTypeID int
 ,@O_iErrorState int=0 output   
 ,@oErrString varchar(255)='' output   
 ,@iRowID varchar(255)=NULL output  
 
AS  

if @I_vContractID = 0  
begin   
	declare @ContractID table (ContractID int)   
	
	insert into Contract (
		CustomerID
	  , ContractTypeID
	  , EffectiveDateStart
	  , EffectiveDateEnd
	  , CaseWeightMin
	  , IsActive
	  , FlockAgeInWeeksMax
	  , ProductTypeID
	 )   output inserted.ContractID into @ContractID(ContractID)  
 select
	  @I_vCustomerID
	  ,@I_vContractTypeID
	  ,@I_vEffectiveDateStart
	  ,@I_vEffectiveDateEnd
	  ,@I_vCaseWeightMin
	  ,@I_vIsActive
	  ,@I_vFlockAgeInWeeksMax
	  ,@I_vProductTypeID

 select top 1 @I_vContractID = ContractID, @iRowID = ContractID from @ContractID  
end  
else  
begin   
	update Contract   set	
	  CustomerID = @I_vCustomerID
	  ,ContractTypeID = @I_vContractTypeID
	  ,EffectiveDateStart = @I_vEffectiveDateStart
	  ,EffectiveDateEnd = @I_vEffectiveDateEnd
	  ,CaseWeightMin = @I_vCaseWeightMin
	  ,IsActive = @I_vIsActive
	  ,FlockAgeInWeeksMax = @I_vFlockAgeInWeeksMax
	  ,ProductTypeID = @I_vProductTypeID
	where @I_vContractID = ContractID   
	
	select @iRowID = @I_vContractID  
end



GO
