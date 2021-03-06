USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSSamplingScheduleDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[PADLSSamplingScheduleDetail] DROP CONSTRAINT IF EXISTS [FK__PADLSSamp__PADLS__48FABB07]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSSamplingScheduleDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[PADLSSamplingScheduleDetail] DROP CONSTRAINT IF EXISTS [FK__PADLSSamp__PADLS__480696CE]
GO
/****** Object:  Table [dbo].[PADLSSamplingScheduleDetail]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[PADLSSamplingScheduleDetail]
GO
/****** Object:  Table [dbo].[PADLSSamplingScheduleDetail]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSSamplingScheduleDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PADLSSamplingScheduleDetail](
	[PADLSSamplingScheduleDetailID] [int] IDENTITY(1,1) NOT NULL,
	[PADLSSamplingScheduleID] [int] NULL,
	[PADLSTemplateItemID] [int] NULL,
	[DateTargeted] [date] NULL,
	[DateCompleted] [date] NULL,
	[CompletedBy] [varchar](200) NULL,
	[Notes] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[PADLSSamplingScheduleDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PADLSSamp__PADLS__480696CE]') AND parent_object_id = OBJECT_ID(N'[dbo].[PADLSSamplingScheduleDetail]'))
ALTER TABLE [dbo].[PADLSSamplingScheduleDetail]  WITH CHECK ADD FOREIGN KEY([PADLSSamplingScheduleID])
REFERENCES [dbo].[PADLSSamplingSchedule] ([PADLSSamplingScheduleID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PADLSSamp__PADLS__48FABB07]') AND parent_object_id = OBJECT_ID(N'[dbo].[PADLSSamplingScheduleDetail]'))
ALTER TABLE [dbo].[PADLSSamplingScheduleDetail]  WITH CHECK ADD FOREIGN KEY([PADLSTemplateItemID])
REFERENCES [dbo].[PADLSTemplateItem] ([PADLSTemplateItemID])
GO
