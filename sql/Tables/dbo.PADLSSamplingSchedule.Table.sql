USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSSamplingSchedule]') AND type in (N'U'))
ALTER TABLE [dbo].[PADLSSamplingSchedule] DROP CONSTRAINT IF EXISTS [FK__PADLSSamp__PADLS__0268428D]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSSamplingSchedule]') AND type in (N'U'))
ALTER TABLE [dbo].[PADLSSamplingSchedule] DROP CONSTRAINT IF EXISTS [FK__PADLSSamp__Flock__035C66C6]
GO
/****** Object:  Table [dbo].[PADLSSamplingSchedule]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[PADLSSamplingSchedule]
GO
/****** Object:  Table [dbo].[PADLSSamplingSchedule]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSSamplingSchedule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PADLSSamplingSchedule](
	[PADLSSamplingScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[PADLSSamplingSchedule] [varchar](100) NULL,
	[PADLSTemplateID] [int] NULL,
	[FlockID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PADLSSamplingScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PADLSSamp__Flock__035C66C6]') AND parent_object_id = OBJECT_ID(N'[dbo].[PADLSSamplingSchedule]'))
ALTER TABLE [dbo].[PADLSSamplingSchedule]  WITH CHECK ADD FOREIGN KEY([FlockID])
REFERENCES [dbo].[PulletFarmPlan] ([PulletFarmPlanID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PADLSSamp__PADLS__0268428D]') AND parent_object_id = OBJECT_ID(N'[dbo].[PADLSSamplingSchedule]'))
ALTER TABLE [dbo].[PADLSSamplingSchedule]  WITH CHECK ADD FOREIGN KEY([PADLSTemplateID])
REFERENCES [dbo].[PADLSTemplate] ([PADLSTemplateID])
GO
