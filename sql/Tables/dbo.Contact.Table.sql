USE [MLA]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[Contact]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contact]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Contact](
	[ContactID] [int] IDENTITY(1,1) NOT NULL,
	[Contact] [nvarchar](255) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Email] [varchar](100) NULL,
	[OfficePhone] [varchar](15) NULL,
	[MobilePhone] [varchar](15) NULL,
	[FaxNumber] [varchar](15) NULL,
	[PrimaryMethodOfContact] [varchar](100) NULL,
	[Notes] [varchar](1000) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
	[ContactTypeID] [int] NULL,
	[HomePhone] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
