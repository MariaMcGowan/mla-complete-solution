USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationService]') AND type in (N'U'))
ALTER TABLE [dbo].[VaccinationService] DROP CONSTRAINT IF EXISTS [FK__Vaccinati__Flock__0FC23DAB]
GO
/****** Object:  Table [dbo].[VaccinationService]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[VaccinationService]
GO
/****** Object:  Table [dbo].[VaccinationService]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaccinationService]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VaccinationService](
	[VaccinationServiceID] [int] IDENTITY(1,1) NOT NULL,
	[VaccinationService] [varchar](100) NULL,
	[FlockID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[VaccinationServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Vaccinati__Flock__0FC23DAB]') AND parent_object_id = OBJECT_ID(N'[dbo].[VaccinationService]'))
ALTER TABLE [dbo].[VaccinationService]  WITH CHECK ADD FOREIGN KEY([FlockID])
REFERENCES [dbo].[PulletFarmPlan] ([PulletFarmPlanID])
GO
