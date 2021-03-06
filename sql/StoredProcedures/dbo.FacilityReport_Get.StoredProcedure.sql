USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FacilityReport_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FacilityReport_Get]
GO
/****** Object:  StoredProcedure [dbo].[FacilityReport_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FacilityReport_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FacilityReport_Get] AS' 
END
GO


ALTER proc [dbo].[FacilityReport_Get]
@FarmID varchar(10) = null
, @PulletFacilityID varchar(10) = null
As

select @FarmID = nullif(@FarmID, '')
	, @PulletFacilityID = nullif(@PulletFacilityID, '')

if @FarmID is not null
begin
	select
		FacilityID = @FarmID
		, FacilityName = f.Farm
		--, Address = dbo.FormatAddress(f.Address1, f.Address2, f.City, f.State, f.Zip, 'char(10)char(13)')
		, AddressLine = coalesce(f.Address1, f.Address2)
		, AddressCityStateZip = 
			case
				when isnull(f.City, '') <> '' then f.City + ', '
				else ''
			end + 
			case
				when isnull(f.State, '') <> '' then f.State + ' '
				else ''
			end +
			f.Zip
		, FacilityCode = FarmNumber
		--, MailingAddress = dbo.FormatAddress(f.MailingAddress1, f.MailingAddress2, f.MailingCity, f.MailingState, f.MailingZip, '<br/>')
		, MailingAddressLine = coalesce(f.MailingAddress1, f.MailingAddress2)
		, MailingAddressCityStateZip = 
			case
				when isnull(f.MailingCity, '') <> '' then f.MailingCity + ', '
				else ''
			end + 
			case
				when isnull(f.MailingState, '') <> '' then f.MailingState + ' '
				else ''
			end +
			f.MailingZip
		, FacilityOwner
		, PulletOrLayer = 'Layer'
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
	from dbo.Farm f
	where FarmID = convert(int, @FarmID)
end
else if @PulletFacilityID is not null
begin
	select
		FacilityID = pfl.PulletFacilityLocationID
		, FacilityName = pf.PulletFacility + ' ' + isnull(LocationName, '')
		--, Address = dbo.FormatAddress(pf.Address1, pf.Address2, pf.City, pf.State, pf.Zip, '<br/>')
		, AddressLine = coalesce(pf.Address1, pf.Address2)
		, AddressCityStateZip = 
			case
				when isnull(pf.City, '') <> '' then pf.City + ', '
				else ''
			end +
			case
				when isnull(pf.State, '') <> '' then pf.State + ' '
				else ''
			end +
			pf.Zip
		, FacilityCode = pf.PulletFacility
		--, MailingAddress = dbo.FormatAddress(pf.MailingAddress1, pf.MailingAddress2, pf.MailingCity, pf.MailingState, pf.MailingZip, '<br/>')
		, MailingAddressLine = coalesce(pf.MailingAddress1, pf.MailingAddress2)
		, MailingAddressCityStateZip = 
			case
				when isnull(pf.MailingCity, '') <> '' then pf.MailingCity + ', '
				else ''
			end + 
			case
				when isnull(pf.MailingState, '') <> '' then pf.MailingState + ' '
				else ''
			end +
			pf.MailingZip
		, FacilityOwner
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
	from dbo.PulletFacility pf 
	left outer join PulletFacilityLocation pfl on pf.PulletFacilityID = pfl.PulletFacilityID
	where pf.PulletFacilityID = convert(int, @PulletFacilityID)
end



GO
