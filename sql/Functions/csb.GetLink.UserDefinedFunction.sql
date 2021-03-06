USE [MLA]
GO
/****** Object:  UserDefinedFunction [csb].[GetLink]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [csb].[GetLink]
GO
/****** Object:  UserDefinedFunction [csb].[GetLink]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[GetLink]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [csb].[GetLink] (
	@template varchar(max)
	, @screen varchar(max)
	, @detailScreen varchar(max)
	, @id int
	, @text varchar(max)
)
RETURNS varchar(max)
AS
BEGIN
	RETURN ''<a href="'' + @template + ''?screenID='' + @screen 
		+ ''&detailScreenID='' + @detailScreen + ''&p='' + cast(@id AS varchar) 
		+ ''">'' + @text + ''</a>''
END
' 
END

GO
