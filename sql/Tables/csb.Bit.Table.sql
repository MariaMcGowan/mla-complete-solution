USE [MLA]
GO
/****** Object:  Table [csb].[Bit]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [csb].[Bit]
GO
/****** Object:  Table [csb].[Bit]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[Bit]') AND type in (N'U'))
BEGIN
CREATE TABLE [csb].[Bit](
	[Bit] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Bit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
