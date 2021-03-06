USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFacilityLocation]') AND type in (N'U'))
ALTER TABLE [dbo].[PulletFacilityLocation] DROP CONSTRAINT IF EXISTS [FK__PulletFac__Pulle__3F7150CD]
GO
/****** Object:  Table [dbo].[PulletFacilityLocation]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[PulletFacilityLocation]
GO
/****** Object:  Table [dbo].[PulletFacilityLocation]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFacilityLocation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PulletFacilityLocation](
	[PulletFacilityLocationID] [int] IDENTITY(1,1) NOT NULL,
	[PulletFacilityID] [int] NULL,
	[LocationName] [varchar](100) NULL,
	[BirdAreaDimensions] [varchar](20) NULL,
	[FeedlinePerching] [varchar](20) NULL,
	[PenCount] [varchar](20) NULL,
	[PerchingLinearFt] [varchar](20) NULL,
	[ActualFloorSqFt_wNest] [varchar](20) NULL,
	[FeedPanDiameter] [varchar](20) NULL,
	[ActualFloorSqFt_woNest] [varchar](20) NULL,
	[LightingType] [varchar](100) NULL,
	[ScratchAreaSqFt] [varchar](20) NULL,
	[WateringEquipBrand] [varchar](100) NULL,
	[PitFans] [varchar](20) NULL,
	[NippleCount] [varchar](20) NULL,
	[InsideAccessToPit] [varchar](20) NULL,
	[NippleSpacingIn] [varchar](20) NULL,
	[NestPitLights] [varchar](20) NULL,
	[WaterlinePerching] [varchar](20) NULL,
	[NestBrand] [varchar](100) NULL,
	[WaterlineCount] [varchar](20) NULL,
	[NestCount] [varchar](20) NULL,
	[FeedingEquipBrand] [varchar](100) NULL,
	[NestPadType] [varchar](50) NULL,
	[FeedLineCountLoop] [varchar](20) NULL,
	[NestDimensions] [varchar](20) NULL,
	[PanCountOrLinearFt] [varchar](20) NULL,
	[PackerTypeModel] [varchar](50) NULL,
	[VentilationFanCountSize] [varchar](100) NULL,
	[EmbryoCoolerDimensions] [varchar](20) NULL,
	[PitType] [varchar](100) NULL,
	[CommericalCoolerDimensions] [varchar](20) NULL,
	[FloorType] [varchar](50) NULL,
	[CommercialProductionEmbryoCoolerUse] [varchar](20) NULL,
	[GeneratorKW] [varchar](20) NULL,
	[WellCount] [varchar](20) NULL,
	[MaximumBirdCount] [varchar](20) NULL,
	[StandardBirdCount_woNests] [varchar](20) NULL,
	[StandardBirdCount_wNests] [varchar](20) NULL,
	[StandardNippleCount] [varchar](20) NULL,
	[StandardFeedSpace] [varchar](20) NULL,
	[StandardSupportedHenCount] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[PulletFacilityLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PulletFac__Pulle__3F7150CD]') AND parent_object_id = OBJECT_ID(N'[dbo].[PulletFacilityLocation]'))
ALTER TABLE [dbo].[PulletFacilityLocation]  WITH CHECK ADD FOREIGN KEY([PulletFacilityID])
REFERENCES [dbo].[PulletFacility] ([PulletFacilityID])
GO
