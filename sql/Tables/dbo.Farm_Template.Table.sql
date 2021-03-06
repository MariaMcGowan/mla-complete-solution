USE [MLA]
GO
/****** Object:  Table [dbo].[Farm_Template]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[Farm_Template]
GO
/****** Object:  Table [dbo].[Farm_Template]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Farm_Template]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Farm_Template](
	[FarmName] [varchar](100) NULL,
	[PrimaryContact ] [varchar](100) NULL,
	[SecondaryContact] [varchar](100) NULL,
	[Address1] [varchar](100) NULL,
	[Address2] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](100) NULL,
	[Zip] [varchar](100) NULL,
	[HomePhone] [varchar](100) NULL,
	[Cell] [varchar](100) NULL,
	[Fax] [varchar](100) NULL,
	[OtherPhone] [varchar](100) NULL,
	[Email] [varchar](100) NULL,
	[SortOrder] [varchar](100) NULL,
	[IsActive] [varchar](100) NULL,
	[FarmNumber] [varchar](100) NULL,
	[MLA_MainProperty] [varchar](100) NULL,
	[Contract_MLAOwnsBirds] [varchar](100) NULL,
	[Contract] [varchar](100) NULL,
	[BirdsOwnedBy] [varchar](100) NULL
) ON [PRIMARY]
END
GO
