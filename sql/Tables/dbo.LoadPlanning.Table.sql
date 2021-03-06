USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning]') AND type in (N'U'))
ALTER TABLE [dbo].[LoadPlanning] DROP CONSTRAINT IF EXISTS [LoadPlanning_OverflowFlockID_FK]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning]') AND type in (N'U'))
ALTER TABLE [dbo].[LoadPlanning] DROP CONSTRAINT IF EXISTS [FK__LoadPlann__Overf__4D1564AE]
GO
/****** Object:  Table [dbo].[LoadPlanning]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[LoadPlanning]
GO
/****** Object:  Table [dbo].[LoadPlanning]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LoadPlanning](
	[LoadPlanningID] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryDate] [date] NULL,
	[OverflowFlockID] [int] NULL,
	[PercentCushion] [numeric](5, 2) NULL,
	[TargetQty] [int] NULL,
	[OrderIncubatorID1] [int] NULL,
	[OrderIncubatorID2] [int] NULL,
	[OrderIncubatorID3] [int] NULL,
	[OrderIncubatorID4] [int] NULL,
	[OrderIncubatorID5] [int] NULL,
	[OrderIncubatorID6] [int] NULL,
	[OrderIncubatorID7] [int] NULL,
	[OrderIncubatorID8] [int] NULL,
	[SetDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[LoadPlanningID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__LoadPlann__Overf__4D1564AE]') AND parent_object_id = OBJECT_ID(N'[dbo].[LoadPlanning]'))
ALTER TABLE [dbo].[LoadPlanning]  WITH CHECK ADD FOREIGN KEY([OverflowFlockID])
REFERENCES [dbo].[orig_Flock] ([FlockID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning_OverflowFlockID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[LoadPlanning]'))
ALTER TABLE [dbo].[LoadPlanning]  WITH CHECK ADD  CONSTRAINT [LoadPlanning_OverflowFlockID_FK] FOREIGN KEY([OverflowFlockID])
REFERENCES [dbo].[PulletFarmPlan] ([PulletFarmPlanID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning_OverflowFlockID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[LoadPlanning]'))
ALTER TABLE [dbo].[LoadPlanning] CHECK CONSTRAINT [LoadPlanning_OverflowFlockID_FK]
GO
