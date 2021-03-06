USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[FormatAddress]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FormatAddress]
GO
/****** Object:  UserDefinedFunction [dbo].[FormatAddress]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FormatAddress]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create  FUNCTION [dbo].[FormatAddress](
	 @Address1 	varchar(255)
	,@Address2 	varchar(255)
	,@City 		varchar(255)
	,@State		varchar(50)
	,@Zip		varchar(10)
	,@Delimeter	varchar(10)
)

RETURNS varchar(8000)
AS
BEGIN
	select @Address1 = nullif(@Address1, '''')
		, @Address2 = nullif(@Address2, '''')
		, @City = nullif(@City, '''')
		, @State = nullif(@State, '''')
		, @Zip = nullif(@Zip, '''')

	
	DECLARE
		 @Address		varchar(1000)
		,@CityStateZip	varchar(1000)
		,@Return		varchar(2000)

	SELECT @Address = 
		  CASE 
			WHEN @Address1 IS NULL AND @Address2 IS NULL THEN ''''
			WHEN @Address1 IS NOT NULL AND @Address2 IS NOT NULL THEN @Address1 + @Delimeter + @Address2
			WHEN @Address1 IS NOT NULL THEN @Address1
			WHEN @Address2 IS NULL THEN @Address2
			ELSE ''''
		 END
		,@CityStateZip = 
		 CASE 
			WHEN @City IS NULL AND @State IS NULL AND @Zip IS NULL THEN ''''
			WHEN @City IS NOT NULL AND @State IS NOT NULL AND @Zip IS NOT NULL THEN @City + '', '' + @State + '' '' + @Zip
			WHEN @City IS NOT NULL AND @State IS NOT NULL AND @Zip IS NULL THEN @City + '', '' + @State 
			WHEN @City IS NOT NULL AND @State IS NULL AND @Zip IS NOT NULL THEN @City + '' '' + @Zip
			WHEN @City IS NULL AND @State IS NOT NULL AND @Zip IS NOT NULL THEN @State + '' '' + @Zip
			WHEN @City IS NOT NULL AND @State IS NULL AND @Zip IS NULL THEN @City
			WHEN @City IS NULL AND @State IS NOT NULL AND @Zip IS NULL THEN @State
			WHEN @City IS NULL AND @State IS NULL AND @Zip IS NOT NULL THEN @Zip
			ELSE ''''
		 END
	
	SELECT @Return = 
			CASE
				WHEN LEN(@Address) > 0 AND LEN(@CityStateZip) > 0 THEN @Address + @Delimeter + @CityStateZip
				WHEN LEN(@Address) > 0 AND LEN(@CityStateZip) = 0 THEN @Address
				WHEN LEN(@Address) = 0 AND LEN(@CityStateZip) > 0 THEN @CityStateZip
			END
	
	RETURN @Return
END






' 
END

GO
