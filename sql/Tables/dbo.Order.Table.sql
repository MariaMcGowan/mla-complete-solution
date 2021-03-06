USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order]') AND type in (N'U'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT IF EXISTS [FK__Order__LoadPlann__392E6792]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order]') AND type in (N'U'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT IF EXISTS [FK__Order__Destinati__7F80E8EA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order]') AND type in (N'U'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT IF EXISTS [FK__Order__Destinati__7E8CC4B1]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order]') AND type in (N'U'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT IF EXISTS [DF__Order__CustomInc__383A4359]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order]') AND type in (N'U'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT IF EXISTS [DF__Order__Destinati__3429BB53]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[Order]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Order](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderNbr] [varchar](100) NULL,
	[CustomerReferenceNbr] [varchar](100) NULL,
	[CreationDate] [date] NULL,
	[DeliveryDate] [date] NULL,
	[DestinationID] [int] NULL,
	[OrderStatusID] [int] NULL,
	[PlannedSetDate] [date] NULL,
	[DestinationBuildingID] [int] NULL,
	[PlannedQty] [int] NULL,
	[OrderQty] [int] NULL,
	[LotNbr] [varchar](20) NULL,
	[DeliverySpecComments] [varchar](1000) NULL,
	[CustomIncubation] [bit] NULL,
	[LoadPlanningID] [int] NULL,
	[ContractTypeID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Order__Destinati__3429BB53]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Order] ADD  DEFAULT ((1)) FOR [DestinationID]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Order__CustomInc__383A4359]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Order] ADD  DEFAULT ((0)) FOR [CustomIncubation]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Order__Destinati__7E8CC4B1]') AND parent_object_id = OBJECT_ID(N'[dbo].[Order]'))
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([DestinationBuildingID])
REFERENCES [dbo].[DestinationBuilding] ([DestinationBuildingID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Order__Destinati__7F80E8EA]') AND parent_object_id = OBJECT_ID(N'[dbo].[Order]'))
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([DestinationID])
REFERENCES [dbo].[Destination] ([DestinationID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Order__LoadPlann__392E6792]') AND parent_object_id = OBJECT_ID(N'[dbo].[Order]'))
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([LoadPlanningID])
REFERENCES [dbo].[LoadPlanning] ([LoadPlanningID])
GO
