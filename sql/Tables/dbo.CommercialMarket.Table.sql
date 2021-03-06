USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialMarket]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialMarket] DROP CONSTRAINT IF EXISTS [FK__Commercia__Secon__0B3292B8]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialMarket]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialMarket] DROP CONSTRAINT IF EXISTS [FK__Commercia__Prima__0A3E6E7F]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialMarket]') AND type in (N'U'))
ALTER TABLE [dbo].[CommercialMarket] DROP CONSTRAINT IF EXISTS [DF__Commercia__IsAct__0C26B6F1]
GO
/****** Object:  Table [dbo].[CommercialMarket]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[CommercialMarket]
GO
/****** Object:  Table [dbo].[CommercialMarket]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialMarket]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CommercialMarket](
	[CommercialMarketID] [int] IDENTITY(1,1) NOT NULL,
	[CommercialMarket] [varchar](100) NULL,
	[PrimaryContactID] [int] NULL,
	[SecondaryContactID] [int] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CommercialMarketID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Commercia__IsAct__0C26B6F1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CommercialMarket] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Commercia__Prima__0A3E6E7F]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommercialMarket]'))
ALTER TABLE [dbo].[CommercialMarket]  WITH CHECK ADD FOREIGN KEY([PrimaryContactID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Commercia__Secon__0B3292B8]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommercialMarket]'))
ALTER TABLE [dbo].[CommercialMarket]  WITH CHECK ADD FOREIGN KEY([SecondaryContactID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
