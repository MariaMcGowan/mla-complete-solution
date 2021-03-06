USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDelivery]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialCommitmentDelivery] DROP CONSTRAINT IF EXISTS [FK__Commercia__Truck__3434A84B]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDelivery]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialCommitmentDelivery] DROP CONSTRAINT IF EXISTS [FK__Commercia__Drive__33408412]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDelivery]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialCommitmentDelivery] DROP CONSTRAINT IF EXISTS [FK__Commercia__Comme__324C5FD9]
GO
/****** Object:  Table [dbo].[CommercialCommitmentDelivery]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[CommercialCommitmentDelivery]
GO
/****** Object:  Table [dbo].[CommercialCommitmentDelivery]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDelivery]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CommercialCommitmentDelivery](
	[CommercialCommitmentDeliveryID] [int] IDENTITY(1,1) NOT NULL,
	[CommercialCommitmentID] [int] NULL,
	[DeliveryDate] [date] NULL,
	[DeliveryQuantity] [int] NULL,
	[DeliveryNotes] [varchar](500) NULL,
	[DriverID] [int] NULL,
	[TruckID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CommercialCommitmentDeliveryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Commercia__Comme__324C5FD9]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDelivery]'))
ALTER TABLE [dbo].[CommercialCommitmentDelivery]  WITH CHECK ADD FOREIGN KEY([CommercialCommitmentID])
REFERENCES [dbo].[CommercialCommitment] ([CommercialCommitmentID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Commercia__Drive__33408412]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDelivery]'))
ALTER TABLE [dbo].[CommercialCommitmentDelivery]  WITH CHECK ADD FOREIGN KEY([DriverID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Commercia__Truck__3434A84B]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDelivery]'))
ALTER TABLE [dbo].[CommercialCommitmentDelivery]  WITH CHECK ADD FOREIGN KEY([TruckID])
REFERENCES [dbo].[Truck] ([TruckID])
GO
