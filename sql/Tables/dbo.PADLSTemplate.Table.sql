USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplate]') AND type in (N'U'))
ALTER TABLE [dbo].[PADLSTemplate] DROP CONSTRAINT IF EXISTS [DF__PADLSTemp__IsAct__741A2336]
GO
/****** Object:  Table [dbo].[PADLSTemplate]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[PADLSTemplate]
GO
/****** Object:  Table [dbo].[PADLSTemplate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSTemplate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PADLSTemplate](
	[PADLSTemplateID] [int] IDENTITY(1,1) NOT NULL,
	[PADLSTemplateDescr] [varchar](200) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PADLSTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PADLSTemp__IsAct__741A2336]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PADLSTemplate] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
