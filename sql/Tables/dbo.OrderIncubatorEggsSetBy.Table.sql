USE [MLA]
GO
/****** Object:  Table [dbo].[OrderIncubatorEggsSetBy]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[OrderIncubatorEggsSetBy]
GO
/****** Object:  Table [dbo].[OrderIncubatorEggsSetBy]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubatorEggsSetBy]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderIncubatorEggsSetBy](
	[OrderIncubatorEggsSetByID] [int] IDENTITY(1,1) NOT NULL,
	[OrderIncubatorID] [int] NULL,
	[ContactID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderIncubatorEggsSetByID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
