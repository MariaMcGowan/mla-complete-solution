USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProjectedOrder]') AND type in (N'U'))
ALTER TABLE [dbo].[ProjectedOrder] DROP CONSTRAINT IF EXISTS [FK__Projected__Desti__4341E1B1]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProjectedOrder]') AND type in (N'U'))
ALTER TABLE [dbo].[ProjectedOrder] DROP CONSTRAINT IF EXISTS [FK__Projected__Desti__424DBD78]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProjectedOrder]') AND type in (N'U'))
ALTER TABLE [dbo].[ProjectedOrder] DROP CONSTRAINT IF EXISTS [FK__Projected__Contr__443605EA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProjectedOrder]') AND type in (N'U'))
ALTER TABLE [dbo].[ProjectedOrder] DROP CONSTRAINT IF EXISTS [DF__Projected__Custo__452A2A23]
GO
/****** Object:  Table [dbo].[ProjectedOrder]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[ProjectedOrder]
GO
/****** Object:  Table [dbo].[ProjectedOrder]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProjectedOrder]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProjectedOrder](
	[ProjectedOrderID] [int] IDENTITY(1,1) NOT NULL,
	[DestinationID] [int] NULL,
	[DestinationBuildingID] [int] NULL,
	[ContractTypeID] [int] NULL,
	[SetDate] [date] NULL,
	[DeliveryDate] [date] NULL,
	[Qty] [int] NULL,
	[CustomIncubation] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProjectedOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Projected__Custo__452A2A23]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProjectedOrder] ADD  DEFAULT ((0)) FOR [CustomIncubation]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Projected__Contr__443605EA]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProjectedOrder]'))
ALTER TABLE [dbo].[ProjectedOrder]  WITH CHECK ADD FOREIGN KEY([ContractTypeID])
REFERENCES [dbo].[ContractType] ([ContractTypeID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Projected__Desti__424DBD78]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProjectedOrder]'))
ALTER TABLE [dbo].[ProjectedOrder]  WITH CHECK ADD FOREIGN KEY([DestinationID])
REFERENCES [dbo].[Destination] ([DestinationID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Projected__Desti__4341E1B1]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProjectedOrder]'))
ALTER TABLE [dbo].[ProjectedOrder]  WITH CHECK ADD FOREIGN KEY([DestinationBuildingID])
REFERENCES [dbo].[DestinationBuilding] ([DestinationBuildingID])
GO
