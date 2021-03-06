USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Farm]') AND type in (N'U'))
ALTER TABLE [dbo].[Farm] DROP CONSTRAINT IF EXISTS [FK__Farm__PlanningCo__577DE488]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Farm]') AND type in (N'U'))
ALTER TABLE [dbo].[Farm] DROP CONSTRAINT IF EXISTS [Farm_SecondaryContactID_FK]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Farm]') AND type in (N'U'))
ALTER TABLE [dbo].[Farm] DROP CONSTRAINT IF EXISTS [Farm_PrimaryContactID_FK]
GO
/****** Object:  Table [dbo].[Farm]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[Farm]
GO
/****** Object:  Table [dbo].[Farm]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Farm]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Farm](
	[FarmID] [int] IDENTITY(1,1) NOT NULL,
	[Farm] [nvarchar](255) NULL,
	[PrimaryContactID] [int] NULL,
	[SecondaryContactID] [int] NULL,
	[Address1] [varchar](100) NULL,
	[Address2] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](2) NULL,
	[Zip] [varchar](10) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
	[FarmNumber] [int] NULL,
	[MapleLawnFarm] [bit] NULL,
	[MLA_MainProperty] [bit] NULL,
	[MLA_ContractFarm] [bit] NULL,
	[BirdsOwnedBy] [varchar](50) NULL,
	[PlanningColorID] [int] NULL,
	[ConservativeFactor] [numeric](10, 6) NULL,
	[MaxPulletQty] [int] NULL,
	[DefaultPulletQty] [int] NULL,
	[FacilityOwner] [varchar](100) NULL,
	[MailingAddress1] [varchar](100) NULL,
	[MailingAddress2] [varchar](100) NULL,
	[MailingCity] [varchar](100) NULL,
	[MailingState] [varchar](2) NULL,
	[MailingZip] [varchar](10) NULL,
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
	[FarmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Farm_PrimaryContactID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Farm]'))
ALTER TABLE [dbo].[Farm]  WITH CHECK ADD  CONSTRAINT [Farm_PrimaryContactID_FK] FOREIGN KEY([PrimaryContactID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Farm_PrimaryContactID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Farm]'))
ALTER TABLE [dbo].[Farm] CHECK CONSTRAINT [Farm_PrimaryContactID_FK]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Farm_SecondaryContactID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Farm]'))
ALTER TABLE [dbo].[Farm]  WITH CHECK ADD  CONSTRAINT [Farm_SecondaryContactID_FK] FOREIGN KEY([SecondaryContactID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Farm_SecondaryContactID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Farm]'))
ALTER TABLE [dbo].[Farm] CHECK CONSTRAINT [Farm_SecondaryContactID_FK]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Farm__PlanningCo__577DE488]') AND parent_object_id = OBJECT_ID(N'[dbo].[Farm]'))
ALTER TABLE [dbo].[Farm]  WITH CHECK ADD FOREIGN KEY([PlanningColorID])
REFERENCES [dbo].[PlanningColor] ([PlanningColorID])
GO
