USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ContractVolume_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ContractVolume_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[ContractVolume_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContractVolume_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ContractVolume_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[ContractVolume_InsertUpdate]  
 @I_vContractVolumeID int
 ,@I_vContractID int
 ,@I_vWeekEndingDate date
 ,@I_vVolume int
 ,@O_iErrorState int=0 output   
 ,@oErrString varchar(255)='' output   
 ,@iRowID varchar(255)=NULL output  
 
 AS  

if @I_vContractVolumeID = 0  
begin
   declare @ContractVolumeID table (ContractVolumeID int)
   
   insert into ContractVolume (
	  ContractID
	  , WeekEndingDate
	  , Volume
	 )   output inserted.ContractVolumeID into @ContractVolumeID(ContractVolumeID)  
 select  
	  @I_vContractID
	  ,@I_vWeekEndingDate
	  ,@I_vVolume

 select top 1 @I_vContractVolumeID = ContractVolumeID, @iRowID = ContractVolumeID from @ContractVolumeID  
end  
else  
begin   
	update ContractVolume   set
	  ContractID = @I_vContractID
	  ,WeekEndingDate = @I_vWeekEndingDate
	  ,Volume = @I_vVolume
	 where @I_vContractVolumeID = ContractVolumeID   
	 
	 select @iRowID = @I_vContractVolumeID  
end


GO
