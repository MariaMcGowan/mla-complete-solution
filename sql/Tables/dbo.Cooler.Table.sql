USE [MLA]
GO
/****** Object:  Table [dbo].[Cooler]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[Cooler]
GO
/****** Object:  Table [dbo].[Cooler]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cooler]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Cooler](
	[CoolerID] [int] IDENTITY(1,1) NOT NULL,
	[Cooler] [varchar](255) NULL,
	[CartCapacity] [int] NULL,
	[Notes] [varchar](1000) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CoolerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
