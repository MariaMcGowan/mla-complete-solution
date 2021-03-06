USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubatorCart]') AND type in (N'U'))
ALTER TABLE [dbo].[OrderIncubatorCart] DROP CONSTRAINT IF EXISTS [FK__OrderIncu__Order__00FF1D08]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubatorCart]') AND type in (N'U'))
ALTER TABLE [dbo].[OrderIncubatorCart] DROP CONSTRAINT IF EXISTS [FK__OrderIncu__Incub__01F34141]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubatorCart]') AND type in (N'U'))
ALTER TABLE [dbo].[OrderIncubatorCart] DROP CONSTRAINT IF EXISTS [FK__OrderIncu__Clutc__02E7657A]
GO
/****** Object:  Table [dbo].[OrderIncubatorCart]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[OrderIncubatorCart]
GO
/****** Object:  Table [dbo].[OrderIncubatorCart]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubatorCart]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderIncubatorCart](
	[OrderIncubatorCartID] [int] IDENTITY(1,1) NOT NULL,
	[OrderIncubatorID] [int] NULL,
	[IncubatorCartID] [int] NULL,
	[PlannedQty] [int] NULL,
	[ActualQty] [int] NULL,
	[ClutchID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderIncubatorCartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__OrderIncu__Clutc__02E7657A]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderIncubatorCart]'))
ALTER TABLE [dbo].[OrderIncubatorCart]  WITH CHECK ADD FOREIGN KEY([ClutchID])
REFERENCES [dbo].[Clutch] ([ClutchID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__OrderIncu__Incub__01F34141]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderIncubatorCart]'))
ALTER TABLE [dbo].[OrderIncubatorCart]  WITH CHECK ADD FOREIGN KEY([IncubatorCartID])
REFERENCES [dbo].[IncubatorCart] ([IncubatorCartID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__OrderIncu__Order__00FF1D08]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderIncubatorCart]'))
ALTER TABLE [dbo].[OrderIncubatorCart]  WITH CHECK ADD FOREIGN KEY([OrderIncubatorID])
REFERENCES [dbo].[OrderIncubator] ([OrderIncubatorID])
GO
