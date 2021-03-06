USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAudit]') AND type in (N'U'))
ALTER TABLE [dbo].[QuarterlyPerformanceAudit] DROP CONSTRAINT IF EXISTS [FK__Quarterly__Qtrly__6C79016E]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAudit]') AND type in (N'U'))
ALTER TABLE [dbo].[QuarterlyPerformanceAudit] DROP CONSTRAINT IF EXISTS [FK__Quarterly__Flock__6B84DD35]
GO
/****** Object:  Table [dbo].[QuarterlyPerformanceAudit]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[QuarterlyPerformanceAudit]
GO
/****** Object:  Table [dbo].[QuarterlyPerformanceAudit]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAudit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[QuarterlyPerformanceAudit](
	[QuarterlyPerformanceAuditID] [int] IDENTITY(1,1) NOT NULL,
	[QuarterlyPerformanceAudit] [varchar](100) NULL,
	[FlockID] [int] NULL,
	[QtrlyPerformAuditTemplateID] [int] NULL,
	[Comments] [varchar](1000) NULL,
	[AuditStatusID] [int] NULL,
	[InspectedBy] [varchar](200) NULL,
	[DateCreated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[QuarterlyPerformanceAuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Quarterly__Flock__6B84DD35]') AND parent_object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAudit]'))
ALTER TABLE [dbo].[QuarterlyPerformanceAudit]  WITH CHECK ADD FOREIGN KEY([FlockID])
REFERENCES [dbo].[PulletFarmPlan] ([PulletFarmPlanID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Quarterly__Qtrly__6C79016E]') AND parent_object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAudit]'))
ALTER TABLE [dbo].[QuarterlyPerformanceAudit]  WITH CHECK ADD FOREIGN KEY([QtrlyPerformAuditTemplateID])
REFERENCES [dbo].[QtrlyPerformAuditTemplate] ([QtrlyPerformAuditTemplateID])
GO
