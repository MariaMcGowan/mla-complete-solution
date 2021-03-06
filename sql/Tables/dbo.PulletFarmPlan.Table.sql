USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan]') AND type in (N'U'))
ALTER TABLE [dbo].[PulletFarmPlan] DROP CONSTRAINT IF EXISTS [FK__PulletFar__FarmI__4282C7A2]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan]') AND type in (N'U'))
ALTER TABLE [dbo].[PulletFarmPlan] DROP CONSTRAINT IF EXISTS [FK__PulletFar__Contr__446B1014]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan]') AND type in (N'U'))
ALTER TABLE [dbo].[PulletFarmPlan] DROP CONSTRAINT IF EXISTS [DF__PulletFar__Overr__46535886]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan]') AND type in (N'U'))
ALTER TABLE [dbo].[PulletFarmPlan] DROP CONSTRAINT IF EXISTS [DF__PulletFar__Vacci__455F344D]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan]') AND type in (N'U'))
ALTER TABLE [dbo].[PulletFarmPlan] DROP CONSTRAINT IF EXISTS [DF__PulletFar__Modif__4376EBDB]
GO
/****** Object:  Table [dbo].[PulletFarmPlan]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[PulletFarmPlan]
GO
/****** Object:  Table [dbo].[PulletFarmPlan]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PulletFarmPlan](
	[PulletFarmPlanID] [int] IDENTITY(1,1) NOT NULL,
	[FarmID] [int] NULL,
	[PulletQtyAt16Weeks] [int] NULL,
	[Planned24WeekDate] [date] NULL,
	[PlannedStartDate] [date] NULL,
	[PlannedHatchDate]  AS (dateadd(week,(-24),[Planned24WeekDate])),
	[Planned16WeekDate]  AS (dateadd(week,(-8),[Planned24WeekDate])),
	[Planned65WeekDate]  AS (dateadd(week,(41),[Planned24WeekDate])),
	[PlannedEndDate] [date] NULL,
	[Actual24WeekDate] [date] NULL,
	[ActualStartDate] [date] NULL,
	[ActualHatchDate]  AS (dateadd(week,(-24),[Actual24WeekDate])),
	[Actual16WeekDate]  AS (dateadd(week,(-8),[Actual24WeekDate])),
	[Actual65WeekDate]  AS (dateadd(week,(41),[Actual24WeekDate])),
	[ActualEndDate] [date] NULL,
	[PlannedCommercialEndDate] [date] NULL,
	[ActualCommercialEndDate] [date] NULL,
	[ModifiedAfterOrderConfirm] [bit] NOT NULL,
	[ContractTypeID] [int] NULL,
	[ConservativeFactor] [numeric](8, 6) NULL,
	[Destination] [varchar](100) NULL,
	[ExpectedLivabilityRatio] [numeric](8, 6) NULL,
	[PlannedFemaleOrderQty]  AS (ceiling([PulletQtyAt16Weeks]*[ExpectedLivabilityRatio])),
	[MaleToFemaleBirdRatio] [numeric](8, 6) NULL,
	[PlannedMaleOrderQty]  AS (ceiling(ceiling([PulletQtyAt16Weeks]*[ExpectedLivabilityRatio])*[MaleToFemaleBirdRatio])),
	[ActualFemaleOrderQty] [int] NULL,
	[ActualMaleOrderQty] [int] NULL,
	[PulletFacilityID] [int] NULL,
	[FlockNumber] [varchar](20) NULL,
	[FemaleBreed] [varchar](20) NULL,
	[MaleBreed] [varchar](20) NULL,
	[PulletFacility_RemoveDate] [date] NULL,
	[PulletFacility_MoveDayCount] [int] NULL,
	[PulletMover] [varchar](10) NULL,
	[PulletFacility_WashDownDate] [date] NULL,
	[PulletFacility_LitterDate] [date] NULL,
	[PulletFacility_FumigationDate] [date] NULL,
	[PulletFacility_WashDownContractor] [varchar](10) NULL,
	[ProductionFarm_PlannedRemoveDate] [date] NULL,
	[ProductionFarm_RemoveDate] [date] NULL,
	[ProductionFarm_MoveDayCount] [int] NULL,
	[ProductionFarm_WashDownDate] [date] NULL,
	[ProductionFarm_LitterDate] [date] NULL,
	[ProductionFarm_FumigationDate] [date] NULL,
	[ProductionFarm_WashDownContractor] [varchar](10) NULL,
	[Vaccine] [bit] NULL,
	[OverwrittenIsActiveFlag] [int] NULL,
	[OverrideModifiedAfterOrderConfirm] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PulletFarmPlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PulletFar__Modif__4376EBDB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PulletFarmPlan] ADD  DEFAULT ((0)) FOR [ModifiedAfterOrderConfirm]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PulletFar__Vacci__455F344D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PulletFarmPlan] ADD  DEFAULT ((0)) FOR [Vaccine]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PulletFar__Overr__46535886]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PulletFarmPlan] ADD  DEFAULT ((0)) FOR [OverrideModifiedAfterOrderConfirm]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PulletFar__Contr__446B1014]') AND parent_object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan]'))
ALTER TABLE [dbo].[PulletFarmPlan]  WITH CHECK ADD FOREIGN KEY([ContractTypeID])
REFERENCES [dbo].[ContractType] ([ContractTypeID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PulletFar__FarmI__4282C7A2]') AND parent_object_id = OBJECT_ID(N'[dbo].[PulletFarmPlan]'))
ALTER TABLE [dbo].[PulletFarmPlan]  WITH CHECK ADD FOREIGN KEY([FarmID])
REFERENCES [dbo].[Farm] ([FarmID])
GO
