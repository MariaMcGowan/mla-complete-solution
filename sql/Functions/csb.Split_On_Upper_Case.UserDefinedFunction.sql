USE [MLA]
GO
/****** Object:  UserDefinedFunction [csb].[Split_On_Upper_Case]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [csb].[Split_On_Upper_Case]
GO
/****** Object:  UserDefinedFunction [csb].[Split_On_Upper_Case]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[Split_On_Upper_Case]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [csb].[Split_On_Upper_Case](@Temp VarChar(1000))
Returns VarChar(1000)
AS
Begin
    Declare @KeepValues as varchar(50)
    Set @KeepValues = ''%[^ ][A-Z]%''
    While PatIndex(@KeepValues collate Latin1_General_Bin, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues collate Latin1_General_Bin, @Temp) + 1, 0, '' '')
    Return @Temp
End
' 
END

GO
