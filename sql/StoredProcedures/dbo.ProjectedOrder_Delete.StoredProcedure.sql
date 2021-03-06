USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ProjectedOrder_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ProjectedOrder_Delete]
GO
/****** Object:  StoredProcedure [dbo].[ProjectedOrder_Delete]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProjectedOrder_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ProjectedOrder_Delete] AS' 
END
GO


ALTER proc [dbo].[ProjectedOrder_Delete]
	@I_vProjectedOrderID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

	-- while we don't delete real orders, we do delete projected orders
	delete from ProjectedOrder where ProjectedOrderID = @I_vProjectedOrderID




GO
