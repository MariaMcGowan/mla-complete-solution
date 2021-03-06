USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPlanningFarmList]') AND type in (N'U'))
ALTER TABLE [dbo].[UserPlanningFarmList] DROP CONSTRAINT IF EXISTS [FK__UserPlann__UserI__4DBF7024]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPlanningFarmList]') AND type in (N'U'))
ALTER TABLE [dbo].[UserPlanningFarmList] DROP CONSTRAINT IF EXISTS [FK__UserPlann__FarmI__4FA7B896]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPlanningFarmList]') AND type in (N'U'))
ALTER TABLE [dbo].[UserPlanningFarmList] DROP CONSTRAINT IF EXISTS [FK__UserPlann__Contr__4EB3945D]
GO
/****** Object:  Table [dbo].[UserPlanningFarmList]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[UserPlanningFarmList]
GO
/****** Object:  Table [dbo].[UserPlanningFarmList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPlanningFarmList]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserPlanningFarmList](
	[UserPlanningFarmListID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [varchar](255) NULL,
	[ContractTypeID] [int] NULL,
	[FarmID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserPlanningFarmListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__UserPlann__Contr__4EB3945D]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserPlanningFarmList]'))
ALTER TABLE [dbo].[UserPlanningFarmList]  WITH CHECK ADD FOREIGN KEY([ContractTypeID])
REFERENCES [dbo].[ContractType] ([ContractTypeID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__UserPlann__FarmI__4FA7B896]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserPlanningFarmList]'))
ALTER TABLE [dbo].[UserPlanningFarmList]  WITH CHECK ADD FOREIGN KEY([FarmID])
REFERENCES [dbo].[Farm] ([FarmID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__UserPlann__UserI__4DBF7024]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserPlanningFarmList]'))
ALTER TABLE [dbo].[UserPlanningFarmList]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [csb].[UserTable] ([UserID])
GO
