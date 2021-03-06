USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFacility]') AND type in (N'U'))
ALTER TABLE [dbo].[PulletFacility] DROP CONSTRAINT IF EXISTS [FK__PulletFac__Secon__4A23E96A]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFacility]') AND type in (N'U'))
ALTER TABLE [dbo].[PulletFacility] DROP CONSTRAINT IF EXISTS [FK__PulletFac__Prima__492FC531]
GO
/****** Object:  Table [dbo].[PulletFacility]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[PulletFacility]
GO
/****** Object:  Table [dbo].[PulletFacility]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFacility]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PulletFacility](
	[PulletFacilityID] [int] IDENTITY(1,1) NOT NULL,
	[PulletFacility] [nvarchar](255) NULL,
	[PrimaryContactID] [int] NULL,
	[SecondaryContactID] [int] NULL,
	[Address1] [varchar](100) NULL,
	[Address2] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](2) NULL,
	[Zip] [varchar](10) NULL,
	[ContractedBy] [varchar](100) NULL,
	[StateID] [varchar](50) NULL,
	[FederalID] [varchar](50) NULL,
	[MailingAddress1] [varchar](100) NULL,
	[MailingAddress2] [varchar](100) NULL,
	[MailingCity] [varchar](100) NULL,
	[MailingState] [varchar](2) NULL,
	[MailingZip] [varchar](10) NULL,
	[GPSCoordinates] [varchar](50) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
	[ShavingAmounts] [varchar](100) NULL,
	[ShavingCompany] [varchar](50) NULL,
	[ShavingComments] [varchar](500) NULL,
	[FacilityOwner] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[PulletFacilityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PulletFac__Prima__492FC531]') AND parent_object_id = OBJECT_ID(N'[dbo].[PulletFacility]'))
ALTER TABLE [dbo].[PulletFacility]  WITH CHECK ADD FOREIGN KEY([PrimaryContactID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PulletFac__Secon__4A23E96A]') AND parent_object_id = OBJECT_ID(N'[dbo].[PulletFacility]'))
ALTER TABLE [dbo].[PulletFacility]  WITH CHECK ADD FOREIGN KEY([SecondaryContactID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
