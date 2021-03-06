USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[BuildingsOrFarms_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[BuildingsOrFarms_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[BuildingsOrFarms_Lookup]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BuildingsOrFarms_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[BuildingsOrFarms_Lookup] AS' 
END
GO


ALTER proc [dbo].[BuildingsOrFarms_Lookup]
As

select 'Buildings' as BuildingsOrFarms, 'B' as BuildingsOrFarmsID
union all
select 'Farms' as BuildingsOrFarms, 'F' as BuildingsOrFarmsID



GO
