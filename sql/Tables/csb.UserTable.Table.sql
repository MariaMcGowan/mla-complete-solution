USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[UserTable]') AND type in (N'U'))
ALTER TABLE [csb].[UserTable] DROP CONSTRAINT IF EXISTS [FK__UserTable__UserG__1367E606]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[UserTable]') AND type in (N'U'))
ALTER TABLE [csb].[UserTable] DROP CONSTRAINT IF EXISTS [DF__UserTable__Inact__145C0A3F]
GO
/****** Object:  Table [csb].[UserTable]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [csb].[UserTable]
GO
/****** Object:  Table [csb].[UserTable]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[UserTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [csb].[UserTable](
	[UserTableID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [varchar](255) NOT NULL,
	[EmailAddress] [varchar](255) NULL,
	[UserGroupID] [int] NULL,
	[ContactName] [varchar](255) NULL,
	[Inactive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserTableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[DF__UserTable__Inact__145C0A3F]') AND type = 'D')
BEGIN
ALTER TABLE [csb].[UserTable] ADD  DEFAULT ((0)) FOR [Inactive]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[csb].[FK__UserTable__UserG__1367E606]') AND parent_object_id = OBJECT_ID(N'[csb].[UserTable]'))
ALTER TABLE [csb].[UserTable]  WITH CHECK ADD FOREIGN KEY([UserGroupID])
REFERENCES [csb].[UserGroup] ([UserGroupID])
GO
