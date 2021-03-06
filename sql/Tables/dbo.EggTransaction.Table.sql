USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction]') AND type in (N'U'))
ALTER TABLE [dbo].[EggTransaction] DROP CONSTRAINT IF EXISTS [EggTransaction_FlockID_FK]
GO
/****** Object:  Table [dbo].[EggTransaction]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[EggTransaction]
GO
/****** Object:  Table [dbo].[EggTransaction]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EggTransaction](
	[EggTransactionID] [int] IDENTITY(1,1) NOT NULL,
	[ClutchID] [int] NULL,
	[QtyChange] [int] NULL,
	[QtyChangeReasonID] [int] NULL,
	[QtyChangeActualDate] [datetime] NULL,
	[QtyChangeRecordedDate] [datetime] NULL,
	[UseName] [varchar](255) NULL,
	[ClutchQtyAfterTransaction] [int] NULL,
	[FlockID] [int] NULL,
	[CoolerClutchID] [int] NULL,
	[OrderIncubatorCartID] [int] NULL,
	[DeliveryCartFlockID] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_FlockID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[EggTransaction]'))
ALTER TABLE [dbo].[EggTransaction]  WITH CHECK ADD  CONSTRAINT [EggTransaction_FlockID_FK] FOREIGN KEY([FlockID])
REFERENCES [dbo].[PulletFarmPlan] ([PulletFarmPlanID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_FlockID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[EggTransaction]'))
ALTER TABLE [dbo].[EggTransaction] CHECK CONSTRAINT [EggTransaction_FlockID_FK]
GO
