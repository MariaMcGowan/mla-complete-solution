USE [MLA]
GO
/****** Object:  Table [dbo].[EggUnitPrice]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[EggUnitPrice]
GO
/****** Object:  Table [dbo].[EggUnitPrice]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggUnitPrice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EggUnitPrice](
	[UnitPriceID] [int] IDENTITY(1,1) NOT NULL,
	[UnitPrice] [numeric](19, 10) NULL,
	[MinEggCount] [int] NULL,
	[MaxEggCount] [int] NULL,
	[FromDate] [date] NULL,
	[ToDate] [date] NULL,
	[UpdatedByID] [int] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[UnitPriceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
