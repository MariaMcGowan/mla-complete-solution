USE [MLA]
GO
/****** Object:  UserDefinedFunction [dbo].[OldAge_CalcMaxDayCount]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP FUNCTION IF EXISTS [dbo].[OldAge_CalcMaxDayCount]
GO
/****** Object:  UserDefinedFunction [dbo].[OldAge_CalcMaxDayCount]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OldAge_CalcMaxDayCount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[OldAge_CalcMaxDayCount] (@SetDate date, @WorkID int)
returns int
as
begin

	declare @ReturnDayCount int
	
	;with cte_CheckCoolerInventory (GoBackXDays) as
	(
		select 0
	
		union all
	
		select GoBackXDays + 1
		from cte_CheckCoolerInventory
		where GoBackXDays < 10 and not exists (select 1 from WorkData where WorkID = @WorkID and SetDate = dateadd(day,-1 * GoBackXDays, @SetDate) and isnull(CasesInCooler,0) <= 0)
	)

	select @ReturnDayCount = max(GoBackXDays)
	from cte_CheckCoolerInventory

	return @ReturnDayCount
end
' 
END

GO
