USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[PulletFarmPlanDetail] DROP CONSTRAINT IF EXISTS [FK__PulletFar__Pulle__4FDCC2C0]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[PulletFarmPlanDetail] DROP CONSTRAINT IF EXISTS [DF__PulletFar__Reser__50D0E6F9]
GO
/****** Object:  Table [dbo].[PulletFarmPlanDetail]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[PulletFarmPlanDetail]
GO
/****** Object:  Table [dbo].[PulletFarmPlanDetail]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PulletFarmPlanDetail](
	[PulletFarmPlanDetailID] [int] IDENTITY(1,1) NOT NULL,
	[PulletFarmPlanID] [int] NULL,
	[DayNumber] [int] NULL,
	[WeekNumber] [int] NULL,
	[DayOfWeekNumber] [int] NULL,
	[Date] [date] NULL,
	[CalcPulletQty] [int] NULL,
	[CalcTotalEggs] [int] NULL,
	[CalcTotalFloorEggs] [int] NULL,
	[CalcCommercialEggs] [int] NULL,
	[CalcSettableEggs] [int] NULL,
	[CalcSellableEggs] [int] NULL,
	[CalcEggWeightClassificationID] [int] NULL,
	[ActualPulletQty] [int] NULL,
	[ActualTotalEggs] [int] NULL,
	[ActualFloorEggs] [int] NULL,
	[ActualCommercialEggs] [int] NULL,
	[ActualSettableEggs] [int] NULL,
	[ActualSellableEggs] [int] NULL,
	[ActualEggWeightClassificationID] [int] NULL,
	[OverwrittenSettableEggs] [int] NULL,
	[OverwrittenEstimatedYield] [numeric](4, 2) NULL,
	[ReservedForContract] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PulletFarmPlanDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PulletFar__Reser__50D0E6F9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PulletFarmPlanDetail] ADD  DEFAULT ((1)) FOR [ReservedForContract]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PulletFar__Pulle__4FDCC2C0]') AND parent_object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanDetail]'))
ALTER TABLE [dbo].[PulletFarmPlanDetail]  WITH CHECK ADD FOREIGN KEY([PulletFarmPlanID])
REFERENCES [dbo].[PulletFarmPlan] ([PulletFarmPlanID])
GO
