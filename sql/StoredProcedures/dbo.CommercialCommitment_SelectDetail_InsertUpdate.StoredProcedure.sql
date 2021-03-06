USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_SelectDetail_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialCommitment_SelectDetail_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_SelectDetail_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitment_SelectDetail_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialCommitment_SelectDetail_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[CommercialCommitment_SelectDetail_InsertUpdate] 
@I_vCommercialCommitmentID int,
@I_vPulletFarmPlanID int,
@I_vSelected bit,
@I_vWeekEndingDate date,
@I_vCommercialQty int,
@I_vCommittedQty int,
@I_vReservedQty_InCases float,
@I_vEggWeightClassificationID int,
@I_vCommitmentStatusID int,
@I_vCommercialCommitmentDetailID int,
@O_iErrorState int=0 output,				  
@oErrString varchar(255)='' output,
@iRowID varchar(255)=NULL output  

As   

declare @ReservedQty int
	
declare @EggsPerCase int = 360;

select @I_vSelected = isnull(nullif(@I_vSelected, ''),0)

if @I_vSelected = 1
begin
	-- Is the user attempting to reserve more than is available?
	select @ReservedQty = isnull(nullif(@I_vReservedQty_InCases,''),0) * @EggsPerCase

	if @I_vCommercialQty - @I_vCommittedQty - @ReservedQty < 0
	begin
		-- They are taking too much!
		-- Only give them what they can have
		select @ReservedQty = @I_vCommercialQty - @I_vCommittedQty
	end

	-- Do they already have quantity reserved for this pullet farm plan?
	if exists (select 1 from CommercialCommitmentDetail where PulletFarmPlanID = @I_vPulletFarmPlanID and WeekEndingDate = @I_vWeekEndingDate and EggWeightClassificationID = @I_vEggWeightClassificationID)
	begin
		declare @CommercialCommitmentDetailID int 

		select @CommercialCommitmentDetailID = CommercialCommitmentDetailID 
		from CommercialCommitmentDetail 
		where PulletFarmPlanID = @I_vPulletFarmPlanID and WeekEndingDate = @I_vWeekEndingDate and EggWeightClassificationID = @I_vEggWeightClassificationID

		update CommercialCommitmentDetail set CommittedQty = isnull(@ReservedQty, 0), CommitmentStatusID = @I_vCommitmentStatusID
		where CommercialCommitmentDetailID = @CommercialCommitmentDetailID
	end
	else
	begin
		insert into CommercialCommitmentDetail (CommercialCommitmentID, PulletFarmPlanID, 
		WeekEndingDate, CommittedQty, EggWeightClassificationID, CommitmentStatusID)
		select @I_vCommercialCommitmentID, @I_vPulletFarmPlanID, @I_vWeekEndingDate, @ReservedQty, @I_vEggWeightClassificationID, @I_vCommitmentStatusID
	end
end
else if @I_vCommercialCommitmentDetailID > 0
begin
	delete from CommercialCommitmentDetail where CommercialCommitmentDetailID = @I_vCommercialCommitmentDetailID
end




GO
