USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderDeliveryCart_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderDeliveryCart_Delete]
GO
/****** Object:  StoredProcedure [dbo].[OrderDeliveryCart_Delete]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDeliveryCart_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderDeliveryCart_Delete] AS' 
END
GO


ALTER proc [dbo].[OrderDeliveryCart_Delete]
	@I_vOrderDeliveryCartID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS


delete from OrderDeliveryCart where OrderDeliveryCartID = @I_vOrderDeliveryCartID



GO
