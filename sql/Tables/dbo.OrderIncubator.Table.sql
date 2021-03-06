USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubator]') AND type in (N'U'))
ALTER TABLE [dbo].[OrderIncubator] DROP CONSTRAINT IF EXISTS [FK__OrderIncu__Order__795DFB40]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubator]') AND type in (N'U'))
ALTER TABLE [dbo].[OrderIncubator] DROP CONSTRAINT IF EXISTS [FK__OrderIncu__Incub__7A521F79]
GO
/****** Object:  Table [dbo].[OrderIncubator]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[OrderIncubator]
GO
/****** Object:  Table [dbo].[OrderIncubator]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubator]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderIncubator](
	[OrderIncubatorID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[IncubatorID] [int] NULL,
	[PlannedQty] [int] NULL,
	[ActualQty] [int] NULL,
	[ProfileNumber] [int] NULL,
	[StartDateTime] [datetime] NULL,
	[ProgramBy] [int] NULL,
	[CheckedByPrimary] [int] NULL,
	[CheckedBySecondary] [int] NULL,
	[SetDate] [date] NULL,
	[CandleDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderIncubatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__OrderIncu__Incub__7A521F79]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderIncubator]'))
ALTER TABLE [dbo].[OrderIncubator]  WITH CHECK ADD FOREIGN KEY([IncubatorID])
REFERENCES [dbo].[Incubator] ([IncubatorID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__OrderIncu__Order__795DFB40]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderIncubator]'))
ALTER TABLE [dbo].[OrderIncubator]  WITH CHECK ADD FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
