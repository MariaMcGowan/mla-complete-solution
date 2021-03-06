USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[rptEggsAddedToCooler]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[rptEggsAddedToCooler]
GO
/****** Object:  StoredProcedure [dbo].[rptEggsAddedToCooler]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rptEggsAddedToCooler]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[rptEggsAddedToCooler] AS' 
END
GO


ALTER proc [dbo].[rptEggsAddedToCooler]
@StartDate date = null
,@EndDate date = null
,@FarmID int = null

AS

select @StartDate = isnull(nullif(@StartDate, ''), '01/01/1900'),
	@EndDate = isnull(nullif(@EndDate, ''), convert(date,getdate())),
	@FarmID = nullif(@FarmID, '')

select ChangeDate = convert(date,QtyChangeActualDate), fl.Flock, QtyChange = dbo.ConvertEggsToCases(isnull(sum(QtyChange),0)), QuantityChangeReason = isnull(r.QuantityChangeReason, 'Unknown Change Reason'), r.QuantityChangeReasonID, 
SubTotalLabel = 'Total for ' + isnull(r.QuantityChangeReason, 'Unknown Change Reason') + ' on ' + convert(varchar(20), convert(date,QtyChangeActualDate), 101)
from EggTransaction e
inner join Clutch c on e.ClutchID = c.ClutchID
inner join Flock fl on c.FlockID = fl.FlockID
inner join Farm fa on fl.FarmID = fa.FarmID
left outer join QuantityChangeReason r on e.QtyChangeReasonID = r.QuantityChangeReasonID
where isnull(@FarmID, fa.FarmID) = fa.FarmID
and QtyChangeActualDate between @StartDate and @EndDate
group by convert(date,QtyChangeActualDate), fl.Flock, r.QuantityChangeReason, r.QuantityChangeReasonID, r.SortOrder
order by convert(date,QtyChangeActualDate), r.SortOrder




GO
