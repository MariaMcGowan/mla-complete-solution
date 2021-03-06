USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContractType]') AND type in (N'U'))
ALTER TABLE [dbo].[ContractType] DROP CONSTRAINT IF EXISTS [DF__ContractT__IsAct__1980B20F]
GO
/****** Object:  Table [dbo].[ContractType]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[ContractType]
GO
/****** Object:  Table [dbo].[ContractType]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContractType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ContractType](
	[ContractTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ContractType] [varchar](100) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ContractTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ContractT__IsAct__1980B20F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ContractType] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
