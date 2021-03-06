USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderClutchCooler]') AND type in (N'U'))
ALTER TABLE [dbo].[OrderClutchCooler] DROP CONSTRAINT IF EXISTS [FK__OrderClut__Coole__473C8FC7]
GO
/****** Object:  Table [dbo].[OrderClutchCooler]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[OrderClutchCooler]
GO
/****** Object:  Table [dbo].[OrderClutchCooler]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderClutchCooler]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderClutchCooler](
	[OrderClutchCoolerID] [int] IDENTITY(1,1) NOT NULL,
	[OrderFlockClutchID] [int] NULL,
	[CoolerID] [int] NULL,
	[PlannedQty] [int] NULL,
	[ActualQty] [int] NULL,
	[DateTimeDelivered] [datetime] NULL,
	[DateTimeMovedToIncubator] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderClutchCoolerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__OrderClut__Coole__473C8FC7]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderClutchCooler]'))
ALTER TABLE [dbo].[OrderClutchCooler]  WITH CHECK ADD FOREIGN KEY([CoolerID])
REFERENCES [dbo].[Cooler] ([CoolerID])
GO
