USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ORDER_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ORDER_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[ORDER_Lookup]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ORDER_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ORDER_Lookup] AS' 
END
GO


ALTER proc [dbo].[ORDER_Lookup]
	@IncludeBlank bit = 0
	,@IncludeAll bit = 0
	,@IncludeCancelled bit = 0
As

select *
from
(
	select LotNbr,OrderID
	from [ORDER]
	where OrderStatusID <> (select OrderStatusID from OrderStatus where OrderStatus = 'Cancelled')

	union all
	select '',''
	where @IncludeBlank = 1

	union all
	select 'All',''
	where @IncludeAll = 1

	union all
	select LotNbr,OrderID
	from [ORDER]
	where @IncludeCancelled = 1 and OrderStatusID = (select OrderStatusID from OrderStatus where OrderStatus = 'Cancelled')
) d
order by LotNbr



GO
