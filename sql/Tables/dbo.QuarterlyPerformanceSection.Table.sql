USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceSection]') AND type in (N'U'))
ALTER TABLE [dbo].[QuarterlyPerformanceSection] DROP CONSTRAINT IF EXISTS [DF__Quarterly__IsAct__4AE30379]
GO
/****** Object:  Table [dbo].[QuarterlyPerformanceSection]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[QuarterlyPerformanceSection]
GO
/****** Object:  Table [dbo].[QuarterlyPerformanceSection]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceSection]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[QuarterlyPerformanceSection](
	[QuarterlyPerformanceAuditSectionID] [int] IDENTITY(1,1) NOT NULL,
	[SectionDesc] [varchar](200) NULL,
	[IsActive] [bit] NULL,
	[SortOrder] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Quarterly__IsAct__4AE30379]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[QuarterlyPerformanceSection] ADD  DEFAULT ((0)) FOR [IsActive]
END

GO
