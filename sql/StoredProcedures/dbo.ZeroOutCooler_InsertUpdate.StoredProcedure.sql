USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ZeroOutCooler_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ZeroOutCooler_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[ZeroOutCooler_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZeroOutCooler_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ZeroOutCooler_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[ZeroOutCooler_InsertUpdate]  
 @I_vDate date
 ,@I_vZeroOut bit
 ,@I_vContractTypeID int
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  
 
AS  

if not exists (select 1 from HatcheryRecord where Date = @I_vDate and ContractTypeID = @I_vContractTypeID)
begin
	insert into HatcheryRecord(Date, ContractTypeID, FarmPickupQty) select @I_vDate, @I_vContractTypeID, 0
end

update HatcheryRecord set ZeroOutCooler = @I_vZeroOut where date = @I_vDate and ContractTypeID = @I_vContractTypeID



GO
