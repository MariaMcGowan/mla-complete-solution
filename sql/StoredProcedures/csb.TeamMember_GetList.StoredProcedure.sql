USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[TeamMember_GetList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[TeamMember_GetList]
GO
/****** Object:  StoredProcedure [csb].[TeamMember_GetList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[TeamMember_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[TeamMember_GetList] AS' 
END
GO

ALTER procedure [csb].[TeamMember_GetList]
as

select t.Organization, t.Name, t.FirstInvolvementDate, t.Role
	from csb.TeamMember t
	order by t.FirstInvolvementDate, Name

GO
