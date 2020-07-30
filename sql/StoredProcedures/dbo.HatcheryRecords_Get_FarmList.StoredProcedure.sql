USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[HatcheryRecords_Get_FarmList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HatcheryRecords_Get_FarmList]
GO
/****** Object:  StoredProcedure [dbo].[HatcheryRecords_Get_FarmList]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HatcheryRecords_Get_FarmList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HatcheryRecords_Get_FarmList] AS' 
END
GO



ALTER  proc [dbo].[HatcheryRecords_Get_FarmList] 

As   


	declare @FarmList table (FarmColumn int, FarmID int, FarmName varchar(100), FarmNumber varchar(6))
	insert into @FarmList
	select * 
	from dbo.GetHatcheryFarmList()


select *
from @FarmList



GO
