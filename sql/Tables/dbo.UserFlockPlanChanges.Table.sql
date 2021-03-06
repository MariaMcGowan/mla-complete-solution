USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserFlockPlanChanges]') AND type in (N'U'))
ALTER TABLE [dbo].[UserFlockPlanChanges] DROP CONSTRAINT IF EXISTS [FK__UserFlock__UserI__53AD53A4]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserFlockPlanChanges]') AND type in (N'U'))
ALTER TABLE [dbo].[UserFlockPlanChanges] DROP CONSTRAINT IF EXISTS [DF__UserFlock__Chang__54A177DD]
GO
/****** Object:  Table [dbo].[UserFlockPlanChanges]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[UserFlockPlanChanges]
GO
/****** Object:  Table [dbo].[UserFlockPlanChanges]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserFlockPlanChanges]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserFlockPlanChanges](
	[UserFlockPlanChangesID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [varchar](255) NULL,
	[PulletFarmPlanID] [int] NULL,
	[FarmID] [int] NULL,
	[Planned24WeekDate] [date] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[PulletQtyAt16Weeks] [int] NULL,
	[ActualHatchDate] [date] NULL,
	[PlannedHatchDate] [date] NULL,
	[PulletFacility_RemoveDate] [date] NULL,
	[PulletFacility_WashDownDate] [date] NULL,
	[PulletFacility_LitterDate] [date] NULL,
	[PulletFacility_FumigationDate] [date] NULL,
	[ProductionFarm_RemoveDate] [date] NULL,
	[ProductionFarm_WashDownDate] [date] NULL,
	[ProductionFarm_LitterDate] [date] NULL,
	[ProductionFarm_FumigationDate] [date] NULL,
	[UserMessage] [varchar](500) NULL,
	[ValidationReturnCode] [int] NULL,
	[ChangeApplied] [bit] NULL,
	[ContractTypeID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserFlockPlanChangesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__UserFlock__Chang__54A177DD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserFlockPlanChanges] ADD  DEFAULT ((0)) FOR [ChangeApplied]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__UserFlock__UserI__53AD53A4]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserFlockPlanChanges]'))
ALTER TABLE [dbo].[UserFlockPlanChanges]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [csb].[UserTable] ([UserID])
GO
