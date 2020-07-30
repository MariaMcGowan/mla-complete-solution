USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Get_SecurityScreenForScreenIDPreProcess]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Get_SecurityScreenForScreenIDPreProcess]
GO
/****** Object:  StoredProcedure [dbo].[Get_SecurityScreenForScreenIDPreProcess]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_SecurityScreenForScreenIDPreProcess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Get_SecurityScreenForScreenIDPreProcess] AS' 
END
GO



ALTER PROC [dbo].[Get_SecurityScreenForScreenIDPreProcess]
	@screenID varchar(255)
AS
	SELECT ReferenceType='forward', p='&p=' + @screenID 

	/*
	select ReferenceType='forward', p=IsNull(convert(varchar(50),MenuIdentifier), '') + '&p=' + @screenID 
	from csiScreen s left outer join csiMenu m on s.csiScreenID = m.csiScreenID
	where s.id = @screenID
	*/



GO
