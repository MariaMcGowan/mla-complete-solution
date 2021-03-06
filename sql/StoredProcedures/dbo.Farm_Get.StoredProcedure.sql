/****** Object:  StoredProcedure [dbo].[Farm_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Farm_Get]
GO
/****** Object:  StoredProcedure [dbo].[Farm_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[Farm_Get]
@FarmID int = null
,@IncludeNew bit = 0
,@UserName nvarchar(255) = null
As

select
	f.FarmID
	, f.Farm
	, f.FarmNumber
	, f.PrimaryContactID
	, f.SecondaryContactID
	, Address = dbo.FormatAddress(f.Address1, f.Address2, f.City, f.State, f.Zip, '<br/>')
	, f.Address1
	, f.Address2
	, f.City
	, f.State
	, f.Zip
	, MailingAddress = dbo.FormatAddress(f.MailingAddress1, f.MailingAddress2, f.MailingCity, f.MailingState, f.MailingZip, '<br/>')
	, f.MailingAddress1
	, f.MailingAddress2
	, f.MailingCity
	, f.MailingState
	, f.MailingZip
	, f.MapleLawnFarm
	, f.SortOrder
	, f.IsActive
	, f.ConservativeFactor
	, IsNull(rtrim(c.FirstName),'') + ' ' + IsNull(rtrim(c.LastName),'') As PrimaryContact
	, @UserName As UserName
	, FacilityOwner
	, PulletOrLayer = 'Layer'
	, FederalPremiseID
	, StatePremiseID
	, FDANumber
	, BirdAreaDimensions
	, FeedlinePerching
	, PenCount
	, PerchingLinearFt
	, ActualFloorSqFt_wNest
	, FeedPanDiameter
	, ActualFloorSqFt_woNest
	, LightingType
	, ScratchAreaSqFt
	, WateringEquipBrand
	, PitFans
	, NippleCount
	, InsideAccessToPit
	, NippleSpacingIn
	, NestPitLights
	, WaterlinePerching
	, NestBrand
	, WaterlineCount
	, NestCount
	, FeedingEquipBrand
	, NestPadType
	, FeedLineCountLoop
	, NestDimensions
	, PanCountOrLinearFt
	, PackerTypeModel
	, VentilationFanCountSize
	, EmbryoCoolerDimensions
	, PitType
	, CommericalCoolerDimensions
	, FloorType
	, CommercialProductionEmbryoCoolerUse
	, GeneratorKW
	, WellCount
	, MaximumBirdCount
	, StandardBirdCount_woNests
	, StandardBirdCount_wNests
	, StandardNippleCount
	, StandardFeedSpace
	, StandardSupportedHenCount
	, f.PlanningColorID
	, PlanningGroup = pc.Description
	, PlanningColor = isnull(pc.PlanningColor, 'White') + 'Background'
from dbo.Farm f
left outer join PlanningColor pc on f.PlanningColorID = pc.PlanningColorID
left outer join Contact c on f.PrimaryContactID = c.ContactID
where IsNull(@FarmID,FarmID) = FarmID --and f.IsActive = 1
union all
select
	FarmID = convert(int,0)
	, Farm = convert(nvarchar(255),null)
	, FarmNumber = convert(int,0)
	, PrimaryContactID = convert(int,null)
	, SecondaryContactID = convert(int,null)
	, Address = convert(varchar(100),null)
	, Address1 = convert(varchar(100),null)
	, Address2 = convert(varchar(100),null)
	, City = convert(varchar(100),null)
	, State = convert(varchar(2),null)
	, Zip = convert(varchar(10),null)
	, MailingAddress = convert(varchar(100),null)
	, MailingAddress1 = convert(varchar(100),null)
	, MailingAddress2 = convert(varchar(100),null)
	, MailingCity = convert(varchar(100),null)
	, MailingState = convert(varchar(2),null)
	, MailingZip = convert(varchar(10),null)
	, MapleLawnFarm = convert(bit,null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,null)
	, ConservativeFactor = convert(int, null)
	, PrimaryContact = convert(varchar(100),null)
	, @UserName As UserName
	, FacilityOwner = convert(varchar(100),null)
	, PulletOrLayer = 'Layer'
	, FederalPremiseID = convert(varchar(20), null)
	, StatePremiseID = convert(varchar(20), null)
	, FDANumber = convert(varchar(20), null)
	, BirdAreaDimensions = convert(varchar(20),null)
	, FeedlinePerching = convert(varchar(20),null)
	, PenCount = convert(varchar(20),null)
	, PerchingLinearFt = convert(varchar(20),null)
	, ActualFloorSqFt_wNest = convert(varchar(20),null)
	, FeedPanDiameter = convert(varchar(20),null)
	, ActualFloorSqFt_woNest = convert(varchar(20),null)
	, LightingType = convert(varchar(100),null)
	, ScratchAreaSqFt = convert(varchar(20),null)
	, WateringEquipBrand = convert(varchar(100),null)
	, PitFans = convert(varchar(20),null)
	, NippleCount = convert(varchar(20),null)
	, InsideAccessToPit = convert(varchar(20),null)
	, NippleSpacingIn = convert(varchar(20),null)
	, NestPitLights = convert(varchar(20),null)
	, WaterlinePerching = convert(varchar(20),null)
	, NestBrand = convert(varchar(100),null)
	, WaterlineCount = convert(varchar(20),null)
	, NestCount = convert(varchar(20),null)
	, FeedingEquipBrand = convert(varchar(100),null)
	, NestPadType = convert(varchar(50),null)
	, FeedLineCountLoop = convert(varchar(20),null)
	, NestDimensions = convert(varchar(20),null)
	, PanCountOrLinearFt = convert(varchar(20),null)
	, PackerTypeModel = convert(varchar(50),null)
	, VentilationFanCountSize = convert(varchar(100),null)
	, EmbryoCoolerDimensions = convert(varchar(20),null)
	, PitType = convert(varchar(100),null)
	, CommericalCoolerDimensions = convert(varchar(20),null)
	, FloorType = convert(varchar(50),null)
	, CommercialProductionEmbryoCoolerUse = convert(varchar(20),null)
	, GeneratorKW = convert(varchar(20),null)
	, WellCount = convert(varchar(20),null)
	, MaximumBirdCount = convert(varchar(20),null)
	, StandardBirdCount_woNests = convert(varchar(20),null)
	, StandardBirdCount_wNests = convert(varchar(20),null)
	, StandardNippleCount = convert(varchar(20),null)
	, StandardFeedSpace = convert(varchar(20),null)
	, StandardSupportedHenCount = convert(varchar(20),null)
	, PlanningColorID = convert(int, null)
	, PlanningGroup = convert(varchar(50), null)
	, PlanningColor = convert(varchar(20), null)
where @IncludeNew = 1
order by SortOrder



GO
