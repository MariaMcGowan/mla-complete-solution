USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanComment]') AND type in (N'U'))
ALTER TABLE [dbo].[PulletFarmPlanComment] DROP CONSTRAINT IF EXISTS [FK__PulletFar__Pulle__4D005615]
GO
/****** Object:  Table [dbo].[PulletFarmPlanComment]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[PulletFarmPlanComment]
GO
/****** Object:  Table [dbo].[PulletFarmPlanComment]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanComment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PulletFarmPlanComment](
	[PulletFarmPlanCommentID] [int] IDENTITY(1,1) NOT NULL,
	[PulletFarmPlanID] [int] NULL,
	[UserID] [varchar](100) NULL,
	[UpdatedDateTime] [datetime] NULL,
	[Comment] [varchar](2000) NULL,
	[ScreenName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PulletFarmPlanCommentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PulletFar__Pulle__4D005615]') AND parent_object_id = OBJECT_ID(N'[dbo].[PulletFarmPlanComment]'))
ALTER TABLE [dbo].[PulletFarmPlanComment]  WITH CHECK ADD FOREIGN KEY([PulletFarmPlanID])
REFERENCES [dbo].[PulletFarmPlan] ([PulletFarmPlanID])
GO
