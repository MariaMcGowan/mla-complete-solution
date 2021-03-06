USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFacilityLocation_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFacilityLocation_Get]
GO
/****** Object:  StoredProcedure [dbo].[PulletFacilityLocation_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFacilityLocation_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFacilityLocation_Get] AS' 
END
GO


ALTER proc [dbo].[PulletFacilityLocation_Get]
@PulletFacilityID int
,@PulletFacilityLocationID int = null
,@IncludeNew bit = 0
,@UserName nvarchar(255) = null
As

declare @PulletFacility varchar(100)

select @PulletFacility = PulletFacility from dbo.PulletFacility where PulletFacilityID = @PulletFacilityID

select
	PulletFacilityID
	, PulletFacility = @PulletFacility
	, PulletFacilityLocationID
	, LocationName
--	, FacilityOwner
	, PulletOrLayer = 'Pullet'
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
from dbo.PulletFacilityLocation
where PulletFacilityID = @PulletFacilityID and PulletFacilityLocationID = isnull(@PulletFacilityLocationID, PulletFacilityLocationID)
union all
select
	PulletFacilityID = @PulletFacilityID
	, PulletFacility = @PulletFacility
	, PulletFacilityLocationID = convert(int, 0)
	, LocationName = convert(varchar(100),null)
--	, FacilityOwner = convert(varchar(100),null)
	, PulletOrLayer = 'Pullet'
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
where @IncludeNew = 1 or @PulletFacilityLocationID = 0



GO
