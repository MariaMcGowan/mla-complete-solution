USE [MLA]
GO
/****** Object:  Table [dbo].[OrderInvoice]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[OrderInvoice]
GO
/****** Object:  Table [dbo].[OrderInvoice]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderInvoice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderInvoice](
	[OrderInvoiceID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[InvoiceID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderInvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
