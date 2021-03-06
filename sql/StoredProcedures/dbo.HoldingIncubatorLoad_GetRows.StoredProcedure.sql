USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_GetRows]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[HoldingIncubatorLoad_GetRows]
GO
/****** Object:  StoredProcedure [dbo].[HoldingIncubatorLoad_GetRows]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldingIncubatorLoad_GetRows]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HoldingIncubatorLoad_GetRows] AS' 
END
GO


ALTER proc [dbo].[HoldingIncubatorLoad_GetRows] @DeliveryID int
AS

declare 
	@HoldingIncubatorID int
	, @RowCount int
	, @X int
select top 1 @HoldingIncubatorID = hi.HoldingIncubatorID
from Delivery d
inner join HoldingIncubator hi on d.HoldingIncubatorID = hi.HoldingIncubatorID
inner join OrderDelivery od on d.DeliveryID = od.DeliveryID
inner join [Order] o on od.OrderID = o.OrderID
where d.DeliveryID = @DeliveryID

select 
	@RowCount = row_count
from HoldingIncubator where HoldingIncubatorID = @HoldingIncubatorID

declare @Data table (RowNumber int)

select @X = 0

while @X < @RowCount + 1	-- extra row for fans
begin
	select @X = @X + 1
	insert into @Data (RowNumber)
	select @X
end

select *
from @Data
order by 1 


GO
