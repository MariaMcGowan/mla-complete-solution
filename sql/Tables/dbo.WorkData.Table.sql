USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkData]') AND type in (N'U'))
ALTER TABLE [dbo].[WorkData] DROP CONSTRAINT IF EXISTS [DF__WorkData__Proces__01A9287E]
GO
/****** Object:  Table [dbo].[WorkData]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[WorkData]
GO
/****** Object:  Table [dbo].[WorkData]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkData]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WorkData](
	[WorkDataID] [int] IDENTITY(1,1) NOT NULL,
	[WorkID] [int] NULL,
	[RowNumber] [int] NULL,
	[SetDate] [date] NULL,
	[DeliveryDate] [date] NULL,
	[CasesInCooler] [numeric](10, 1) NULL,
	[CasesSet] [numeric](10, 1) NULL,
	[MaxGoBackXDays] [int] NULL,
	[OldestEggAge] [int] NULL,
	[CasesOldestEggAge] [numeric](10, 1) NULL,
	[StandardTemplateData] [bit] NULL,
	[Processed] [bit] NULL,
	[CalcSettableEggs] [int] NULL,
	[CalcSettableEggs_Cases] [numeric](10, 1) NULL,
PRIMARY KEY CLUSTERED 
(
	[WorkDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__WorkData__Proces__01A9287E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[WorkData] ADD  DEFAULT ((0)) FOR [Processed]
END

GO
