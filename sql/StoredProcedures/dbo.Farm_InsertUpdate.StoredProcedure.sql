/****** Object:  StoredProcedure [dbo].[Farm_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Farm_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Farm_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[Farm_InsertUpdate]
	@I_vFarmID int
	,@I_vFarm nvarchar(255)=null
	,@I_vFarmNumber int=null
	,@I_vPrimaryContactID int=null
	,@I_vSecondaryContactID int=null
	,@I_vAddress1 varchar(100)=null
	,@I_vAddress2 varchar(100)=null
	,@I_vCity varchar(100)=null
	,@I_vState varchar(2)=null
	,@I_vZip varchar(10)=null
	,@I_vMapleLawnFarm bit=null
	,@I_vSortOrder int=null
	,@I_vIsActive bit=null
	,@I_vConservativeFactor float = null
	,@I_vUserName nvarchar(255)
	,@I_vMailingAddress1 varchar(100)=null
	,@I_vMailingAddress2 varchar(100)=null
	,@I_vMailingCity varchar(100)=null
	,@I_vMailingState varchar(2)=null
	,@I_vMailingZip varchar(10)=null
	,@I_vFederalPremiseID varchar(20)=null
	,@I_vStatePremiseID varchar(20)=null
	,@I_vFDANumber varchar(20)=null
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
	,@I_vPlanningColorID int = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

set @I_vConservativeFactor = isnull(nullif(@I_vConservativeFactor, ''),.98)
set @I_vPlanningColorID = nullif(@I_vPlanningColorID, '')

select @I_vIsActive = isnull(@I_vIsActive, 1)

if @I_vConservativeFactor > 1
begin
	-- this is a ratio, it cannot be greater than 1
	-- if it is, the user entered it as a percentage
	-- therefore divide by 100
	select @I_vConservativeFactor = round(@I_vConservativeFactor / 100.00,2)
end

if @I_vFarmID = 0
begin
	declare @FarmID table (FarmID int)
	insert into dbo.Farm (		
		Farm
		, FarmNumber
		, PrimaryContactID
		, SecondaryContactID
		, Address1
		, Address2
		, City
		, State
		, Zip
		, MapleLawnFarm
		, SortOrder
		, IsActive
		, ConservativeFactor
		, MailingAddress1
		, MailingAddress2
		, MailingCity
		, MailingState
		, MailingZip
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
		, StandardBirdCount_woNests
		, StandardBirdCount_wNests
		, StandardNippleCount
		, StandardFeedSpace
		, StandardSupportedHenCount 
		, PlanningColorID
	)
	output inserted.FarmID into @FarmID(FarmID)
	select	
		@I_vFarm
		,@I_vFarmNumber
		,@I_vPrimaryContactID
		,@I_vSecondaryContactID
		,@I_vAddress1
		,@I_vAddress2
		,@I_vCity
		,@I_vState
		,@I_vZip
		,@I_vMapleLawnFarm
		,@I_vSortOrder
		,@I_vIsActive
		,@I_vConservativeFactor
		,@I_vMailingAddress1
		,@I_vMailingAddress2
		,@I_vMailingCity
		,@I_vMailingState
		,@I_vMailingZip
		,@I_vFederalPremiseID
		,@I_vStatePremiseID
		,@I_vFDANumber 
		,@I_vBirdAreaDimensions
		,@I_vFeedlinePerching
		,@I_vPenCount
		,@I_vPerchingLinearFt 
		,@I_vActualFloorSqFt_wNest 
		,@I_vFeedPanDiameter 
		,@I_vActualFloorSqFt_woNest 
		,@I_vLightingType
		,@I_vScratchAreaSqFt 
		,@I_vWateringEquipBrand
		,@I_vPitFans
		,@I_vNippleCount
		,@I_vInsideAccessToPit
		,@I_vNippleSpacingIn 
		,@I_vNestPitLights
		,@I_vWaterlinePerching
		,@I_vNestBrand
		,@I_vWaterlineCount
		,@I_vNestCount
		,@I_vFeedingEquipBrand
		,@I_vNestPadType
		,@I_vFeedLineCountLoop
		,@I_vNestDimensions
		,@I_vPanCountOrLinearFt
		,@I_vPackerTypeModel
		,@I_vVentilationFanCountSize
		,@I_vEmbryoCoolerDimensions
		,@I_vPitType
		,@I_vCommericalCoolerDimensions
		,@I_vFloorType
		,@I_vCommercialProductionEmbryoCoolerUse
		,@I_vGeneratorKW
		,@I_vWellCount
		,@I_vStandardBirdCount_woNests
		,@I_vStandardBirdCount_wNests
		,@I_vStandardNippleCount
		,@I_vStandardFeedSpace
		,@I_vStandardSupportedHenCount  
		,@I_vPlanningColorID

	select top 1 @I_vFarmID = FarmID, @iRowID = FarmID from @FarmID
end
else
begin
	update dbo.Farm
	set		
		Farm = @I_vFarm
		, FarmNumber = @I_vFarmNumber
		, PrimaryContactID = @I_vPrimaryContactID
		, SecondaryContactID = @I_vSecondaryContactID
		, Address1 = @I_vAddress1
		, Address2 = @I_vAddress2
		, City = @I_vCity
		, State = @I_vState
		, Zip = @I_vZip
		, MapleLawnFarm = @I_vMapleLawnFarm
		, SortOrder = @I_vSortOrder
		, IsActive = @I_vIsActive
		, ConservativeFactor = @I_vConservativeFactor
		, MailingAddress1 = @I_vMailingAddress1
		, MailingAddress2 = @I_vMailingAddress2
		, MailingCity = @I_vMailingCity
		, MailingState = @I_vMailingState
		, MailingZip = @I_vMailingZip
		, FederalPremiseID = @I_vFederalPremiseID
		, StatePremiseID = @I_vStatePremiseID
		, FDANumber = @I_vFDANumber
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
		, PlanningColorID = @I_vPlanningColorID
	where @I_vFarmID = FarmID

	select @iRowID = @I_vFarmID
end


select @I_vFarmID as ID,'forward' As referenceType


GO
