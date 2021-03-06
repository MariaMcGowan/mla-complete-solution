USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerType]') AND type in (N'U'))
ALTER TABLE [dbo].[CustomerType] DROP CONSTRAINT IF EXISTS [DF__CustomerT__IsAct__1F398B65]
GO
/****** Object:  Table [dbo].[CustomerType]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[CustomerType]
GO
/****** Object:  Table [dbo].[CustomerType]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CustomerType](
	[CustomerTypeID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerType] [varchar](100) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CustomerT__IsAct__1F398B65]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CustomerType] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
