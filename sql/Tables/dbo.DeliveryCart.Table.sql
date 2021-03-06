USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryCart]') AND type in (N'U'))
ALTER TABLE [dbo].[DeliveryCart] DROP CONSTRAINT IF EXISTS [FK__DeliveryC__Order__3138400F]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryCart]') AND type in (N'U'))
ALTER TABLE [dbo].[DeliveryCart] DROP CONSTRAINT IF EXISTS [FK__DeliveryC__Deliv__30441BD6]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryCart]') AND type in (N'U'))
ALTER TABLE [dbo].[DeliveryCart] DROP CONSTRAINT IF EXISTS [FK__DeliveryC__Coole__231F2AE2]
GO
/****** Object:  Table [dbo].[DeliveryCart]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[DeliveryCart]
GO
/****** Object:  Table [dbo].[DeliveryCart]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryCart]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeliveryCart](
	[DeliveryCartID] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryCart] [varchar](255) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
	[CartNumber] [varchar](25) NULL,
	[IncubatorLocationNumber] [int] NULL,
	[CoolerID] [int] NULL,
	[LoadDateTime] [datetime] NULL,
	[DeliveryID] [int] NULL,
	[OrderID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DeliveryCartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__DeliveryC__Coole__231F2AE2]') AND parent_object_id = OBJECT_ID(N'[dbo].[DeliveryCart]'))
ALTER TABLE [dbo].[DeliveryCart]  WITH CHECK ADD FOREIGN KEY([CoolerID])
REFERENCES [dbo].[Cooler] ([CoolerID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__DeliveryC__Deliv__30441BD6]') AND parent_object_id = OBJECT_ID(N'[dbo].[DeliveryCart]'))
ALTER TABLE [dbo].[DeliveryCart]  WITH CHECK ADD FOREIGN KEY([DeliveryID])
REFERENCES [dbo].[Delivery] ([DeliveryID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__DeliveryC__Order__3138400F]') AND parent_object_id = OBJECT_ID(N'[dbo].[DeliveryCart]'))
ALTER TABLE [dbo].[DeliveryCart]  WITH CHECK ADD FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
