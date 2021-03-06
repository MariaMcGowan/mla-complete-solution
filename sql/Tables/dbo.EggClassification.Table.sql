USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggClassification]') AND type in (N'U'))
ALTER TABLE [dbo].[EggClassification] DROP CONSTRAINT IF EXISTS [DF__EggClassi__IsAct__38F95D68]
GO
/****** Object:  Table [dbo].[EggClassification]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[EggClassification]
GO
/****** Object:  Table [dbo].[EggClassification]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggClassification]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EggClassification](
	[EggClassificationID] [int] IDENTITY(1,1) NOT NULL,
	[EggClassification] [varchar](100) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[EggClassificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EggClassi__IsAct__38F95D68]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EggClassification] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
