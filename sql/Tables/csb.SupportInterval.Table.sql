USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[SupportInterval]') AND type in (N'U'))
ALTER TABLE [csb].[SupportInterval] DROP CONSTRAINT IF EXISTS [FK__SupportIn__Defau__4D94879B]
GO
/****** Object:  Table [csb].[SupportInterval]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [csb].[SupportInterval]
GO
/****** Object:  Table [csb].[SupportInterval]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[SupportInterval]') AND type in (N'U'))
BEGIN
CREATE TABLE [csb].[SupportInterval](
	[SupportIntervalID] [int] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[MinuteCount] [int] NOT NULL,
	[DefaultSupportSubIntervalID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SupportIntervalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[csb].[FK__SupportIn__Defau__4D94879B]') AND parent_object_id = OBJECT_ID(N'[csb].[SupportInterval]'))
ALTER TABLE [csb].[SupportInterval]  WITH CHECK ADD FOREIGN KEY([DefaultSupportSubIntervalID])
REFERENCES [csb].[SupportSubInterval] ([SupportSubIntervalID])
GO
