USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDelivery]') AND type in (N'U'))
ALTER TABLE [dbo].[OrderDelivery] DROP CONSTRAINT IF EXISTS [FK__OrderDeli__Order__168449D3]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDelivery]') AND type in (N'U'))
ALTER TABLE [dbo].[OrderDelivery] DROP CONSTRAINT IF EXISTS [FK__OrderDeli__Deliv__17786E0C]
GO
/****** Object:  Table [dbo].[OrderDelivery]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[OrderDelivery]
GO
/****** Object:  Table [dbo].[OrderDelivery]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDelivery]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderDelivery](
	[OrderDeliveryID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[DeliveryID] [int] NULL,
	[DeliverySlip] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderDeliveryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__OrderDeli__Deliv__17786E0C]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderDelivery]'))
ALTER TABLE [dbo].[OrderDelivery]  WITH CHECK ADD FOREIGN KEY([DeliveryID])
REFERENCES [dbo].[Delivery] ([DeliveryID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__OrderDeli__Order__168449D3]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderDelivery]'))
ALTER TABLE [dbo].[OrderDelivery]  WITH CHECK ADD FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
