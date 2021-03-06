USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[RoundUpToNearestN]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[RoundUpToNearestN]
GO
/****** Object:  UserDefinedFunction [dbo].[RoundUpToNearestN]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RoundUpToNearestN]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create FUNCTION [dbo].[RoundUpToNearestN]
(
	-- Add the parameters for the function here
	@Nbr int, 
	@RoundUpToNumber int
)
RETURNS int
AS
BEGIN
	
	declare @ReturnValue int


	select @ReturnValue = 
	case
		when @Nbr % @RoundUpToNumber = 0 then @Nbr
		else @Nbr + @RoundUpToNumber - (@Nbr % @RoundUpToNumber)
	end

	RETURN @ReturnValue

END
' 
END

GO
