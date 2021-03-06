USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[HatcheryRecords_Get_BuildingList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HatcheryRecords_Get_BuildingList]
GO
/****** Object:  StoredProcedure [dbo].[HatcheryRecords_Get_BuildingList]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HatcheryRecords_Get_BuildingList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HatcheryRecords_Get_BuildingList] AS' 
END
GO



ALTER proc [dbo].[HatcheryRecords_Get_BuildingList] @DefaultContractTypeID int = null
as

	select @DefaultContractTypeID = nullif(@DefaultContractTypeID, '')

	select DestinationBuildingID, DestinationBuilding, DefaultContractTypeID
	from 
	(
		select DestinationBuildingID, 'B' + DestinationBuilding + ' Orders' as DestinationBuilding, DefaultContractTypeID, convert(int, DestinationBuilding) as SortOrder
		from DestinationBuilding
		where IsActive = 1
			and isnumeric(DestinationBuilding) = 1
		union all
		select 9999, 'Custom Incubation', 1, 9999 as SortOrder
		union all
		select 9999, 'Custom Incubation', 2, 9999 as SortOrder
	) a
	where @DefaultContractTypeID is null
	or (@DefaultContractTypeID is not null and a.DefaultContractTypeID = @DefaultContractTypeID)
	order by SortOrder



GO
