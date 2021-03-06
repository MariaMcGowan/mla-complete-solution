USE [MLA]
GO
/****** Object:  Table [csb].[WebServerInfo]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [csb].[WebServerInfo]
GO
/****** Object:  Table [csb].[WebServerInfo]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[WebServerInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [csb].[WebServerInfo](
	[WebServerInfoID] [int] IDENTITY(1,1) NOT NULL,
	[WebServerName] [nvarchar](255) NULL,
	[WebServerIpAddress] [nvarchar](20) NULL,
	[WebServerVersion] [nvarchar](50) NULL,
	[WebSiteRootFolder] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[WebServerInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
