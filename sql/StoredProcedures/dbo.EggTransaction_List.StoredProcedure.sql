USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_List]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggTransaction_List]
GO
/****** Object:  StoredProcedure [dbo].[EggTransaction_List]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggTransaction_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggTransaction_List] AS' 
END
GO


ALTER proc [dbo].[EggTransaction_List] 
	@CoolerClutchID int = null
	, @FlockID int = null
    , @LayDate_Start date = null
    , @LayDate_End date = null
    , @ChangeDate_Start date = null
    , @ChangeDate_End date = null
    , @QuantityChangeReasonID int = null
As


select @CoolerClutchID = nullif(@CoolerClutchID, '')
	, @FlockID = nullif(@FlockID, '')
    , @LayDate_Start = isnull(nullif(@LayDate_Start, ''), '01/01/2000')
    , @LayDate_End = isnull(nullif(@LayDate_End, ''), getdate())
    , @ChangeDate_Start =  isnull(nullif(@ChangeDate_Start, ''), '01/01/2000')
    , @ChangeDate_End = isnull(nullif(@ChangeDate_End, ''), getdate())
    , @QuantityChangeReasonID = nullif(@QuantityChangeReasonID, '')
declare @ClutchID int

if @ClutchID is null and @CoolerClutchID is not null
begin
	select @ClutchID = ClutchID from CoolerClutch where CoolerClutchID = @CoolerClutchID
end


--select @Flock = Flock, @LayDate = LayDate
--from Flock fl
--inner join Clutch cl on fl.FlockID = cl.FlockID
--where ClutchID = @ClutchID

select et.ClutchID, fl.FlockID, Flock, LayDate, QtyChangeActualDate, QtyChange, qcr.QuantityChangeReason
from EggTransaction et
inner join Clutch cl on et.ClutchID = cl.ClutchID
inner join Flock fl on cl.FlockID = fl.FlockID
left outer join QuantityChangeReason qcr on et.QtyChangeReasonID = qcr.QuantityChangeReasonID
where LayDate between @LayDate_Start and @LayDate_End
	and QtyChangeActualDate between @ChangeDate_Start and @ChangeDate_End
	and et.ClutchID = isnull(@ClutchID, et.ClutchID)
	and fl.FlockID = isnull(@FlockID, fl.FlockID)
	and et.QtyChangeReasonID = isnull(@QuantityChangeReasonID, et.QtyChangeReasonID)
order by Flock, LayDate desc, EggTransactionID




GO
