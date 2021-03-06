USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contract]') AND type in (N'U'))
ALTER TABLE [dbo].[Contract] DROP CONSTRAINT IF EXISTS [FK__Contract__Produc__2D87AABC]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contract]') AND type in (N'U'))
ALTER TABLE [dbo].[Contract] DROP CONSTRAINT IF EXISTS [FK__Contract__Custom__2C938683]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contract]') AND type in (N'U'))
ALTER TABLE [dbo].[Contract] DROP CONSTRAINT IF EXISTS [FK__Contract__Contra__2F6FF32E]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contract]') AND type in (N'U'))
ALTER TABLE [dbo].[Contract] DROP CONSTRAINT IF EXISTS [DF__Contract__IsActi__2E7BCEF5]
GO
/****** Object:  Table [dbo].[Contract]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[Contract]
GO
/****** Object:  Table [dbo].[Contract]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contract]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Contract](
	[ContractID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[ProductTypeID] [int] NULL,
	[EffectiveDateStart] [date] NULL,
	[EffectiveDateEnd] [date] NULL,
	[CaseWeightMin] [numeric](10, 4) NULL,
	[FlockAgeInWeeksMax] [int] NULL,
	[IsActive] [bit] NULL,
	[ContractTypeID] [int] NULL,
	[FlockAgeInWeeksMin] [numeric](10, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[ContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Contract__IsActi__2E7BCEF5]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Contract] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Contract__Contra__2F6FF32E]') AND parent_object_id = OBJECT_ID(N'[dbo].[Contract]'))
ALTER TABLE [dbo].[Contract]  WITH CHECK ADD FOREIGN KEY([ContractTypeID])
REFERENCES [dbo].[ContractType] ([ContractTypeID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Contract__Custom__2C938683]') AND parent_object_id = OBJECT_ID(N'[dbo].[Contract]'))
ALTER TABLE [dbo].[Contract]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Contract__Produc__2D87AABC]') AND parent_object_id = OBJECT_ID(N'[dbo].[Contract]'))
ALTER TABLE [dbo].[Contract]  WITH CHECK ADD FOREIGN KEY([ProductTypeID])
REFERENCES [dbo].[ProductType] ([ProductTypeID])
GO
