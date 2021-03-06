USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryDate_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[DeliveryDate_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[DeliveryDate_Lookup]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeliveryDate_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeliveryDate_Lookup] AS' 
END
GO


ALTER proc [dbo].[DeliveryDate_Lookup]
	@IncludeBlank bit = 0
	,@IncludeAll bit = 0
As

select distinct DeliveryDate, DeliveryDate, PlannedSetDate as SetDate, PlannedSetDate as SortOrder
from dbo.[Order] o
where o.OrderStatusID < 5 and DeliveryDate is not null

union all
select '','','','01/01/1900'
where @IncludeBlank = 1

union all
select 'All','','','01/01/1900'
where @IncludeAll = 1
order by 4



GO
