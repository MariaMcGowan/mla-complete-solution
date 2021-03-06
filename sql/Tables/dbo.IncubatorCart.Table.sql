USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorCart]') AND type in (N'U'))
ALTER TABLE [dbo].[IncubatorCart] DROP CONSTRAINT IF EXISTS [FK__Incubator__Incub__2C538F61]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorCart]') AND type in (N'U'))
ALTER TABLE [dbo].[IncubatorCart] DROP CONSTRAINT IF EXISTS [FK__Incubator__Coole__2B5F6B28]
GO
/****** Object:  Table [dbo].[IncubatorCart]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[IncubatorCart]
GO
/****** Object:  Table [dbo].[IncubatorCart]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorCart]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IncubatorCart](
	[IncubatorCartID] [int] IDENTITY(1,1) NOT NULL,
	[IncubatorCart] [varchar](255) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
	[CartNumber] [varchar](25) NULL,
	[IncubatorLocationNumber] [int] NULL,
	[CoolerID] [int] NULL,
	[IncubatorID] [int] NULL,
	[LoadDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IncubatorCartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Incubator__Coole__2B5F6B28]') AND parent_object_id = OBJECT_ID(N'[dbo].[IncubatorCart]'))
ALTER TABLE [dbo].[IncubatorCart]  WITH CHECK ADD FOREIGN KEY([CoolerID])
REFERENCES [dbo].[Cooler] ([CoolerID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Incubator__Incub__2C538F61]') AND parent_object_id = OBJECT_ID(N'[dbo].[IncubatorCart]'))
ALTER TABLE [dbo].[IncubatorCart]  WITH CHECK ADD FOREIGN KEY([IncubatorID])
REFERENCES [dbo].[Incubator] ([IncubatorID])
GO
