USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FarmPlanning_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FarmPlanning_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[FarmPlanning_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FarmPlanning_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FarmPlanning_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[FarmPlanning_InsertUpdate]  
 @I_vFarmID int
 ,@I_vDefaultPulletQty int
 ,@I_vMaxPulletQty int
 ,@I_vConservativeFactor numeric(10,6)
 ,@O_iErrorState int=0 output   
 ,@oErrString varchar(255)='' output   
 ,@iRowID varchar(255)=NULL output  
 
AS  

if @I_vFarmID > 0 
begin   
	update Farm   set	
	  DefaultPulletQty = @I_vDefaultPulletQty
	  ,MaxPulletQty = @I_vMaxPulletQty
	  ,ConservativeFactor = @I_vConservativeFactor
	where @I_vFarmID = FarmID   
	
	select @iRowID = @I_vFarmID  
end



GO
