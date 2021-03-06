USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SystemConstant]') AND type in (N'U'))
ALTER TABLE [dbo].[SystemConstant] DROP CONSTRAINT IF EXISTS [DF__SystemCon__IsAct__04859529]
GO
/****** Object:  Table [dbo].[SystemConstant]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[SystemConstant]
GO
/****** Object:  Table [dbo].[SystemConstant]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SystemConstant]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SystemConstant](
	[SystemConstantID] [int] IDENTITY(1,1) NOT NULL,
	[ConstantName] [varchar](100) NULL,
	[ConstantValue] [numeric](16, 6) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[SystemConstantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__SystemCon__IsAct__04859529]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SystemConstant] ADD  DEFAULT ((0)) FOR [IsActive]
END

GO
