USE [MLA]
GO
/****** Object:  Table [dbo].[HoldingIncubator]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[HoldingIncubator]
GO
/****** Object:  Table [dbo].[HoldingIncubator]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldingIncubator]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HoldingIncubator](
	[HoldingIncubatorID] [int] IDENTITY(1,1) NOT NULL,
	[HoldingIncubator] [varchar](255) NULL,
	[CartCapacity] [int] NULL,
	[Notes] [varchar](1000) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
	[TopLeftLocationNbr] [int] NULL,
	[Row_Count] [int] NULL,
	[Column_Count] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[HoldingIncubatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
