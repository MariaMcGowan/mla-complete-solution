USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[PagePart]') AND type in (N'U'))
ALTER TABLE [csb].[PagePart] DROP CONSTRAINT IF EXISTS [FK__PagePart__PagePa__46E78A0C]
GO
/****** Object:  Table [csb].[PagePart]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [csb].[PagePart]
GO
/****** Object:  Table [csb].[PagePart]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[PagePart]') AND type in (N'U'))
BEGIN
CREATE TABLE [csb].[PagePart](
	[PagePartID] [int] IDENTITY(1,1) NOT NULL,
	[PagePartTypeID] [int] NOT NULL,
	[XmlScreenID] [varchar](255) NOT NULL,
	[IsReadOnly] [bit] NOT NULL,
	[IsViewableDefault] [bit] NOT NULL,
	[IsUpdatableDefault] [bit] NOT NULL,
	[MenuID] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[PagePartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[XmlScreenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[csb].[FK__PagePart__PagePa__46E78A0C]') AND parent_object_id = OBJECT_ID(N'[csb].[PagePart]'))
ALTER TABLE [csb].[PagePart]  WITH CHECK ADD FOREIGN KEY([PagePartTypeID])
REFERENCES [csb].[PagePartType] ([PagePartTypeID])
GO
