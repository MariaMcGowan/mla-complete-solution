USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderFlockClutch]') AND type in (N'U'))
ALTER TABLE [dbo].[OrderFlockClutch] DROP CONSTRAINT IF EXISTS [FK__OrderFloc__Order__39E294A9]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderFlockClutch]') AND type in (N'U'))
ALTER TABLE [dbo].[OrderFlockClutch] DROP CONSTRAINT IF EXISTS [FK__OrderFloc__Clutc__38EE7070]
GO
/****** Object:  Table [dbo].[OrderFlockClutch]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[OrderFlockClutch]
GO
/****** Object:  Table [dbo].[OrderFlockClutch]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderFlockClutch]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderFlockClutch](
	[OrderFlockClutchID] [int] IDENTITY(1,1) NOT NULL,
	[OrderFlockID] [int] NULL,
	[ClutchID] [int] NULL,
	[PlannedQty] [int] NULL,
	[ActualQty] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderFlockClutchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__OrderFloc__Clutc__38EE7070]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderFlockClutch]'))
ALTER TABLE [dbo].[OrderFlockClutch]  WITH CHECK ADD FOREIGN KEY([ClutchID])
REFERENCES [dbo].[Clutch] ([ClutchID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__OrderFloc__Order__39E294A9]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderFlockClutch]'))
ALTER TABLE [dbo].[OrderFlockClutch]  WITH CHECK ADD FOREIGN KEY([OrderFlockID])
REFERENCES [dbo].[OrderFlock] ([OrderFlockID])
GO
