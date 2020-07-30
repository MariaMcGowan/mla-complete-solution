USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryHoldingIncubatorSelect]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[DeliveryHoldingIncubatorSelect]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryHoldingIncubatorSelect]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryHoldingIncubatorSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeliveryHoldingIncubatorSelect] AS' 
END
GO



ALTER proc [dbo].[DeliveryHoldingIncubatorSelect]
@DeliveryID int
AS

Select @DeliveryID as DeliveryID, convert(int,null) as HoldingIncubatorID



GO
