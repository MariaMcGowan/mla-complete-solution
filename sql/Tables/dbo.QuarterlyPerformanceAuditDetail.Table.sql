USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAuditDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[QuarterlyPerformanceAuditDetail] DROP CONSTRAINT IF EXISTS [FK__Quarterly__Quart__6F556E19]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAuditDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[QuarterlyPerformanceAuditDetail] DROP CONSTRAINT IF EXISTS [FK__Quarterly__Qtrly__70499252]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAuditDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[QuarterlyPerformanceAuditDetail] DROP CONSTRAINT IF EXISTS [FK__Quarterly__ItemS__713DB68B]
GO
/****** Object:  Table [dbo].[QuarterlyPerformanceAuditDetail]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[QuarterlyPerformanceAuditDetail]
GO
/****** Object:  Table [dbo].[QuarterlyPerformanceAuditDetail]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAuditDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[QuarterlyPerformanceAuditDetail](
	[QuarterlyPerformanceAuditDetailID] [int] IDENTITY(1,1) NOT NULL,
	[QuarterlyPerformanceAuditID] [int] NULL,
	[QtrlyPerformAuditTemplateItemID] [int] NULL,
	[ItemStatusID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[QuarterlyPerformanceAuditDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Quarterly__ItemS__713DB68B]') AND parent_object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAuditDetail]'))
ALTER TABLE [dbo].[QuarterlyPerformanceAuditDetail]  WITH CHECK ADD FOREIGN KEY([ItemStatusID])
REFERENCES [dbo].[ItemStatus] ([ItemStatusID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Quarterly__Qtrly__70499252]') AND parent_object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAuditDetail]'))
ALTER TABLE [dbo].[QuarterlyPerformanceAuditDetail]  WITH CHECK ADD FOREIGN KEY([QtrlyPerformAuditTemplateItemID])
REFERENCES [dbo].[QtrlyPerformAuditTemplateItem] ([QtrlyPerformAuditTemplateItemID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Quarterly__Quart__6F556E19]') AND parent_object_id = OBJECT_ID(N'[dbo].[QuarterlyPerformanceAuditDetail]'))
ALTER TABLE [dbo].[QuarterlyPerformanceAuditDetail]  WITH CHECK ADD FOREIGN KEY([QuarterlyPerformanceAuditID])
REFERENCES [dbo].[QuarterlyPerformanceAudit] ([QuarterlyPerformanceAuditID])
GO
