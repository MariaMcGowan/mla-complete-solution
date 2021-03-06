USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_AssignOrders_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[LoadPlanning_AssignOrders_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[LoadPlanning_AssignOrders_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoadPlanning_AssignOrders_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[LoadPlanning_AssignOrders_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[LoadPlanning_AssignOrders_InsertUpdate]
	@I_vLoadPlanningID int
	,@I_vSelected bit
	,@I_vOrderID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS


update [Order] set LoadPlanningID = @I_vLoadPlanningID where @I_vSelected = 1 and OrderID = @I_vOrderID
update [Order] set LoadPlanningID = null where @I_vSelected = 0 and OrderID = @I_vOrderID

	
select @iRowID = @I_vOrderID





GO
