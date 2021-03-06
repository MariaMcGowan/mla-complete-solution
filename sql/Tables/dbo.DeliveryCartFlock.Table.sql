USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryCartFlock]') AND type in (N'U'))
ALTER TABLE [dbo].[DeliveryCartFlock] DROP CONSTRAINT IF EXISTS [FK__DeliveryC__Flock__35E7E693]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryCartFlock]') AND type in (N'U'))
ALTER TABLE [dbo].[DeliveryCartFlock] DROP CONSTRAINT IF EXISTS [FK__DeliveryC__Deliv__1A54DAB7]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryCartFlock]') AND type in (N'U'))
ALTER TABLE [dbo].[DeliveryCartFlock] DROP CONSTRAINT IF EXISTS [DeliveryCartFlock_FlockID_FK]
GO
/****** Object:  Table [dbo].[DeliveryCartFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[DeliveryCartFlock]
GO
/****** Object:  Table [dbo].[DeliveryCartFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryCartFlock]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeliveryCartFlock](
	[DeliveryCartFlockID] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryCartID] [int] NULL,
	[PlannedQty] [int] NULL,
	[ActualQty] [int] NULL,
	[FlockID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DeliveryCartFlockID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryCartFlock_FlockID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[DeliveryCartFlock]'))
ALTER TABLE [dbo].[DeliveryCartFlock]  WITH CHECK ADD  CONSTRAINT [DeliveryCartFlock_FlockID_FK] FOREIGN KEY([FlockID])
REFERENCES [dbo].[PulletFarmPlan] ([PulletFarmPlanID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryCartFlock_FlockID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[DeliveryCartFlock]'))
ALTER TABLE [dbo].[DeliveryCartFlock] CHECK CONSTRAINT [DeliveryCartFlock_FlockID_FK]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__DeliveryC__Deliv__1A54DAB7]') AND parent_object_id = OBJECT_ID(N'[dbo].[DeliveryCartFlock]'))
ALTER TABLE [dbo].[DeliveryCartFlock]  WITH CHECK ADD FOREIGN KEY([DeliveryCartID])
REFERENCES [dbo].[DeliveryCart] ([DeliveryCartID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__DeliveryC__Flock__35E7E693]') AND parent_object_id = OBJECT_ID(N'[dbo].[DeliveryCartFlock]'))
ALTER TABLE [dbo].[DeliveryCartFlock]  WITH CHECK ADD FOREIGN KEY([FlockID])
REFERENCES [dbo].[PulletFarmPlan] ([PulletFarmPlanID])
GO
