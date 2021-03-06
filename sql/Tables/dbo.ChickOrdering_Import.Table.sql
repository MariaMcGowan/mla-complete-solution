USE [MLA]
GO
/****** Object:  Table [dbo].[ChickOrdering_Import]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[ChickOrdering_Import]
GO
/****** Object:  Table [dbo].[ChickOrdering_Import]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChickOrdering_Import]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ChickOrdering_Import](
	[FlockNumber] [varchar](100) NULL,
	[PulletFacility] [varchar](100) NULL,
	[Actual Hatch Date] [varchar](100) NULL,
	[Female Breed] [varchar](100) NULL,
	[TARGET FEMALE CHICKS TO ORDER] [varchar](100) NULL,
	[Male Breed] [varchar](100) NULL,
	[TARGET MALE CHICKS TO ORDER] [varchar](100) NULL,
	[TARGET # OF FEMALES AT   16 WEEKS] [varchar](100) NULL,
	[TARGET MALES AT 16 WEEKS] [varchar](100) NULL,
	[TARGET 24 WEEK DATE (Egg Take)] [varchar](100) NULL,
	[Actual 24 WEEK DATE (Egg Take)] [varchar](100) NULL,
	[Production Facility ID] [varchar](100) NULL,
	[Flock Code] [varchar](100) NULL
) ON [PRIMARY]
END
GO
