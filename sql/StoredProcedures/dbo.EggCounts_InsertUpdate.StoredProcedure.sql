USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggCounts_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggCounts_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[EggCounts_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggCounts_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggCounts_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[EggCounts_InsertUpdate] 
	@I_oPulletFarmPlanDetailID int, 
	@I_oActualPulletQty int, 
	@I_oActualTotalEggs int, 
	@I_oActualFloorEggs int, 
	@I_oActualCommercialEggs int, 
	@I_oActualSettableEggs int, 
	@I_oActualSellableEggs int, 
	@O_iErrorState int=0 output,				  
	@oErrString varchar(255)='' output,
	@iRowID varchar(255)=NULL output  

as

update PulletFarmPlanDetail set 
	ActualPulletQty = @I_oActualPulletQty,
	ActualTotalEggs = @I_oActualTotalEggs,
	ActualFloorEggs = @I_oActualFloorEggs,
	ActualCommercialEggs = @I_oActualCommercialEggs,
	ActualSettableEggs = @I_oActualSettableEggs,
	ActualSellableEggs = @I_oActualSellableEggs
where PulletFarmPlanDetailID = @I_oPulletFarmPlanDetailID



GO
