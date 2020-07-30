USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EmbryoOrPullet_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EmbryoOrPullet_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[EmbryoOrPullet_Lookup]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmbryoOrPullet_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EmbryoOrPullet_Lookup] AS' 
END
GO



ALTER proc [dbo].[EmbryoOrPullet_Lookup]
  As    
  
  select 'Egg' as ShowEmbryoOrPulletQty, 'Egg' as ShowEmbryoOrPulletQtyID
  union all
  select 'Bird' as ShowEmbryoOrPulletQty, 'Pullet' as ShowEmbryoOrPulletQtyID
 
  



GO
