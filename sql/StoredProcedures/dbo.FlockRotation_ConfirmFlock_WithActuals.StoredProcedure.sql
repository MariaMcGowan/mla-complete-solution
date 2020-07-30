DROP PROCEDURE IF EXISTS [dbo].[FlockRotation_ConfirmFlock_WithActuals]
GO

create proc [dbo].[FlockRotation_ConfirmFlock_WithActuals]
	@UserFlockPlanChangesID int
as
--declare @UserFlockPlanChangesID int = 3235

declare @Data table (
	FarmID int,
	PulletFarmPlanID int,
	ContractTypeID int,
	FarmNumber int,
	FlockNumber varchar(20),
	ConservativeFactor numeric(8,6),
	PulletQtyAt16Weeks int, 
	OverrideModifiedAfterOrderConfirm bit,
	PlannedHatchDate date,
	Planned16WeekDate date,
	Planned24WeekDate date,
	Planned65WeekDate date,
	PlannedStartDate date,
	ActualHatchDate date,
	Actual16WeekDate date,
	Actual24WeekDate date,
	Actual65WeekDate date,
	ActualStartDate date,
	Original_PlannedHatchDate date,
	Original_Planned16WeekDate date,
	Original_Planned24WeekDate date,
	Original_Planned65WeekDate date,
	Original_PlannedStartDate date,
	Original_ProductionFarm_PlannedRemoveDate date,
	UserMessage varchar(500), 

	PulletFacility_RemoveDate date,
	PulletFacility_RemovalDateConfirmed bit,
    PulletFacility_WashDownDate date,
	PulletFacility_WashDownDateConfirmed bit,
    PulletFacility_LitterDate date,
	PulletFacility_LitterDateConfirmed bit,
    PulletFacility_FumigationDate date,
    PulletFacility_FumigationDateConfirmed bit,

	ProductionFarm_PlannedRemoveDate date,
	ProductionFarm_RemoveDate date,
	ProductionFarm_RemovalDateConfirmed bit,
	ProductionFarm_WashDownDate date,
	ProductionFarm_WashDownDateConfirmed bit,
	ProductionFarm_LitterDate date,
	ProductionFarm_LitterDateConfirmed bit,
	ProductionFarm_FumigationDate date, 
	ProductionFarm_FumigationDateConfirmed bit,

	BlankFieldForSpace varchar(10) default '',
	DisplayStyle_OriginalDates varchar(20),
	DisplayStyle_PlannedDates varchar(50),
	DisplayStyle_ActualDates varchar(50),
	PlannedHatchDateFormat varchar(50),

	PulletFacility_RemoveDate_Format varchar(50),
	PulletFacility_FumigationDate_Format varchar(50),
	PulletFacility_LitterDate_Format varchar(50),
	PulletFacility_WashDownDate_Format varchar(50),
	ProductionFarm_RemoveDate_Format varchar(50),
	ProductionFarm_FumigationDate_Format varchar(50),
	ProductionFarm_LitterDate_Format varchar(50),
	ProductionFarm_WashDownDate_Format varchar(50),
	FlockMoved bit default 0
)


insert into @Data (FarmID, PulletFarmPlanID, Actual24WeekDate, ActualStartDate, ContractTypeID, UserMessage)
select FarmID, PulletFarmPlanID, Planned24WeekDate, StartDate, ContractTypeID, 'This flock had already been confirmed!  Click save if it must be changed.'
from UserFlockPlanChanges 
where UserFlockPlanChangesID = @UserFlockPlanChangesID

update d set d.PulletQtyAt16Weeks = f.DefaultPulletQty, FarmNumber = f.FarmNumber, ConservativeFactor = f.ConservativeFactor, 
FlockNumber = 'M' + convert(varchar(10),f.FarmNumber) + '-' + right('00' + convert(varchar(2),datepart(wk, dateadd(week,-24,ActualStartDate))),2) + '-' + right(convert(varchar(4),datepart(year,dateadd(week,-24,ActualStartDate))),2)
from @Data d 
inner join Farm f on d.FarmID = f.FarmID

update @Data set 
	ActualHatchDate = DATEADD(week, -24, Actual24WeekDate),
	Actual16WeekDate = dateadd(week, -8, Actual24WeekDate),
	Actual65WeekDate = dateadd(week, 41, Actual24WeekDate),
	DisplayStyle_OriginalDates = '',
	DisplayStyle_PlannedDates = 'RemovalDate Not ReadOnly',
	DisplayStyle_ActualDates = 'Not ReadOnly',
	PlannedHatchDateFormat = 'grayFont', 
	PulletFacility_RemoveDate_Format = 'blackFont',
	PulletFacility_FumigationDate_Format = 'blackFont',
	PulletFacility_LitterDate_Format = 'blackFont',
	PulletFacility_WashDownDate_Format = 'blackFont',
	ProductionFarm_RemoveDate_Format = 'blackFont',
	ProductionFarm_FumigationDate_Format = 'blackFont',
	ProductionFarm_LitterDate_Format = 'blackFont',
	ProductionFarm_WashDownDate_Format = 'blackFont'


if exists (select 1 from @Data where PulletFarmPlanID is not null)
begin
	declare @InvalidDates table (FieldName varchar(50))
	declare @PulletFarmPlanID int
	select top 1 @PulletFarmPlanID = PulletFarmPlanID from @Data
	
	insert into @InvalidDates
	select * from dbo.TestModifiedAfterOrderConfirmDates(@PulletFarmPlanID)

	update d set 
		d.FlockNumber = pfp.FlockNumber, 
		d.ProductionFarm_RemoveDate = pfp.ProductionFarm_RemoveDate,
		d.ProductionFarm_RemovalDateConfirmed = pfp.ProductionFarm_RemovalDateConfirmed, 
		d.ProductionFarm_WashDownDate = pfp.ProductionFarm_WashDownDate, 
		d.ProductionFarm_WashDownDateConfirmed = pfp.ProductionFarm_WashDownDateConfirmed, 
		d.ProductionFarm_LitterDate = pfp.ProductionFarm_LitterDate, 
		d.ProductionFarm_LitterDateConfirmed = pfp.ProductionFarm_LitterDateConfirmed, 
		d.ProductionFarm_FumigationDate = pfp.ProductionFarm_FumigationDate, 
		d.ProductionFarm_FumigationDateConfirmed = pfp.ProductionFarm_FumigationDateConfirmed, 


		d.PulletFacility_RemoveDate = pfp.PulletFacility_RemoveDate, 
		d.PulletFacility_RemovalDateConfirmed = pfp.PulletFacility_RemovalDateConfirmed,
		d.PulletFacility_WashDownDate = pfp.PulletFacility_WashDownDate, 
		d.PulletFacility_WashDownDateConfirmed = pfp.PulletFacility_WashDownDateConfirmed, 
		d.PulletFacility_LitterDate = pfp.PulletFacility_LitterDate, 
		d.PulletFacility_LitterDateConfirmed = pfp.PulletFacility_LitterDateConfirmed, 
		d.PulletFacility_FumigationDate = pfp.PulletFacility_FumigationDate,
		d.PulletFacility_FumigationDateConfirmed = pfp.PulletFacility_FumigationDateConfirmed,
		d.PulletQtyAt16Weeks = pfp.PulletQtyAt16Weeks,
		d.Original_Planned16WeekDate = coalesce(pfp.Actual16WeekDate, pfp.Planned16WeekDate), 
		d.Original_Planned24WeekDate = coalesce(pfp.Actual24WeekDate, pfp.Planned24WeekDate), 
		d.Original_ProductionFarm_PlannedRemoveDate =coalesce(pfp.ProductionFarm_RemoveDate, pfp.ProductionFarm_PlannedRemoveDate),
		d.Original_PlannedStartDate = coalesce(pfp.ActualStartDate, pfp.Actual24WeekDate, pfp.PlannedStartDate, pfp.Planned24WeekDate),
		DisplayStyle_PlannedDates =
			case
				when d.ProductionFarm_RemoveDate is null then 'RemovalDate Not ReadOnly'
				else 'ReadOnly'
			end,
		DisplayStyle_ActualDates = 
			case
				when d.ActualHatchDate <= getdate() then 'ReadOnly'
				else 'Not ReadOnly'
			end,
		PlannedHatchDateFormat = 'redFont',
		PulletFacility_RemoveDate_Format = 
			case
				when exists (select 1 from @InvalidDates where FieldName = 'PulletFacility_RemoveDate') then 'redFont'
				else 'blackFont'
			end,
		PulletFacility_FumigationDate_Format = 
			case
				when exists (select 1 from @InvalidDates where FieldName = 'PulletFacility_FumigationDate') then 'redFont'
				else 'blackFont'
			end,
		PulletFacility_LitterDate_Format = 
			case
				when exists (select 1 from @InvalidDates where FieldName = 'PulletFacility_LitterDate') then 'redFont'
				else 'blackFont'
			end,
		PulletFacility_WashDownDate_Format = 
			case
				when exists (select 1 from @InvalidDates where FieldName = 'PulletFacility_WashDownDate') then 'redFont'
				else 'blackFont'
			end,
		ProductionFarm_RemoveDate_Format = 
			case
				when exists (select 1 from @InvalidDates where FieldName = 'ProductionFarm_RemoveDate') then 'redFont'
				else 'blackFont'
			end,
		ProductionFarm_FumigationDate_Format = 
			case
				when exists (select 1 from @InvalidDates where FieldName = 'ProductionFarm_FumigationDate') then 'redFont'
				else 'blackFont'
			end,
		ProductionFarm_LitterDate_Format = 
			case
				when exists (select 1 from @InvalidDates where FieldName = 'ProductionFarm_LitterDate') then 'redFont'
				else 'blackFont'
			end,
		ProductionFarm_WashDownDate_Format = 
			case
				when exists (select 1 from @InvalidDates where FieldName = 'ProductionFarm_WashDownDate') then 'redFont'
				else 'blackFont'
			end,
		d.FlockMoved = 1
	from @Data d
	inner join PulletFarmPlan pfp on d.PulletFarmPlanID = pfp.PulletFarmPlanID

	update @Data set 
		Original_Planned16WeekDate = dateadd(week, -8, Original_Planned24WeekDate),
		Original_Planned65WeekDate = dateadd(week, 41, Original_Planned24WeekDate),
		Original_PlannedHatchDate = dateadd(week, -24, Original_Planned24WeekDate),
		DisplayStyle_OriginalDates = 
			case
				when Original_Planned24WeekDate <> PlannedStartDate then 'Visible'
				else ''
			end
end


select *, 
	BlankFieldForSpace = ''
from @Data 


