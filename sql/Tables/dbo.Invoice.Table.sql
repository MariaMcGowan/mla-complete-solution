USE [MLA]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[Invoice]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Invoice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Invoice](
	[InvoiceID] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceNbr] [varchar](20) NULL,
	[InvoiceDate] [date] NULL,
	[CreatedDate] [date] NULL,
	[DueDate] [date] NULL,
	[EggsDelivered] [int] NULL,
	[UnitPrice] [numeric](10, 6) NULL,
	[InvoiceAmount] [money] NULL,
	[DeliveryCharge] [money] NULL,
	[Printed] [bit] NULL,
	[Uploaded] [bit] NULL,
	[Cancelled] [bit] NULL,
	[Paid] [bit] NULL,
	[IsActive] [bit] NULL,
	[EggsInvoiced] [int] NULL,
	[ChargeForEggsInvoiced] [money] NULL,
	[Notes] [varchar](500) NULL,
	[AccumulatedEggCount] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
