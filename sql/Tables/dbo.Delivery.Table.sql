USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Delivery]') AND type in (N'U'))
ALTER TABLE [dbo].[Delivery] DROP CONSTRAINT IF EXISTS [FK_Delivery_InvoiceID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Delivery]') AND type in (N'U'))
ALTER TABLE [dbo].[Delivery] DROP CONSTRAINT IF EXISTS [FK__Delivery__TruckI__4336F4B9]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Delivery]') AND type in (N'U'))
ALTER TABLE [dbo].[Delivery] DROP CONSTRAINT IF EXISTS [FK__Delivery__Holdin__2F4FF79D]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Delivery]') AND type in (N'U'))
ALTER TABLE [dbo].[Delivery] DROP CONSTRAINT IF EXISTS [FK__Delivery__Driver__536D5C82]
GO
/****** Object:  Table [dbo].[Delivery]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[Delivery]
GO
/****** Object:  Table [dbo].[Delivery]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Delivery]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Delivery](
	[DeliveryID] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryDescription] [nvarchar](255) NULL,
	[PlannedQty] [int] NULL,
	[ActualQty] [int] NULL,
	[TruckID] [int] NULL,
	[TimeOfDelivery] [time](7) NULL,
	[DriverID] [int] NULL,
	[InvoiceID] [int] NULL,
	[HoldingIncubatorID] [int] NULL,
	[HoldingIncubatorNotes] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[DeliveryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Delivery__Driver__536D5C82]') AND parent_object_id = OBJECT_ID(N'[dbo].[Delivery]'))
ALTER TABLE [dbo].[Delivery]  WITH CHECK ADD FOREIGN KEY([DriverID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Delivery__Holdin__2F4FF79D]') AND parent_object_id = OBJECT_ID(N'[dbo].[Delivery]'))
ALTER TABLE [dbo].[Delivery]  WITH CHECK ADD FOREIGN KEY([HoldingIncubatorID])
REFERENCES [dbo].[HoldingIncubator] ([HoldingIncubatorID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Delivery__TruckI__4336F4B9]') AND parent_object_id = OBJECT_ID(N'[dbo].[Delivery]'))
ALTER TABLE [dbo].[Delivery]  WITH CHECK ADD FOREIGN KEY([TruckID])
REFERENCES [dbo].[Truck] ([TruckID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Delivery_InvoiceID]') AND parent_object_id = OBJECT_ID(N'[dbo].[Delivery]'))
ALTER TABLE [dbo].[Delivery]  WITH CHECK ADD  CONSTRAINT [FK_Delivery_InvoiceID] FOREIGN KEY([InvoiceID])
REFERENCES [dbo].[Invoice] ([InvoiceID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Delivery_InvoiceID]') AND parent_object_id = OBJECT_ID(N'[dbo].[Delivery]'))
ALTER TABLE [dbo].[Delivery] CHECK CONSTRAINT [FK_Delivery_InvoiceID]
GO
