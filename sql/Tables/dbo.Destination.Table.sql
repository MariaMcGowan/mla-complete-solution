USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Destination]') AND type in (N'U'))
ALTER TABLE [dbo].[Destination] DROP CONSTRAINT IF EXISTS [Destination_SecondaryContactID_FK]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Destination]') AND type in (N'U'))
ALTER TABLE [dbo].[Destination] DROP CONSTRAINT IF EXISTS [Destination_PrimaryContactID_FK]
GO
/****** Object:  Table [dbo].[Destination]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[Destination]
GO
/****** Object:  Table [dbo].[Destination]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Destination]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Destination](
	[DestinationID] [int] IDENTITY(1,1) NOT NULL,
	[Destination] [varchar](255) NULL,
	[PrimaryContactID] [int] NULL,
	[SecondaryContactID] [int] NULL,
	[Notes] [varchar](1000) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[DestinationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Destination_PrimaryContactID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Destination]'))
ALTER TABLE [dbo].[Destination]  WITH CHECK ADD  CONSTRAINT [Destination_PrimaryContactID_FK] FOREIGN KEY([PrimaryContactID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Destination_PrimaryContactID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Destination]'))
ALTER TABLE [dbo].[Destination] CHECK CONSTRAINT [Destination_PrimaryContactID_FK]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Destination_SecondaryContactID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Destination]'))
ALTER TABLE [dbo].[Destination]  WITH CHECK ADD  CONSTRAINT [Destination_SecondaryContactID_FK] FOREIGN KEY([SecondaryContactID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Destination_SecondaryContactID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Destination]'))
ALTER TABLE [dbo].[Destination] CHECK CONSTRAINT [Destination_SecondaryContactID_FK]
GO
