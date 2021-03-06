USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPLanning_Detail]') AND type in (N'U'))
ALTER TABLE [dbo].[LoadPLanning_Detail] DROP CONSTRAINT IF EXISTS [LoadPLanning_Detail_FlockID_FK]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPLanning_Detail]') AND type in (N'U'))
ALTER TABLE [dbo].[LoadPLanning_Detail] DROP CONSTRAINT IF EXISTS [FK__LoadPLann__LoadP__4FF1D159]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPLanning_Detail]') AND type in (N'U'))
ALTER TABLE [dbo].[LoadPLanning_Detail] DROP CONSTRAINT IF EXISTS [FK__LoadPLann__Flock__50E5F592]
GO
/****** Object:  Table [dbo].[LoadPLanning_Detail]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[LoadPLanning_Detail]
GO
/****** Object:  Table [dbo].[LoadPLanning_Detail]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPLanning_Detail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LoadPLanning_Detail](
	[LoadPlanning_DetailID] [int] IDENTITY(1,1) NOT NULL,
	[LoadPlanningID] [int] NULL,
	[FlockID] [int] NULL,
	[FlockQty] [int] NULL,
	[LastCandleoutPercent] [numeric](5, 2) NULL,
	[weightPreConversion] [numeric](19, 1) NULL,
	[candlingSortOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LoadPlanning_DetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__LoadPLann__Flock__50E5F592]') AND parent_object_id = OBJECT_ID(N'[dbo].[LoadPLanning_Detail]'))
ALTER TABLE [dbo].[LoadPLanning_Detail]  WITH CHECK ADD FOREIGN KEY([FlockID])
REFERENCES [dbo].[orig_Flock] ([FlockID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__LoadPLann__LoadP__4FF1D159]') AND parent_object_id = OBJECT_ID(N'[dbo].[LoadPLanning_Detail]'))
ALTER TABLE [dbo].[LoadPLanning_Detail]  WITH CHECK ADD FOREIGN KEY([LoadPlanningID])
REFERENCES [dbo].[LoadPlanning] ([LoadPlanningID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[LoadPLanning_Detail_FlockID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[LoadPLanning_Detail]'))
ALTER TABLE [dbo].[LoadPLanning_Detail]  WITH CHECK ADD  CONSTRAINT [LoadPLanning_Detail_FlockID_FK] FOREIGN KEY([FlockID])
REFERENCES [dbo].[PulletFarmPlan] ([PulletFarmPlanID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[LoadPLanning_Detail_FlockID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[LoadPLanning_Detail]'))
ALTER TABLE [dbo].[LoadPLanning_Detail] CHECK CONSTRAINT [LoadPLanning_Detail_FlockID_FK]
GO
