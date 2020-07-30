USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FarmEmbryoStandardYield_DeleteFarm]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FarmEmbryoStandardYield_DeleteFarm]
GO
/****** Object:  StoredProcedure [dbo].[FarmEmbryoStandardYield_DeleteFarm]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FarmEmbryoStandardYield_DeleteFarm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FarmEmbryoStandardYield_DeleteFarm] AS' 
END
GO



ALTER proc [dbo].[FarmEmbryoStandardYield_DeleteFarm]  
 @FarmID int

 as

 if @FarmID is not null
 begin
	delete from FarmEmbryoStandardYield where FarmID = @FarmID
 end



GO
