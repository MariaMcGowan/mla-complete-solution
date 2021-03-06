USE [MLA]
GO
/****** Object:  Table [dbo].[WeekEndingDate]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[WeekEndingDate]
GO
/****** Object:  Table [dbo].[WeekEndingDate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WeekEndingDate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WeekEndingDate](
	[WeekEndingDateID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NULL,
	[WeekDayNumber] [int] NULL,
	[WeekEndingDate] [date] NULL,
	[WeekNumber] [int] NULL
) ON [PRIMARY]
END
GO
