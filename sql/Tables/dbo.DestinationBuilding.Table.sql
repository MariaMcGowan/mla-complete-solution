USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DestinationBuilding]') AND type in (N'U'))
ALTER TABLE [dbo].[DestinationBuilding] DROP CONSTRAINT IF EXISTS [DestinationBuilding_DestinationID_FK]
GO
/****** Object:  Table [dbo].[DestinationBuilding]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[DestinationBuilding]
GO
/****** Object:  Table [dbo].[DestinationBuilding]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DestinationBuilding]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DestinationBuilding](
	[DestinationBuildingID] [int] IDENTITY(1,1) NOT NULL,
	[DestinationBuilding] [varchar](255) NULL,
	[DestinationID] [int] NULL,
	[Notes] [varchar](1000) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
	[Address1] [varchar](100) NULL,
	[Address2] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](2) NULL,
	[Zip] [varchar](10) NULL,
	[InvoiceContactInfo] [varchar](100) NULL,
	[DefaultContractTypeID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DestinationBuildingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DestinationBuilding_DestinationID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[DestinationBuilding]'))
ALTER TABLE [dbo].[DestinationBuilding]  WITH CHECK ADD  CONSTRAINT [DestinationBuilding_DestinationID_FK] FOREIGN KEY([DestinationID])
REFERENCES [dbo].[Destination] ([DestinationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DestinationBuilding_DestinationID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[DestinationBuilding]'))
ALTER TABLE [dbo].[DestinationBuilding] CHECK CONSTRAINT [DestinationBuilding_DestinationID_FK]
GO
