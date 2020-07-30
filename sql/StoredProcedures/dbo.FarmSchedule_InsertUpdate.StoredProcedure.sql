DROP PROCEDURE IF EXISTS [dbo].[FarmSchedule_InsertUpdate]
GO

create proc [dbo].[FarmSchedule_InsertUpdate] 
@I_vPulletFarmPlanID int,
@I_vProductionFarm_RemoveDate date = null,
@I_vProductionFarm_RemovalDateConfirmed bit = null,
@I_vProductionFarm_MoveDayCount int = null,
@I_vProductionFarm_WashDownDate date = null,
@I_vProductionFarm_WashDownDateConfirmed bit = null,
@I_vProductionFarm_LitterDate date = null,
@I_vProductionFarm_LitterDateConfirmed bit = null,
@I_vProductionFarm_FumigationDate date = null,
@I_vProductionFarm_FumigationDateConfirmed bit = null,
@I_vProductionFarm_WashDownContractor varchar(10) = null,
@I_vPlannedMaleQtyAt16Weeks int = null,
@I_vPlannedMaleQtyToRemove int = null,
@O_iErrorState int=0 output,				  
@oErrString varchar(255)='' output,
@iRowID varchar(255)=NULL output  


As   

select @I_vProductionFarm_RemovalDateConfirmed = isnull(nullif(@I_vProductionFarm_RemovalDateConfirmed, ''),0)

update PulletFarmPlan set 
	ProductionFarm_RemoveDate = @I_vProductionFarm_RemoveDate,
	ProductionFarm_RemovalDateConfirmed = @I_vProductionFarm_RemovalDateConfirmed, 
	ProductionFarm_MoveDayCount = @I_vProductionFarm_MoveDayCount,
	ProductionFarm_WashDownDate = @I_vProductionFarm_WashDownDate,
	ProductionFarm_WashDownDateConfirmed = @I_vProductionFarm_WashDownDateConfirmed,
	ProductionFarm_LitterDate = @I_vProductionFarm_LitterDate,
	ProductionFarm_LitterDateConfirmed = @I_vProductionFarm_LitterDateConfirmed,
	ProductionFarm_FumigationDate = @I_vProductionFarm_FumigationDate,
	ProductionFarm_FumigationDateConfirmed = @I_vProductionFarm_FumigationDateConfirmed,
	ProductionFarm_WashDownContractor = @I_vProductionFarm_WashDownContractor,
	ActualEndDate = isnull(@I_vProductionFarm_RemoveDate, ActualEndDate),
	ActualCommercialEndDate = isnull(@I_vProductionFarm_RemoveDate, ActualCommercialEndDate),
	PlannedMaleQtyAt16Weeks = @I_vPlannedMaleQtyAt16Weeks, 
	PlannedMaleQtyToRemove = @I_vPlannedMaleQtyToRemove

where PulletFarmPlanID = @I_vPulletFarmPlanID


