USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[PerformanceLog]') AND type in (N'U'))
ALTER TABLE [csb].[PerformanceLog] DROP CONSTRAINT IF EXISTS [FK__Performan__Perfo__49C3F6B7]
GO
/****** Object:  Table [csb].[PerformanceLog]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [csb].[PerformanceLog]
GO
/****** Object:  Table [csb].[PerformanceLog]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[PerformanceLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [csb].[PerformanceLog](
	[PerformanceLogID] [int] IDENTITY(1,1) NOT NULL,
	[LogDateTime] [datetime2](7) NOT NULL,
	[UserID] [int] NULL,
	[PagePartID] [int] NULL,
	[PerformanceLogEntryTypeID] [int] NOT NULL,
	[Milliseconds] [int] NULL,
	[Source] [varchar](255) NULL,
	[SourceDetail] [varchar](510) NULL,
PRIMARY KEY CLUSTERED 
(
	[PerformanceLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[csb].[FK__Performan__Perfo__49C3F6B7]') AND parent_object_id = OBJECT_ID(N'[csb].[PerformanceLog]'))
ALTER TABLE [csb].[PerformanceLog]  WITH CHECK ADD FOREIGN KEY([PerformanceLogEntryTypeID])
REFERENCES [csb].[PerformanceLogEntryType] ([PerformanceLogEntryTypeID])
GO
