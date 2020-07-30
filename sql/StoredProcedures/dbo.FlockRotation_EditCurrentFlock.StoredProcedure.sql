DROP PROCEDURE IF EXISTS [dbo].FlockRotation_EditCurrentFlock
GO

create proc [dbo].[FlockRotation_EditCurrentFlock]
	@PulletFarmPlanID int
as


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
	ProductionFarm_PlannedRemoveDate date,
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

declare @InvalidDates table (FieldName varchar(50))
select top 1 @PulletFarmPlanID = PulletFarmPlanID from @Data
	
insert into @InvalidDates
select * from dbo.TestModifiedAfterOrderConfirmDates(@PulletFarmPlanID)


insert into @Data (
FarmID, FarmNumber, PulletFarmPlanID, ContractTypeID, PulletQtyAt16Weeks, FlockNumber, ConservativeFactor,
PlannedHatchDate, Planned16WeekDate, Planned24WeekDate, Planned65WeekDate, PlannedStartDate, 
ActualHatchDate, Actual16WeekDate, Actual24WeekDate, Actual65WeekDate, ActualStartDate, 

PulletFacility_RemoveDate,
PulletFacility_RemovalDateConfirmed,  
PulletFacility_WashDownDate, 
PulletFacility_WashDownDateConfirmed,  
PulletFacility_LitterDate, 
PulletFacility_LitterDateConfirmed,  
PulletFacility_FumigationDate,
PulletFacility_FumigationDateConfirmed,  

ProductionFarm_PlannedRemoveDate,
ProductionFarm_RemoveDate, 
ProductionFarm_RemovalDateConfirmed, 
ProductionFarm_WashDownDate, 
ProductionFarm_WashDownDateConfirmed,  
ProductionFarm_LitterDate, 
ProductionFarm_LitterDateConfirmed,  
ProductionFarm_FumigationDate, 
ProductionFarm_FumigationDateConfirmed,  

DisplayStyle_OriginalDates, DisplayStyle_PlannedDates, DisplayStyle_ActualDates, UserMessage, 
PlannedHatchDateFormat, 
PulletFacility_RemoveDate_Format, PulletFacility_FumigationDate_Format, PulletFacility_LitterDate_Format, PulletFacility_WashDownDate_Format,
ProductionFarm_RemoveDate_Format, ProductionFarm_FumigationDate_Format, ProductionFarm_LitterDate_Format, ProductionFarm_WashDownDate_Format
)
select pfp.FarmID, FarmNumber, PulletFarmPlanID, ContractTypeID, PulletQtyAt16Weeks, FlockNumber, pfp.ConservativeFactor,
PlannedHatchDate, Planned16WeekDate, Planned24WeekDate, Planned65WeekDate, PlannedStartDate, 
ActualHatchDate, Actual16WeekDate, Actual24WeekDate, Actual65WeekDate, ActualStartDate, 

PulletFacility_RemoveDate, 
PulletFacility_RemovalDateConfirmed, 
PulletFacility_WashDownDate, 
PulletFacility_WashDownDateConfirmed, 
PulletFacility_LitterDate, 
PulletFacility_LitterDateConfirmed, 
PulletFacility_FumigationDate,
PulletFacility_FumigationDateConfirmed, 

ProductionFarm_PlannedRemoveDate = ProductionFarm_PlannedRemoveDate,
ProductionFarm_RemoveDate = ProductionFarm_RemoveDate,
ProductionFarm_RemovalDateConfirmed, 
ProductionFarm_WashDownDate, 
ProductionFarm_WashDownDateConfirmed, 
ProductionFarm_LitterDate, 
ProductionFarm_LitterDateConfirmed, 
ProductionFarm_FumigationDate,
ProductionFarm_FumigationDateConfirmed, 

DisplayStyle_OriginalDates = '',
DisplayStyle_PlannedDates =
	case
		when ActualHatchDate is null then 'Not ReadOnly'
		when ProductionFarm_RemoveDate is null then 'RemovalDate Not ReadOnly'
		else 'ReadOnly'
	end,
DisplayStyle_ActualDates = 
	case
		when ActualHatchDate <= getdate() then 'ReadOnly'
		else 'Not ReadOnly'
	end,
UserMessage = 'This flock is currently in production.',
PlannedHatchDateFormat = 
	case
		when pfp.OverrideModifiedAfterOrderConfirm = 0 and exists (select 1 from @InvalidDates where FieldName = 'Planned24WeekDate') then 'redFont'
		when ActualHatchDate is null then 'blackFont'
		else 'grayFont'
	end,
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
	end
from PulletFarmPlan pfp
inner join Farm f on pfp.FarmID = f.FarmID
where PulletFarmPlanID = @PulletFarmPlanID


select *
from @Data

