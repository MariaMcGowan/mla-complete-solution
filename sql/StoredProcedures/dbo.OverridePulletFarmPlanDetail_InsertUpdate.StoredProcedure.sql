USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OverridePulletFarmPlanDetail_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OverridePulletFarmPlanDetail_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OverridePulletFarmPlanDetail_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OverridePulletFarmPlanDetail_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OverridePulletFarmPlanDetail_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[OverridePulletFarmPlanDetail_InsertUpdate]  
 @I_vPulletFarmPlanDetailID int
 ,@I_vReserveReleaseID varchar(1)=null
 ,@I_vSettableEggs_Cases float=null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  
 
AS  

 declare @EggsPerCase int = 360
 declare @CalcSettableEggs_Cases float

	if @I_vPulletFarmPlanDetailID > 0  
	begin   
	
		 select @I_vSettableEggs_Cases = isnull(nullif(@I_vSettableEggs_Cases,''),0),
			@I_vReserveReleaseID = nullif(@I_vReserveReleaseID,'')

		-- Is the settable egg count different?  as in actually overiden?
		select @CalcSettableEggs_Cases = convert(numeric(10,1), CalcSettableEggs / (@EggsPerCase * 1.0))
		from PulletFarmPlanDetail
		where PulletFarmPlanDetailID = @I_vPulletFarmPlanDetailID

		update PulletFarmPlanDetail set
			OverwrittenSettableEggs = 
			case
				when @I_vSettableEggs_Cases <> @CalcSettableEggs_Cases then @I_vSettableEggs_Cases * @EggsPerCase
				else null
			end,
			ReservedForContract = isnull(@I_vReserveReleaseID, ReservedForContract)
		where PulletFarmPlanDetailID = @I_vPulletFarmPlanDetailID   
	 
	end



GO
