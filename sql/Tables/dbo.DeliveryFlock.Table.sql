USE [MLA]
GO
/****** Object:  Table [dbo].[DeliveryFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[DeliveryFlock]
GO
/****** Object:  Table [dbo].[DeliveryFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryFlock]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeliveryFlock](
	[DeliveryFlockID] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryID] [int] NULL,
	[FlockID] [int] NULL
) ON [PRIMARY]
END
GO
