USE [MLA]
GO
/****** Object:  Table [dbo].[AuditStatus]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[AuditStatus]
GO
/****** Object:  Table [dbo].[AuditStatus]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuditStatus](
	[AuditStatusID] [int] IDENTITY(1,1) NOT NULL,
	[AuditStatus] [varchar](20) NULL
) ON [PRIMARY]
END
GO
