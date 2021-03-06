USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContractVolume]') AND type in (N'U'))
ALTER TABLE [dbo].[ContractVolume] DROP CONSTRAINT IF EXISTS [FK__ContractV__Contr__38C4533E]
GO
/****** Object:  Table [dbo].[ContractVolume]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[ContractVolume]
GO
/****** Object:  Table [dbo].[ContractVolume]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContractVolume]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ContractVolume](
	[ContractVolumeID] [int] IDENTITY(1,1) NOT NULL,
	[ContractID] [int] NULL,
	[WeekEndingDate] [date] NULL,
	[Volume] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ContractVolumeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ContractV__Contr__38C4533E]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContractVolume]'))
ALTER TABLE [dbo].[ContractVolume]  WITH CHECK ADD FOREIGN KEY([ContractID])
REFERENCES [dbo].[Contract] ([ContractID])
GO
