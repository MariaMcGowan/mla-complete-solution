USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryHoldingIncubatorSelect_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[DeliveryHoldingIncubatorSelect_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryHoldingIncubatorSelect_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryHoldingIncubatorSelect_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeliveryHoldingIncubatorSelect_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[DeliveryHoldingIncubatorSelect_InsertUpdate]
	@I_vDeliveryID int
	,@I_vHoldingIncubatorID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

update Delivery
set HoldingIncubatorID = @I_vHoldingIncubatorID
where DeliveryID = @I_vDeliveryID




GO
