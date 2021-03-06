USE [MLA]
GO
/****** Object:  Table [csb].[Overview]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [csb].[Overview]
GO
/****** Object:  Table [csb].[Overview]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[Overview]') AND type in (N'U'))
BEGIN
CREATE TABLE [csb].[Overview](
	[OverviewID] [int] NOT NULL,
	[GoLiveDate] [date] NULL,
	[Overview] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OverviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
