USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplateSection]') AND type in (N'U'))
ALTER TABLE [dbo].[QtrlyPerformAuditTemplateSection] DROP CONSTRAINT IF EXISTS [FK__QtrlyPerf__Qtrly__5F1F0650]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplateSection]') AND type in (N'U'))
ALTER TABLE [dbo].[QtrlyPerformAuditTemplateSection] DROP CONSTRAINT IF EXISTS [DF__QtrlyPerf__IsAct__60132A89]
GO
/****** Object:  Table [dbo].[QtrlyPerformAuditTemplateSection]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[QtrlyPerformAuditTemplateSection]
GO
/****** Object:  Table [dbo].[QtrlyPerformAuditTemplateSection]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplateSection]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[QtrlyPerformAuditTemplateSection](
	[QtrlyPerformAuditTemplateSectionID] [int] IDENTITY(1,1) NOT NULL,
	[QtrlyPerformAuditTemplateID] [int] NULL,
	[SectionText] [varchar](200) NULL,
	[IsActive] [bit] NULL,
	[SortOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[QtrlyPerformAuditTemplateSectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__QtrlyPerf__IsAct__60132A89]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[QtrlyPerformAuditTemplateSection] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__QtrlyPerf__Qtrly__5F1F0650]') AND parent_object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplateSection]'))
ALTER TABLE [dbo].[QtrlyPerformAuditTemplateSection]  WITH CHECK ADD FOREIGN KEY([QtrlyPerformAuditTemplateID])
REFERENCES [dbo].[QtrlyPerformAuditTemplate] ([QtrlyPerformAuditTemplateID])
GO
