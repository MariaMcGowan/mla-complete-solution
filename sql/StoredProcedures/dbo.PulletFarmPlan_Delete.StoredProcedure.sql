USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlan_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFarmPlan_Delete]
GO
/****** Object:  StoredProcedure [dbo].[PulletFarmPlan_Delete]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFarmPlan_Delete] AS' 
END
GO



ALTER proc [dbo].[PulletFarmPlan_Delete] 
	@I_vPulletFarmPlanID int = null,
	@O_iErrorState int=0 output,				  
	@oErrString varchar(255)='' output,
	@iRowID varchar(255)=NULL output  


as

delete from CommercialCommitmentDetail where PulletFarmPlanID = @I_vPulletFarmPlanID

if exists (select 1 from QuarterlyPerformanceAudit where FlockID = @I_vPulletFarmPlanID)
begin
	declare @QuarterlyPerformanceAuditID int

	select @QuarterlyPerformanceAuditID = QuarterlyPerformanceAuditID
	from QuarterlyPerformanceAudit
	where FlockID = @I_vPulletFarmPlanID

	delete from QuarterlyPerformanceAuditDetail where QuarterlyPerformanceAuditID = @QuarterlyPerformanceAuditID
	delete from QuarterlyPerformanceAudit where QuarterlyPerformanceAuditID = @QuarterlyPerformanceAuditID
end

if exists (select 1 from PADLSSamplingSchedule where FlockID = @I_vPulletFarmPlanID)
begin
	declare @PADLSSamplingScheduleID int
	
	select @PADLSSamplingScheduleID = PADLSSamplingScheduleID
	from PADLSSamplingSchedule 
	where FlockID = @I_vPulletFarmPlanID

	delete from PADLSSamplingScheduleDetail where PADLSSamplingScheduleID = @PADLSSamplingScheduleID
	delete from PADLSSamplingSchedule where PADLSSamplingScheduleID = @PADLSSamplingScheduleID
end


if exists (select 1 from VaccinationService where FlockID = @I_vPulletFarmPlanID)
begin
	declare @VaccinationServiceID int

	select @VaccinationServiceID = VaccinationServiceID
	from VaccinationService
	where FlockID = @I_vPulletFarmPlanID

	delete from VaccinationServiceDetail where VaccinationServiceID = @VaccinationServiceID
	delete from VaccinationService where VaccinationServiceID = @VaccinationServiceID
end

if exists (select 1 from PulletFarmPlanComment where PulletFarmPlanID = @I_vPulletFarmPlanID)
begin
	delete from PulletFarmPlanComment
	where PulletFarmPlanID = @I_vPulletFarmPlanID
end

delete from PulletFarmPlanDetail where PulletFarmPlanID =  @I_vPulletFarmPlanID 
delete from PulletFarmPlan where PulletFarmPlanID = @I_vPulletFarmPlanID






GO
