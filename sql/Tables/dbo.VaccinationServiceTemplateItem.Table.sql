USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationServiceTemplateItem]') AND type in (N'U'))
ALTER TABLE [dbo].[VaccinationServiceTemplateItem] DROP CONSTRAINT IF EXISTS [FK__Vaccinati__Vacci__0CE5D100]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationServiceTemplateItem]') AND type in (N'U'))
ALTER TABLE [dbo].[VaccinationServiceTemplateItem] DROP CONSTRAINT IF EXISTS [DF__Vaccinati__IsAct__0BF1ACC7]
GO
/****** Object:  Table [dbo].[VaccinationServiceTemplateItem]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[VaccinationServiceTemplateItem]
GO
/****** Object:  Table [dbo].[VaccinationServiceTemplateItem]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationServiceTemplateItem]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VaccinationServiceTemplateItem](
	[VaccinationServiceTemplateItemID] [int] IDENTITY(1,1) NOT NULL,
	[VaccinationServiceTemplateID] [int] NULL,
	[ServiceOrDisease] [char](1) NULL,
	[AgeInDays] [int] NULL,
	[Service] [varchar](200) NULL,
	[Disease] [varchar](200) NULL,
	[VaccineDeliveryMethod] [varchar](20) NULL,
	[Supplier] [varchar](20) NULL,
	[ProductName] [varchar](50) NULL,
	[ProductSerialNumber] [varchar](20) NULL,
	[Administrator] [varchar](20) NULL,
	[IsActive] [bit] NULL,
	[SortOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[VaccinationServiceTemplateItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Vaccinati__IsAct__0BF1ACC7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[VaccinationServiceTemplateItem] ADD  DEFAULT ((1)) FOR [IsActive]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Vaccinati__Vacci__0CE5D100]') AND parent_object_id = OBJECT_ID(N'[dbo].[VaccinationServiceTemplateItem]'))
ALTER TABLE [dbo].[VaccinationServiceTemplateItem]  WITH CHECK ADD FOREIGN KEY([VaccinationServiceTemplateID])
REFERENCES [dbo].[VaccinationServiceTemplate] ([VaccinationServiceTemplateID])
GO
