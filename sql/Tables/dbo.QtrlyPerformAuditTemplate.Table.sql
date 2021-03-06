USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplate]') AND type in (N'U'))
ALTER TABLE [dbo].[QtrlyPerformAuditTemplate] DROP CONSTRAINT IF EXISTS [DF__QtrlyPerf__IsAct__5C4299A5]
GO
/****** Object:  Table [dbo].[QtrlyPerformAuditTemplate]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[QtrlyPerformAuditTemplate]
GO
/****** Object:  Table [dbo].[QtrlyPerformAuditTemplate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QtrlyPerformAuditTemplate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[QtrlyPerformAuditTemplate](
	[QtrlyPerformAuditTemplateID] [int] IDENTITY(1,1) NOT NULL,
	[QtrlyPerformAuditTemplateDescr] [varchar](200) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[QtrlyPerformAuditTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__QtrlyPerf__IsAct__5C4299A5]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[QtrlyPerformAuditTemplate] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
