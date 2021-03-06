USE [MLA]
GO
/****** Object:  UserDefinedTableType [dbo].[EggAgeParams]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TYPE IF EXISTS [dbo].[EggAgeParams]
GO
/****** Object:  UserDefinedTableType [dbo].[EggAgeParams]    Script Date: 3/9/2020 7:27:09 PM ******/
IF NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'EggAgeParams' AND ss.name = N'dbo')
CREATE TYPE [dbo].[EggAgeParams] AS TABLE(
	[RowNumber] [int] NOT NULL,
	[SetDate] [date] NULL,
	[CasesSet] [numeric](6, 2) NULL,
	[CasesInCooler] [numeric](10, 1) NULL,
	PRIMARY KEY CLUSTERED 
(
	[RowNumber] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
