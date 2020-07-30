USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialMarket_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialMarket_Delete]
GO
/****** Object:  StoredProcedure [dbo].[CommercialMarket_Delete]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialMarket_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialMarket_Delete] AS' 
END
GO



ALTER proc [dbo].[CommercialMarket_Delete]
 @I_vCommercialMarketID int
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  
			
AS

Update CommercialMarket set IsActive = 0 where CommercialMarketID = @I_vCommercialMarketID



GO
