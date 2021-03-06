USE [MLA]
GO
/****** Object:  Table [dbo].[FarmEmbryoStandardYield]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[FarmEmbryoStandardYield]
GO
/****** Object:  Table [dbo].[FarmEmbryoStandardYield]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FarmEmbryoStandardYield]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FarmEmbryoStandardYield](
	[FarmEmbryoStandardYieldID] [int] IDENTITY(1,1) NOT NULL,
	[FarmID] [int] NULL,
	[WeekNumber] [int] NULL,
	[CumulativeMortalityPercent] [numeric](10, 8) NULL,
	[CumulativeLivabilityPercent] [numeric](11, 8) NULL,
	[LayPercent] [numeric](10, 8) NULL,
	[SettableEggsPercentForWeek] [numeric](10, 8) NULL,
	[FloorEggPercent] [numeric](10, 8) NULL,
	[CaseWeight] [numeric](8, 4) NULL,
	[CandleoutPercent] [numeric](10, 8) NULL
) ON [PRIMARY]
END
GO
