USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialCommitmentDetail] DROP CONSTRAINT IF EXISTS [FK__Commercia__EggWe__3DBE1285]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialCommitmentDetail] DROP CONSTRAINT IF EXISTS [FK__Commercia__EggCl__3CC9EE4C]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialCommitmentDetail] DROP CONSTRAINT IF EXISTS [FK__Commercia__Commi__3EB236BE]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialCommitmentDetail] DROP CONSTRAINT IF EXISTS [FK__Commercia__Comme__3BD5CA13]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialCommitmentDetail] DROP CONSTRAINT IF EXISTS [DF__Commercia__Modif__3FA65AF7]
GO
/****** Object:  Table [dbo].[CommercialCommitmentDetail]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[CommercialCommitmentDetail]
GO
/****** Object:  Table [dbo].[CommercialCommitmentDetail]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CommercialCommitmentDetail](
	[CommercialCommitmentDetailID] [int] IDENTITY(1,1) NOT NULL,
	[CommercialCommitmentID] [int] NULL,
	[PulletFarmPlanID] [int] NULL,
	[WeekEndingDate] [date] NULL,
	[CommittedQty] [int] NULL,
	[EggClassificationID] [int] NULL,
	[EggWeightClassificationID] [int] NULL,
	[CommitmentStatusID] [int] NULL,
	[ModifiedAfterCommitment] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CommercialCommitmentDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Commercia__Modif__3FA65AF7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CommercialCommitmentDetail] ADD  DEFAULT ((0)) FOR [ModifiedAfterCommitment]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Commercia__Comme__3BD5CA13]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDetail]'))
ALTER TABLE [dbo].[CommercialCommitmentDetail]  WITH CHECK ADD FOREIGN KEY([CommercialCommitmentID])
REFERENCES [dbo].[CommercialCommitment] ([CommercialCommitmentID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Commercia__Commi__3EB236BE]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDetail]'))
ALTER TABLE [dbo].[CommercialCommitmentDetail]  WITH CHECK ADD FOREIGN KEY([CommitmentStatusID])
REFERENCES [dbo].[CommitmentStatus] ([CommitmentStatusID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Commercia__EggCl__3CC9EE4C]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDetail]'))
ALTER TABLE [dbo].[CommercialCommitmentDetail]  WITH CHECK ADD FOREIGN KEY([EggClassificationID])
REFERENCES [dbo].[EggClassification] ([EggClassificationID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Commercia__EggWe__3DBE1285]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommercialCommitmentDetail]'))
ALTER TABLE [dbo].[CommercialCommitmentDetail]  WITH CHECK ADD FOREIGN KEY([EggWeightClassificationID])
REFERENCES [dbo].[EggWeightClassification] ([EggWeightClassificationID])
GO
