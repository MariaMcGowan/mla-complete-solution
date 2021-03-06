USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PlanningColor_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PlanningColor_Get]
GO
/****** Object:  StoredProcedure [dbo].[PlanningColor_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PlanningColor_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PlanningColor_Get] AS' 
END
GO



ALTER proc [dbo].[PlanningColor_Get] 
	@PlanningColorID int = null

as

begin
	
	select PlanningColorID, PlanningColor = PlanningColor + 'Background', Description, BlankField = ''
	from PlanningColor
	where PlanningColorID = isnull(@PlanningColorID, PlanningColorID)
	
end


GO
