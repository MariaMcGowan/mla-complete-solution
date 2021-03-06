USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Clutch]') AND type in (N'U'))
ALTER TABLE [dbo].[Clutch] DROP CONSTRAINT IF EXISTS [Clutch_FlockID_FK]
GO
/****** Object:  Table [dbo].[Clutch]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[Clutch]
GO
/****** Object:  Table [dbo].[Clutch]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Clutch]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Clutch](
	[ClutchID] [int] IDENTITY(1,1) NOT NULL,
	[Clutch] [nvarchar](255) NULL,
	[FlockID] [int] NULL,
	[LayDate] [date] NULL,
	[RackCnt] [decimal](15, 10) NULL,
	[CaseCnt] [decimal](15, 10) NULL,
	[PlannedQty] [int] NULL,
	[ActualQty] [int] NULL,
	[CalculatedQty] [int] NULL,
	[WgtPerDozen] [decimal](6, 3) NULL,
	[ReasoningForPlannedQty] [varchar](1000) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClutchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Clutch_FlockID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Clutch]'))
ALTER TABLE [dbo].[Clutch]  WITH CHECK ADD  CONSTRAINT [Clutch_FlockID_FK] FOREIGN KEY([FlockID])
REFERENCES [dbo].[PulletFarmPlan] ([PulletFarmPlanID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Clutch_FlockID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Clutch]'))
ALTER TABLE [dbo].[Clutch] CHECK CONSTRAINT [Clutch_FlockID_FK]
GO
