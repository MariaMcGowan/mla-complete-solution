USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitment]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialCommitment] DROP CONSTRAINT IF EXISTS [FK__Commercia__Commi__16A44564]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitment]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialCommitment] DROP CONSTRAINT IF EXISTS [FK__Commercia__Comme__15B0212B]
GO
/****** Object:  Table [dbo].[CommercialCommitment]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[CommercialCommitment]
GO
/****** Object:  Table [dbo].[CommercialCommitment]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CommercialCommitment](
	[CommercialCommitmentID] [int] IDENTITY(1,1) NOT NULL,
	[CommercialMarketID] [int] NULL,
	[CommitmentDateStart] [date] NULL,
	[CommitmentDateEnd] [date] NULL,
	[CommitmentQty] [int] NULL,
	[Notes] [varchar](500) NULL,
	[CommitmentStatusID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CommercialCommitmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Commercia__Comme__15B0212B]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommercialCommitment]'))
ALTER TABLE [dbo].[CommercialCommitment]  WITH CHECK ADD FOREIGN KEY([CommercialMarketID])
REFERENCES [dbo].[CommercialMarket] ([CommercialMarketID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Commercia__Commi__16A44564]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommercialCommitment]'))
ALTER TABLE [dbo].[CommercialCommitment]  WITH CHECK ADD FOREIGN KEY([CommitmentStatusID])
REFERENCES [dbo].[CommitmentStatus] ([CommitmentStatusID])
GO
