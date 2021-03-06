USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[UserGroupPagePart]') AND type in (N'U'))
ALTER TABLE [csb].[UserGroupPagePart] DROP CONSTRAINT IF EXISTS [FK__UserGroup__PageP__5165187F]
GO
/****** Object:  Table [csb].[UserGroupPagePart]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [csb].[UserGroupPagePart]
GO
/****** Object:  Table [csb].[UserGroupPagePart]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[UserGroupPagePart]') AND type in (N'U'))
BEGIN
CREATE TABLE [csb].[UserGroupPagePart](
	[UserGroupPagePartID] [int] IDENTITY(1,1) NOT NULL,
	[UserGroupID] [int] NOT NULL,
	[PagePartID] [int] NOT NULL,
	[IsViewable] [bit] NOT NULL,
	[IsUpdatable] [bit] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[UserGroupPagePartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_UserGroupPagePart_UserGroupIDPagePartID] UNIQUE CLUSTERED 
(
	[UserGroupID] ASC,
	[PagePartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[csb].[FK__UserGroup__PageP__5165187F]') AND parent_object_id = OBJECT_ID(N'[csb].[UserGroupPagePart]'))
ALTER TABLE [csb].[UserGroupPagePart]  WITH CHECK ADD FOREIGN KEY([PagePartID])
REFERENCES [csb].[PagePart] ([PagePartID])
GO
