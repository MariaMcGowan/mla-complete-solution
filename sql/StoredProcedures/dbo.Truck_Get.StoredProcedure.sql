USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Truck_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Truck_Get]
GO
/****** Object:  StoredProcedure [dbo].[Truck_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Truck_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Truck_Get] AS' 
END
GO


ALTER proc [dbo].[Truck_Get]
@TruckID int = null
,@IncludeNew bit = 1
As

select
	TruckID
	, Truck
	, SortOrder
	, IsActive
from Truck
where IsNull(@TruckID,TruckID) = TruckID
union all
select
	TruckID = convert(int,0)
	, Truck = convert(nvarchar(255),null)
	, SortOrder = convert(int,IsNull((Select MAX(SortOrder) + 1 from Truck),1))
	, IsActive = convert(bit,1)
where @IncludeNew = 1



GO
