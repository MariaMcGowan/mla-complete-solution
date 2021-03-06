USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ToggleReservedForContract_Reserve]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ToggleReservedForContract_Reserve]
GO
/****** Object:  StoredProcedure [dbo].[ToggleReservedForContract_Reserve]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ToggleReservedForContract_Reserve]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ToggleReservedForContract_Reserve] AS' 
END
GO



ALTER proc [dbo].[ToggleReservedForContract_Reserve] @PulletFarmPlanDetailID int
as

declare @EggsPerCase int = 360

select UserMessage = 
	'Click save to reserve the eggs that were originally released from the ' + (select ContractType from ContractType where ContractTypeID = pfp.ContractTypeID) + ' process.',
	Date,
	PulletFarmPlanDetailID = @PulletFarmPlanDetailID,
	FarmNumber = f.FarmNumber, 
	SettableEggs = coalesce(nullif(OverwrittenSettableEggs,0), CalcSettableEggs),
	SettableEggs_Cases = round(coalesce(nullif(OverwrittenSettableEggs,0), CalcSettableEggs) / (@EggsPerCase * 1.0),1),
	BlankFieldForSpace = convert(varchar(50), null)
from PulletFarmPlan pfp
inner join PulletFarmPlan_WeeklySchedule ws on pfp.PulletFarmPlanID = ws.PulletFarmPlanID
inner join PulletFarmPlanDetail pfpd on ws.PulletFarmPlan_WeeklyScheduleID = pfpd.PulletFarmPlan_WeeklyScheduleID
inner join Farm f on pfp.FarmID = f.FarmID
where pfpd.PulletFarmPlanDetailID = @PulletFarmPlanDetailID
			


GO
