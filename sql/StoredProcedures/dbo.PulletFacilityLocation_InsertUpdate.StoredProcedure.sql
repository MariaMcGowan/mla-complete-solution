USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PulletFacilityLocation_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PulletFacilityLocation_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[PulletFacilityLocation_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFacilityLocation_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PulletFacilityLocation_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[PulletFacilityLocation_InsertUpdate]
	 @I_vPulletFacilityID int
	,@I_vPulletFacilityLocationID int
	,@I_vLocationName varchar(100) = null
	,@I_vBirdAreaDimensions varchar(20)=null
	,@I_vFeedlinePerching varchar(20)=null
	,@I_vPenCount varchar(20)=null
	,@I_vPerchingLinearFt varchar(20)=null
	,@I_vActualFloorSqFt_wNest varchar(20)=null
	,@I_vFeedPanDiameter varchar(20)=null
	,@I_vActualFloorSqFt_woNest varchar(20)=null
	,@I_vLightingType varchar(100) = null
	,@I_vScratchAreaSqFt varchar(20)=null
	,@I_vWateringEquipBrand varchar(100) = null
	,@I_vPitFans varchar(20)=null
	,@I_vNippleCount varchar(20)=null
	,@I_vInsideAccessToPit varchar(20)=null
	,@I_vNippleSpacingIn varchar(20)=null
	,@I_vNestPitLights varchar(20) = null
	,@I_vWaterlinePerching varchar(20)=null
	,@I_vNestBrand varchar(100) = null
	,@I_vWaterlineCount varchar(20)=null
	,@I_vNestCount varchar(20)=null
	,@I_vFeedingEquipBrand varchar(100) = null
	,@I_vNestPadType varchar(100) = null
	,@I_vFeedLineCountLoop varchar(20)=null
	,@I_vNestDimensions varchar(20) = null
	,@I_vPanCountOrLinearFt varchar(20)=null
	,@I_vPackerTypeModel varchar(100) = null
	,@I_vVentilationFanCountSize varchar(100) = null
	,@I_vEmbryoCoolerDimensions varchar(100) = null
	,@I_vPitType varchar(100) = null
	,@I_vCommericalCoolerDimensions varchar(100) = null
	,@I_vFloorType varchar(100) = null
	,@I_vCommercialProductionEmbryoCoolerUse varchar(20)=null
	,@I_vGeneratorKW varchar(20)=null
	,@I_vWellCount varchar(20)=null
	,@I_vStandardBirdCount_woNests varchar(20)=null
	,@I_vStandardBirdCount_wNests varchar(20)=null
	,@I_vStandardNippleCount varchar(20)=null
	,@I_vStandardFeedSpace varchar(20)=null
	,@I_vStandardSupportedHenCount varchar(20)=null   
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if @I_vPulletFacilityLocationID = 0
begin
	declare @PulletFacilityLocationID table (PulletFacilityLocationID int)
	insert into dbo.PulletFacilityLocation (		
		PulletFacilityID
		, LocationName
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
		, StandardBirdCount_woNests
		, StandardBirdCount_wNests
		, StandardNippleCount
		, StandardFeedSpace
		, StandardSupportedHenCount   
	)
	output inserted.PulletFacilityLocationID into @PulletFacilityLocationID(PulletFacilityLocationID)
	select	
		@I_vPulletFacilityID
		, @I_vLocationName
		, @I_vBirdAreaDimensions
		, @I_vFeedlinePerching
		, @I_vPenCount
		, @I_vPerchingLinearFt 
		, @I_vActualFloorSqFt_wNest 
		, @I_vFeedPanDiameter 
		, @I_vActualFloorSqFt_woNest 
		, @I_vLightingType
		, @I_vScratchAreaSqFt 
		, @I_vWateringEquipBrand
		, @I_vPitFans
		, @I_vNippleCount
		, @I_vInsideAccessToPit
		, @I_vNippleSpacingIn 
		, @I_vNestPitLights
		, @I_vWaterlinePerching
		, @I_vNestBrand
		, @I_vWaterlineCount
		, @I_vNestCount
		, @I_vFeedingEquipBrand
		, @I_vNestPadType
		, @I_vFeedLineCountLoop
		, @I_vNestDimensions
		, @I_vPanCountOrLinearFt
		, @I_vPackerTypeModel
		, @I_vVentilationFanCountSize
		, @I_vEmbryoCoolerDimensions
		, @I_vPitType
		, @I_vCommericalCoolerDimensions
		, @I_vFloorType
		, @I_vCommercialProductionEmbryoCoolerUse
		, @I_vGeneratorKW
		, @I_vWellCount
		, @I_vStandardBirdCount_woNests
		, @I_vStandardBirdCount_wNests
		, @I_vStandardNippleCount
		, @I_vStandardFeedSpace
		, @I_vStandardSupportedHenCount   

	select top 1 @I_vPulletFacilityLocationID = PulletFacilityLocationID, @iRowID = PulletFacilityLocationID from @PulletFacilityLocationID
end
else
begin
	update dbo.PulletFacilityLocation
	set		
		LocationName = @I_vLocationName
		, BirdAreaDimensions = @I_vBirdAreaDimensions
		, FeedlinePerching = @I_vFeedlinePerching
		, PenCount = @I_vPenCount
		, PerchingLinearFt  = @I_vPerchingLinearFt
		, ActualFloorSqFt_wNest = @I_vActualFloorSqFt_wNest
		, FeedPanDiameter = @I_vFeedPanDiameter
		, ActualFloorSqFt_woNest = @I_vActualFloorSqFt_woNest
		, LightingType = @I_vLightingType
		, ScratchAreaSqFt = @I_vScratchAreaSqFt
		, WateringEquipBrand = @I_vWateringEquipBrand
		, PitFans = @I_vPitFans
		, NippleCount = @I_vNippleCount
		, InsideAccessToPit = @I_vInsideAccessToPit
		, NippleSpacingIn = @I_vNippleSpacingIn
		, NestPitLights = @I_vNestPitLights
		, WaterlinePerching = @I_vWaterlinePerching
		, NestBrand = @I_vNestBrand
		, WaterlineCount = @I_vWaterlineCount
		, NestCount = @I_vNestCount
		, FeedingEquipBrand = @I_vFeedingEquipBrand
		, NestPadType = @I_vNestPadType
		, FeedLineCountLoop = @I_vFeedLineCountLoop
		, NestDimensions = @I_vNestDimensions
		, PanCountOrLinearFt = @I_vPanCountOrLinearFt
		, PackerTypeModel = @I_vPackerTypeModel
		, VentilationFanCountSize = @I_vVentilationFanCountSize
		, EmbryoCoolerDimensions = @I_vEmbryoCoolerDimensions
		, PitType = @I_vPitType
		, CommericalCoolerDimensions = @I_vCommericalCoolerDimensions
		, FloorType = @I_vFloorType
		, CommercialProductionEmbryoCoolerUse = @I_vCommercialProductionEmbryoCoolerUse
		, GeneratorKW = @I_vGeneratorKW
		, WellCount = @I_vWellCount
		, StandardBirdCount_woNests = @I_vStandardBirdCount_woNests
		, StandardBirdCount_wNests = @I_vStandardBirdCount_wNests
		, StandardNippleCount = @I_vStandardNippleCount
		, StandardFeedSpace = @I_vStandardFeedSpace
		, StandardSupportedHenCount = @I_vStandardSupportedHenCount
	where PulletFacilityLocationID = @I_vPulletFacilityLocationID

	select @iRowID = @I_vPulletFacilityLocationID
end


---- Update Pullet Facility fields
--	update PulletFacility set
--	  Address1 = @I_vAddress1
--	  , Address2 = @I_vAddress2
--	  , City = @I_vCity
--	  , State = @I_vState
--	  , Zip = @I_vZip
--	  , MailingAddress1 = @I_vMailingAddress1
--	  , MailingAddress2 = @I_vMailingAddress2
--	  , MailingCIty = @I_vMailingCity
--	  , MailingState = @I_vMailingState
--	  , MailingZip = @I_vMailingZip

--	 where @I_vPulletFacilityID = PulletFacilityID   

select @I_vPulletFacilityLocationID as ID,'forward' As referenceType


GO
