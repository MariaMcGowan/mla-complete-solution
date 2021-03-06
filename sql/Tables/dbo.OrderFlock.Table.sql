USE [MLA]
GO
/****** Object:  Table [dbo].[OrderFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[OrderFlock]
GO
/****** Object:  Table [dbo].[OrderFlock]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderFlock]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderFlock](
	[OrderFlockID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[FlockID] [int] NULL,
	[PlannedQty] [int] NULL,
	[ActualQty] [int] NULL,
	[WgtPreConversion] [numeric](10, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderFlockID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
