USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitmentDetail_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialCommitmentDetail_Get]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitmentDetail_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDetail_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialCommitmentDetail_Get] AS' 
END
GO



ALTER proc [dbo].[CommercialCommitmentDetail_Get]  @CommercialCommitmentID int
As    

declare @EggsPerCase int = 360;

select *
from 
(
	select 
		CommercialCommitmentDetailID, 
		CommercialCommitmentID, 
		ccd.PulletFarmPlanID, 
		WeekEndingDate,
		CommittedQty,
		EggClassification, 
		EggWeightClassification, 
		CommittedQty_InCases = 
			convert(numeric(10,1),
					case
						when isnull(CommittedQty,0) = 0 then 0
						else CommittedQty / (@EggsPerCase * 1.0)
					end),
		CommitmentStatusID,
		NewRecord = convert(int, null),
		FlockNumber,
		ModifiedAfterCommitment,
		DynamicFormatting = 
		case
			when ModifiedAfterCommitment = 1 then 'ModifiedAfterWarning'
			else ''
		end
	from CommercialCommitmentDetail ccd
	left outer join PulletFarmPlan pfp on ccd.PulletFarmPlanID = pfp.PulletFarmPlanID
	left outer join EggWeightClassification ewc on ccd.EggWeightClassificationID = ewc.EggWeightClassificationID
	left outer join EggClassification ec on ccd.EggClassificationID = ec.EggClassificationID
	where CommercialCommitmentID = @CommercialCommitmentID
	union all 
	select 
		CommercialCommitmentDetailID = 0, 
		CommercialCommitmentID = @CommercialCommitmentID, 
		PulletFarmPlanID = convert(int, null), 
		WeekEndingDate = convert(date, null),
		CommittedQtyPerDay = convert(int, null),
		EggClassification = convert(varchar(100), null), 
		EggWeightClassification = convert(varchar(100),null), 
		CommittedQtyPerDay_InCases = convert(int, null), 
		CommitmentStatusID = convert(int,null),
		NewRecord = @CommercialCommitmentID,
		FlockNumber = convert(varchar(20),null),
		ModifiedAfterCommitment = convert(bit, null),
		DynamicFormatting = ''
) d
order by NewRecord



GO
