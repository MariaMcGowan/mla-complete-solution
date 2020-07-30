DROP PROCEDURE IF EXISTS [dbo].[PulletSchedule_InsertUpdate]
GO

create proc [dbo].[PulletSchedule_InsertUpdate] 
@I_vPulletFarmPlanID int,
@I_vPulletFacility_RemoveDate date = null,
@I_vPulletFacility_RemovalDateConfirmed bit = null,
@I_vPulletFacility_MoveDayCount int = null,
@I_vPulletMover varchar(10) = null,
@I_vPulletFacility_WashDownDate date = null,
@I_vPulletFacility_WashDownDateConfirmed bit = null,
@I_vPulletFacility_LitterDate date = null,
@I_vPulletFacility_LitterDateConfirmed bit = null,
@I_vPulletFacility_FumigationDate date = null,
@I_vPulletFacility_FumigationDateConfirmed bit = null,
@I_vPulletFacility_WashDownContractor varchar(10) = null,
@I_vPlannedMaleQtyAt16Weeks int = null,
@I_vPlannedMaleQtyToRemove int = null,
@O_iErrorState int=0 output,				  
@oErrString varchar(255)='' output,
@iRowID varchar(255)=NULL output  


As   

select @I_vPulletFacility_RemovalDateConfirmed = isnull(nullif(@I_vPulletFacility_RemovalDateConfirmed, ''),0)

update PulletFarmPlan set 
	PulletFacility_RemoveDate = @I_vPulletFacility_RemoveDate,
	PulletFacility_RemovalDateConfirmed = @I_vPulletFacility_RemovalDateConfirmed,
	PulletFacility_MoveDayCount = @I_vPulletFacility_MoveDayCount,
	PulletMover = @I_vPulletMover,
	PulletFacility_WashDownDate = @I_vPulletFacility_WashDownDate,
	PulletFacility_WashDownDateConfirmed = @I_vPulletFacility_WashDownDateConfirmed,
	PulletFacility_LitterDate = @I_vPulletFacility_LitterDate,
	PulletFacility_LitterDateConfirmed = @I_vPulletFacility_LitterDateConfirmed,
	PulletFacility_FumigationDate = @I_vPulletFacility_FumigationDate,
	PulletFacility_FumigationDateConfirmed = @I_vPulletFacility_FumigationDateConfirmed,
	PulletFacility_WashDownContractor = @I_vPulletFacility_WashDownContractor, 
	PlannedMaleQtyAt16Weeks = @I_vPlannedMaleQtyAt16Weeks, 
	PlannedMaleQtyToRemove = @I_vPlannedMaleQtyToRemove
where PulletFarmPlanID = @I_vPulletFarmPlanID




GO
