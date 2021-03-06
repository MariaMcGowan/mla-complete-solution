/****** Object:  UserDefinedFunction [dbo].[GetPlanningFarmList]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetPlanningFarmList]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPlanningFarmList]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPlanningFarmList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
create FUNCTION [dbo].[GetPlanningFarmList]
(
	@UserID varchar(255)
)
RETURNS 
@FarmList TABLE 
(
	-- Add the column definitions for the TABLE variable here
	FarmColumn int, 
	FarmID int, 
	FarmName varchar(100), 
	FarmNumber varchar(6)
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	insert into @FarmList (FarmColumn, FarmID, FarmName, FarmNumber)
	select row_number() OVER (ORDER BY SortOrder ASC) -1 AS FarmColumn, FarmID, 
	FarmName = replace(Farm, convert(varchar(6), FarmNumber), ''''),
	convert(varchar(6), FarmNumber)
	from Farm f
	where IsActive = 1 
		and exists (select 1 from UserPlanningFarmList where UserID = @UserID and FarmID = f.FarmID)
	order by FarmNumber

	RETURN 

END
' 
END

GO
