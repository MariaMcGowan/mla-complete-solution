USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommitmentStatus]') AND type in (N'U'))
ALTER TABLE [dbo].[CommitmentStatus] DROP CONSTRAINT IF EXISTS [DF__Commitmen__IsAct__12D3B480]
GO
/****** Object:  Table [dbo].[CommitmentStatus]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[CommitmentStatus]
GO
/****** Object:  Table [dbo].[CommitmentStatus]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommitmentStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CommitmentStatus](
	[CommitmentStatusID] [int] IDENTITY(1,1) NOT NULL,
	[CommitmentStatus] [varchar](50) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CommitmentStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Commitmen__IsAct__12D3B480]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CommitmentStatus] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
