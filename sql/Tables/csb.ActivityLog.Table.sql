USE [MLA]
GO
/****** Object:  Table [csb].[ActivityLog]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [csb].[ActivityLog]
GO
/****** Object:  Table [csb].[ActivityLog]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[ActivityLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [csb].[ActivityLog](
	[ActivityLogID] [int] IDENTITY(1,1) NOT NULL,
	[LogDateTime] [datetime2](7) NOT NULL,
	[UserID] [int] NULL,
	[PagePartID] [int] NULL,
	[IsPost] [bit] NULL,
	[IpAddress] [varchar](39) NULL,
	[Url] [varchar](255) NULL,
	[UserAgent] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ActivityLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
