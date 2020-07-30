USE [MLA]
GO
/****** Object:  Table [dbo].[PlanningColor]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[PlanningColor]
GO
/****** Object:  Table [dbo].[PlanningColor]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PlanningColor]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PlanningColor](
	[PlanningColorID] [int] IDENTITY(1,1) NOT NULL,
	[PlanningColor] [varchar](20) NULL,
	[Description] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[PlanningColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
