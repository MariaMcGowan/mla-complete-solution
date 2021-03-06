USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FarmPickup_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FarmPickup_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[FarmPickup_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FarmPickup_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FarmPickup_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[FarmPickup_InsertUpdate]  
 @I_vDate date
 ,@I_vContractTypeID int
 ,@I_vFarmPickupQty int
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  
 
AS  

declare @EggsPerCase int = 360

select @I_vFarmPickupQty = isnull(nullif(@I_vFarmPickupQty, ''), 0) * @EggsPerCase

if not exists (select 1 from HatcheryRecord where Date = @I_vDate and ContractTypeID = @I_vContractTypeID)
begin
	insert HatcheryRecord (Date, ContractTypeID)
	select @I_vDate, @I_vContractTypeID
end

update HatcheryRecord set FarmPickupQty = @I_vFarmPickupQty where Date = @I_vDate and ContractTypeID = @I_vContractTypeID



GO
