USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_UpdateDetail]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialCommitment_UpdateDetail]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_UpdateDetail]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitment_UpdateDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialCommitment_UpdateDetail] AS' 
END
GO



ALTER proc [dbo].[CommercialCommitment_UpdateDetail]
	@PulletFarmPlanID int
as

-- This procedure is being called because something changed with this pullet farm plan id,
-- therefore, it may not be available for commercial anymore!
-- If it isn't available any more, need to delete the details!
update CommercialCommitmentDetail set ModifiedAfterCommitment = 1 where PulletFarmPlanID = @PulletFarmPlanID


update ccd 
	set ccd.CommittedQty = 
		case
			when isnull(ws.CommercialEggs, 0)  < ccd.CommittedQty then isnull(ws.CommercialEggs, 0) 
			else ccd.CommittedQty
		end
from CommercialCommitmentDetail ccd
left outer join 
(
	select PulletFarmPlanID,
	WeekEndingDate, 
	EggWeightClassificationID, 
	CommercialEggs = sum(CommercialEggs)
	from RollingDailySchedule
	where PulletFarmPlanID = @PulletFarmPlanID
	group by WeekEndingDate, EggWeightClassificationID, PulletFarmPlanID
) ws on 
	ccd.PulletFarmPlanID = ws.PulletFarmPlanID 
	and ccd.WeekEndingDate = ws.WeekEndingDate 
	and ccd.EggWeightClassificationID = ws.EggWeightClassificationID
where ccd.PulletFarmPlanID = @PulletFarmPlanID




GO
