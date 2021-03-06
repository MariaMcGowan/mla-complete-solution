USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationServiceTemplate]') AND type in (N'U'))
ALTER TABLE [dbo].[VaccinationServiceTemplate] DROP CONSTRAINT IF EXISTS [DF__Vaccinati__IsAct__0638D371]
GO
/****** Object:  Table [dbo].[VaccinationServiceTemplate]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[VaccinationServiceTemplate]
GO
/****** Object:  Table [dbo].[VaccinationServiceTemplate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationServiceTemplate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VaccinationServiceTemplate](
	[VaccinationServiceTemplateID] [int] IDENTITY(1,1) NOT NULL,
	[VaccinationServiceTemplateDescr] [varchar](100) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[VaccinationServiceTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Vaccinati__IsAct__0638D371]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[VaccinationServiceTemplate] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
