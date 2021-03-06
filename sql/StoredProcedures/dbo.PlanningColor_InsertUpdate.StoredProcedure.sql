USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PlanningColor_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PlanningColor_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[PlanningColor_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PlanningColor_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PlanningColor_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[PlanningColor_InsertUpdate]  
 @I_vPlanningColorID int
 ,@I_vDescription nvarchar(100) = null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  


update PlanningColor set Description = @I_vDescription where PlanningColorID = @I_vPlanningColorID
 
select @iRowID = @I_vPlanningColorID  


--select @I_vPlanningColorID as ID,'forward' As referenceType


GO
