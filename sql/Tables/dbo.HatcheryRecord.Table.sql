USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HatcheryRecord]') AND type in (N'U'))
ALTER TABLE [dbo].[HatcheryRecord] DROP CONSTRAINT IF EXISTS [FK__HatcheryR__Contr__3BA0BFE9]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HatcheryRecord]') AND type in (N'U'))
ALTER TABLE [dbo].[HatcheryRecord] DROP CONSTRAINT IF EXISTS [DF__HatcheryR__ZeroO__3C94E422]
GO
/****** Object:  Table [dbo].[HatcheryRecord]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[HatcheryRecord]
GO
/****** Object:  Table [dbo].[HatcheryRecord]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HatcheryRecord]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HatcheryRecord](
	[HatcheryRecordID] [int] IDENTITY(1,1) NOT NULL,
	[ContractTypeID] [int] NULL,
	[Date] [date] NULL,
	[FarmPickupQty] [int] NULL,
	[ZeroOutCooler] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[HatcheryRecordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HatcheryR__ZeroO__3C94E422]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HatcheryRecord] ADD  DEFAULT ((0)) FOR [ZeroOutCooler]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__HatcheryR__Contr__3BA0BFE9]') AND parent_object_id = OBJECT_ID(N'[dbo].[HatcheryRecord]'))
ALTER TABLE [dbo].[HatcheryRecord]  WITH CHECK ADD FOREIGN KEY([ContractTypeID])
REFERENCES [dbo].[ContractType] ([ContractTypeID])
GO
