USE [MLA]
GO
/****** Object:  Table [csb].[TeamMember]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [csb].[TeamMember]
GO
/****** Object:  Table [csb].[TeamMember]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[TeamMember]') AND type in (N'U'))
BEGIN
CREATE TABLE [csb].[TeamMember](
	[TeamMemberID] [int] IDENTITY(1,1) NOT NULL,
	[Organization] [varchar](255) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[FirstInvolvementDate] [date] NOT NULL,
	[Role] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TeamMemberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
