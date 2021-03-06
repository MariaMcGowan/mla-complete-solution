USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[SolutionSchema]') AND type in (N'U'))
ALTER TABLE [csb].[SolutionSchema] DROP CONSTRAINT IF EXISTS [DF__SolutionS__NameF__3A81B327]
GO
/****** Object:  Table [csb].[SolutionSchema]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [csb].[SolutionSchema]
GO
/****** Object:  Table [csb].[SolutionSchema]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[SolutionSchema]') AND type in (N'U'))
BEGIN
CREATE TABLE [csb].[SolutionSchema](
	[SchemaName] [varchar](5) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[DisplaySequence] [int] NOT NULL,
	[NameFilter] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SchemaName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[DF__SolutionS__NameF__3A81B327]') AND type = 'D')
BEGIN
ALTER TABLE [csb].[SolutionSchema] ADD  DEFAULT ('%') FOR [NameFilter]
END

GO
