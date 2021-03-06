USE [MLA]
GO
/****** Object:  Table [csb].[ExceptionLog]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [csb].[ExceptionLog]
GO
/****** Object:  Table [csb].[ExceptionLog]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[ExceptionLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [csb].[ExceptionLog](
	[ExceptionLogID] [int] IDENTITY(1,1) NOT NULL,
	[LogDateTime] [datetime2](7) NOT NULL,
	[UserID] [int] NULL,
	[PagePartID] [int] NULL,
	[Method] [varchar](20) NULL,
	[Url] [varchar](510) NULL,
	[ExceptionSummary] [varchar](510) NULL,
	[ExceptionDetails] [varchar](max) NULL,
	[FormVariables] [varchar](max) NULL,
	[ServerVariables] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ExceptionLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
