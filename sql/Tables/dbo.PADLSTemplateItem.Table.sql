USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem]') AND type in (N'U'))
ALTER TABLE [dbo].[PADLSTemplateItem] DROP CONSTRAINT IF EXISTS [FK__PADLSTemp__PADLS__7DA38D70]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem]') AND type in (N'U'))
ALTER TABLE [dbo].[PADLSTemplateItem] DROP CONSTRAINT IF EXISTS [FK__PADLSTemp__PADLS__7CAF6937]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem]') AND type in (N'U'))
ALTER TABLE [dbo].[PADLSTemplateItem] DROP CONSTRAINT IF EXISTS [FK__PADLSTemp__PADLS__0915401C]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem]') AND type in (N'U'))
ALTER TABLE [dbo].[PADLSTemplateItem] DROP CONSTRAINT IF EXISTS [FK__PADLSTemp__PADLS__08211BE3]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem]') AND type in (N'U'))
ALTER TABLE [dbo].[PADLSTemplateItem] DROP CONSTRAINT IF EXISTS [DF__PADLSTemp__IsAct__7F8BD5E2]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem]') AND type in (N'U'))
ALTER TABLE [dbo].[PADLSTemplateItem] DROP CONSTRAINT IF EXISTS [DF__PADLSTemp__OmitD__7E97B1A9]
GO
/****** Object:  Table [dbo].[PADLSTemplateItem]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[PADLSTemplateItem]
GO
/****** Object:  Table [dbo].[PADLSTemplateItem]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PADLSTemplateItem](
	[PADLSTemplateItemID] [int] IDENTITY(1,1) NOT NULL,
	[PADLSTemplateID] [int] NULL,
	[PADLSTemplateTaskListID] [int] NULL,
	[ItemText] [varchar](200) NULL,
	[AgeInDays] [int] NULL,
	[OmitDateTargetedFromReport] [bit] NULL,
	[IsActive] [bit] NULL,
	[SortOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PADLSTemplateItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PADLSTemp__OmitD__7E97B1A9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PADLSTemplateItem] ADD  DEFAULT ((0)) FOR [OmitDateTargetedFromReport]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PADLSTemp__IsAct__7F8BD5E2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PADLSTemplateItem] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PADLSTemp__PADLS__08211BE3]') AND parent_object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem]'))
ALTER TABLE [dbo].[PADLSTemplateItem]  WITH CHECK ADD FOREIGN KEY([PADLSTemplateID])
REFERENCES [dbo].[PADLSTemplate] ([PADLSTemplateID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PADLSTemp__PADLS__0915401C]') AND parent_object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem]'))
ALTER TABLE [dbo].[PADLSTemplateItem]  WITH CHECK ADD FOREIGN KEY([PADLSTemplateTaskListID])
REFERENCES [dbo].[PADLSTemplateTaskList] ([PADLSTemplateTaskListID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PADLSTemp__PADLS__7CAF6937]') AND parent_object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem]'))
ALTER TABLE [dbo].[PADLSTemplateItem]  WITH CHECK ADD FOREIGN KEY([PADLSTemplateID])
REFERENCES [dbo].[PADLSTemplate] ([PADLSTemplateID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PADLSTemp__PADLS__7DA38D70]') AND parent_object_id = OBJECT_ID(N'[dbo].[PADLSTemplateItem]'))
ALTER TABLE [dbo].[PADLSTemplateItem]  WITH CHECK ADD FOREIGN KEY([PADLSTemplateTaskListID])
REFERENCES [dbo].[PADLSTemplateTaskList] ([PADLSTemplateTaskListID])
GO
