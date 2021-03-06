USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanDetail_ReserveEggs_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlanDetail_ReserveEggs_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlanDetail_ReserveEggs_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanDetail_ReserveEggs_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlanDetail_ReserveEggs_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[PulletFarmPlanDetail_ReserveEggs_InsertUpdate] 
	@I_vPulletFarmPlanDetailID int,
	@O_iErrorState int=0 output,				  
	@oErrString varchar(255)='' output,
	@iRowID varchar(255)=NULL output  

as

update PulletFarmPlanDetail set ReservedForContract =  1 where PulletFarmPlanDetailID = @I_vPulletFarmPlanDetailID



GO
