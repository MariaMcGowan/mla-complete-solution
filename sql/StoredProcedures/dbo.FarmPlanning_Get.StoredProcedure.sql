USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FarmPlanning_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FarmPlanning_Get]
GO
/****** Object:  StoredProcedure [dbo].[FarmPlanning_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FarmPlanning_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FarmPlanning_Get] AS' 
END
GO



ALTER proc [dbo].[FarmPlanning_Get]  @FarmID int = null
As   

	select @FarmID = nullif(@FarmID, '')

	select  
	 FarmID
	 , Farm
	 , FarmNumber
	 , DefaultPulletQty
	 , MaxPulletQty
	 , ConservativeFactor = isnull(ConservativeFactor, 1)
	from Farm  
	where IsActive = 1
	and FarmID = isnull(@FarmID, FarmID)



GO
