USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplateItem]') AND type in (N'U'))
ALTER TABLE [dbo].[QtrlyPerformAuditTemplateItem] DROP CONSTRAINT IF EXISTS [FK__QtrlyPerf__Qtrly__62EF9734]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplateItem]') AND type in (N'U'))
ALTER TABLE [dbo].[QtrlyPerformAuditTemplateItem] DROP CONSTRAINT IF EXISTS [DF__QtrlyPerf__IsAct__63E3BB6D]
GO
/****** Object:  Table [dbo].[QtrlyPerformAuditTemplateItem]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[QtrlyPerformAuditTemplateItem]
GO
/****** Object:  Table [dbo].[QtrlyPerformAuditTemplateItem]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplateItem]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[QtrlyPerformAuditTemplateItem](
	[QtrlyPerformAuditTemplateItemID] [int] IDENTITY(1,1) NOT NULL,
	[QtrlyPerformAuditTemplateSectionID] [int] NULL,
	[ItemText] [varchar](200) NULL,
	[IsActive] [bit] NULL,
	[SortOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[QtrlyPerformAuditTemplateItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__QtrlyPerf__IsAct__63E3BB6D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[QtrlyPerformAuditTemplateItem] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__QtrlyPerf__Qtrly__62EF9734]') AND parent_object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplateItem]'))
ALTER TABLE [dbo].[QtrlyPerformAuditTemplateItem]  WITH CHECK ADD FOREIGN KEY([QtrlyPerformAuditTemplateSectionID])
REFERENCES [dbo].[QtrlyPerformAuditTemplateSection] ([QtrlyPerformAuditTemplateSectionID])
GO
