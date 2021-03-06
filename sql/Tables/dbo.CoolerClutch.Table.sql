USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoolerClutch]') AND type in (N'U'))
ALTER TABLE [dbo].[CoolerClutch] DROP CONSTRAINT IF EXISTS [FK__CoolerClu__Coole__7D2E8C24]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoolerClutch]') AND type in (N'U'))
ALTER TABLE [dbo].[CoolerClutch] DROP CONSTRAINT IF EXISTS [FK__CoolerClu__Clutc__7E22B05D]
GO
/****** Object:  Table [dbo].[CoolerClutch]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[CoolerClutch]
GO
/****** Object:  Table [dbo].[CoolerClutch]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoolerClutch]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CoolerClutch](
	[CoolerClutchID] [int] IDENTITY(1,1) NOT NULL,
	[CoolerID] [int] NULL,
	[ClutchID] [int] NULL,
	[PlannedQty] [int] NULL,
	[ActualQty] [int] NULL,
	[InitialQty] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CoolerClutchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CoolerClu__Clutc__7E22B05D]') AND parent_object_id = OBJECT_ID(N'[dbo].[CoolerClutch]'))
ALTER TABLE [dbo].[CoolerClutch]  WITH CHECK ADD FOREIGN KEY([ClutchID])
REFERENCES [dbo].[Clutch] ([ClutchID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CoolerClu__Coole__7D2E8C24]') AND parent_object_id = OBJECT_ID(N'[dbo].[CoolerClutch]'))
ALTER TABLE [dbo].[CoolerClutch]  WITH CHECK ADD FOREIGN KEY([CoolerID])
REFERENCES [dbo].[Cooler] ([CoolerID])
GO
