USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Order_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Order_Delete]
GO
/****** Object:  StoredProcedure [dbo].[Order_Delete]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Order_Delete] AS' 
END
GO


ALTER proc [dbo].[Order_Delete]
	@I_vOrderID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

	-- We don't delete orders, we mark them as cancelled
	update [ORDER] set OrderStatusID = 5 where OrderID = @I_vOrderID

	update OrderFlock set PlannedQty = 0, ActualQty = 0 where OrderID = @I_vOrderID

	update ofcl set PlannedQty = 0, ActualQty = 0 
	from OrderFlockClutch ofcl
	inner join OrderFlock ofl on ofcl.OrderFlockID = ofl.OrderFlockID
	where OrderID = @I_vOrderID




GO
