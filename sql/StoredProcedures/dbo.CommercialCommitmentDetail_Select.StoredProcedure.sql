USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitmentDetail_Select]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialCommitmentDetail_Select]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitmentDetail_Select]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDetail_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialCommitmentDetail_Select] AS' 
END
GO



ALTER proc [dbo].[CommercialCommitmentDetail_Select]  @CommercialCommitmentID int, @EggWeightClassificationID int = null, @ShowOnlyReserved bit = null
As    


--declare @CommercialCommitmentID int, @EggWeightClassificationID int = null, @ShowOnlyReserved bit = null

--select @CommercialCommitmentID = '1023', @EggWeightClassificationID = '3', @ShowOnlyReserved = '0'

declare @EggsPerCase int = 360;
declare @StartDate date
declare @EndDate date
declare @CommitmentStatusID int

select @EggWeightClassificationID = isnull(nullif(@EggWeightClassificationID, ''), 999)
select @ShowOnlyReserved = isnull(nullif(@ShowOnlyReserved, ''), 0)

select @CommercialCommitmentID = isnull(nullif(@CommercialCommitmentID, ''),0)

select @StartDate = isnull(CommitmentDateStart, getdate()), @EndDate = isnull(CommitmentDateEnd, dateadd(week,4, getdate())), @CommitmentStatusID = isnull(CommitmentStatusID,1)
from CommercialCommitment
where CommercialCommitmentID = @CommercialCommitmentID


declare @Data table (Selected bit default 0, WeekEndingDate date, EggWeightClassificationID int, PulletFarmPlanID int,
CommercialQty int default 0, 
CommittedQty int default 0,		-- This is just for what is committed elsewhere (ie - not for this committment)
ReservedQty int default 0,
AvailableQty int default 0,
CommercialQty_InCases numeric(10,1) default 0, 
CommittedQty_InCases numeric(10,1) default 0,
ReservedQty_InCases numeric(10,1) default 0,
CommercialQty_AveragePerDay_InCases numeric(10,1) default 0,
ReservedQty_AveragePerDay_InCases numeric(10,1) default 0,
AvailableQty_InCases numeric(10,1) default 0,
FarmID int, FarmNumber int, 
Flock varchar(20),
CommercialCommitmentID int,
CommercialCommitmentDetailID int,
CommitmentStatusID int, 
ModifiedAfterCommitment bit)


if @CommercialCommitmentID > 0
begin
	if @ShowOnlyReserved = 1
	begin
		insert into @Data (Selected, WeekEndingDate, EggWeightClassificationID, PulletFarmPlanID, 
		CommercialQty, ReservedQty, FarmID,  CommitmentStatusID, ModifiedAfterCommitment, CommercialCommitmentDetailID)
		select Selected = convert(bit, 1), ccd.WeekEndingDate, ccd.EggWeightClassificationID, ccd.PulletFarmPlanID, 
		CommercialQty = sum(CommercialEggs),
		ReservedQty = ccd.CommittedQty,
		ds.FarmID, 
		@CommitmentStatusID,
		ModifiedAfterCommitment,
		CommercialCommitmentDetailID
		from CommercialCommitmentDetail ccd 
		inner join RollingDailySchedule ds on ds.PulletFarmPlanID = ccd.PulletFarmPlanID and ds.WeekEndingDate = ccd.WeekEndingDate and ds.EggWeightClassificationID = ccd.EggWeightClassificationID
		where ccd.CommercialCommitmentID = @CommercialCommitmentID
		and (
				@EggWeightClassificationID = 999 
				or 
				ccd.EggWeightClassificationID = @EggWeightClassificationID
			)
		group by ccd.WeekEndingDate, ccd.EggWeightClassificationID, ccd.PulletFarmPlanID, ds.FarmID, ModifiedAfterCommitment, ccd.CommittedQty, ccd.CommercialCommitmentDetailID
		having sum(CommercialEggs) > 0 
	end
	else
	begin

		insert into @Data (WeekEndingDate, EggWeightClassificationID, PulletFarmPlanID, 
		CommercialQty, FarmID, CommitmentStatusID, ModifiedAfterCommitment, CommercialCommitmentDetailID)
		select WeekEndingDate, EggWeightClassificationID, PulletFarmPlanID, 
		CommercialQty = sum(CommercialEggs),
		ds.FarmID, @CommitmentStatusID,
		ModifiedAfterCommitment = 
		case
			when exists (select 1 from CommercialCommitmentDetail where PulletFarmPlanID = ds.PulletFarmPlanID and ModifiedAfterCommitment = 1 and CommercialCommitmentID = @CommercialCommitmentID) then 1
			else ''
		end, 0
		from RollingDailySchedule ds
		where ds.WeekEndingDate between @StartDate and @EndDate
		and (
				@EggWeightClassificationID = 999 
				or 
				EggWeightClassificationID = @EggWeightClassificationID
			)
		group by WeekEndingDate, EggWeightClassificationID, PulletFarmPlanID, ds.FarmID


		-- Show committed quantity
		-- For all other commercial commitments
		update d set d.CommittedQty = c.CommittedQty
		from @Data d
		inner join 
		(
			select PulletFarmPlanID, WeekEndingDate, EggWeightClassificationID, sum(isnull(CommittedQty,0)) as CommittedQty
			from CommercialCommitmentDetail
			where isnull(CommitmentStatusID,0) < 6
			and CommercialCommitmentID <> @CommercialCommitmentID
			group by PulletFarmPlanID, WeekEndingDate, EggWeightClassificationID
		) c on d.PulletFarmPlanID = c.PulletFarmPlanID and d.WeekEndingDate = c.WeekEndingDate and c.EggWeightClassificationID = d.EggWeightClassificationID


		-- Now update @Data to select the rows that were already reserved for this commitment
		update d set d.Selected = 1, d.ReservedQty = ccd.ReservedQty
		from @Data d 
		inner join 
		(
			select PulletFarmPlanID, WeekEndingDate, EggWeightClassificationID, sum(isnull(CommittedQty,0)) as ReservedQty
			from CommercialCommitmentDetail 
			where CommercialCommitmentID = @CommercialCommitmentID
			and (
					@EggWeightClassificationID = 999 
					or 
					EggWeightClassificationID = @EggWeightClassificationID
				)
			group by PulletFarmPlanID, WeekEndingDate, EggWeightClassificationID
			having sum(isnull(CommittedQty,0)) > 0
		) ccd on d.PulletFarmPlanID = ccd.PulletFarmPlanID and d.WeekEndingDate = ccd.WeekEndingDate and d.EggWeightClassificationID = ccd.EggWeightClassificationID

		update @Data set AvailableQty = CommercialQty - CommittedQty - ReservedQty
	end

	update d set 
		d.CommercialQty_InCases = CommercialQty / (@EggsPerCase * 1.0), 
		d.CommittedQty_InCases = CommittedQty / (@EggsPerCase * 1.0),
		d.ReservedQty_InCases = ReservedQty / (@EggsPerCase * 1.0),
		d.AvailableQty_InCases = AvailableQty / (@EggsPerCase * 1.0),
		d.CommercialCommitmentID = @CommercialCommitmentID,
		d.FarmNumber = f.FarmNumber, 
		d.Flock = pfp.FlockNumber,
		d.CommercialQty_AveragePerDay_InCases = (CommercialQty / 7) / (@EggsPerCase * 1.0),
		d.ReservedQty_AveragePerDay_InCases = (ReservedQty / 7 ) / (@EggsPerCase * 1.0)
	from @Data d
	inner join PulletFarmPlan pfp on d.PulletFarmPlanID = pfp.PulletFarmPlanID
	inner join Farm f on d.FarmID= f.FarmID

	update @Data set Selected = 0 where ReservedQty = 0

end
select d.*, 
EggWeightClassification,
DynamicFormatting = 
case
	when ModifiedAfterCommitment = 1  and CommercialQty - CommittedQty - ReservedQty < 0 then 'ModifiedAfterAndNegWarning'
	when ModifiedAfterCommitment = 1 then 'ModifiedAfterWarning'
	when CommercialQty - CommittedQty - ReservedQty < 0 then 'NegativeRemainingQtyWarning'
	else ''
end, 	
CommercialQty_AveragePerDay_InCases,
ReservedQty_AveragePerDay_InCases,
ReservedQty_InCases as Test_ReservedQty_InCases,
UniqueRowID =
ROW_NUMBER() 
	over (
	order by WeekEndingDate, d.EggWeightClassificationID, PulletFarmPlanID)
from @Data d
inner join EggWeightClassification ewc on d.EggWeightClassificationID = ewc.EggWeightClassificationID
where (@ShowOnlyReserved = 0 or isnull(ReservedQty,0) <> 0)
order by WeekEndingDate, FarmNumber



GO
