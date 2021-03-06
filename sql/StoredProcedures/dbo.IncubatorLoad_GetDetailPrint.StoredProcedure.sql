USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_GetDetailPrint]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorLoad_GetDetailPrint]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_GetDetailPrint]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorLoad_GetDetailPrint]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorLoad_GetDetailPrint] AS' 
END
GO


ALTER proc [dbo].[IncubatorLoad_GetDetailPrint]
	@OrderIncubatorID int
	,@IncubatorNumber int
	,@UserName nvarchar(255) = ''
AS

declare @IncubatorID int
	, @OrderID int
	, @Row_Count int
	, @Column_Count int
	, @Location_Count int
	, @LocationOffset int
	, @Start int
	, @End int

select @IncubatorID = IncubatorID, @OrderID = OrderID from OrderIncubator where OrderIncubatorID = @OrderIncubatorID
select @Row_Count = row_count, @Column_Count = column_count from Incubator where IncubatorID = @IncubatorID
select @Location_Count = @Row_Count * @Column_Count
	, @LocationOffset = (@Row_Count * @Column_Count) * (@IncubatorNumber - 1)
	
select @Start = 1 + @LocationOffset
	, @End = @Location_Count + @LocationOffset


declare @currentLocation int = @Start
declare @locations table (LocationNumber int)
while @currentLocation between @Start and @End
begin
	insert into @locations (LocationNumber)
	select @currentLocation
	select @currentLocation = @currentLocation + 1
end

Select
l.*
,@OrderID as OrderID
,@IncubatorID as IncubatorID
,fr.FarmNumber
,substring(convert(varchar,cart.LayDate,101),1,5) as LayDate
,cart.CartQty
,cart.className
,cart.ActualQty
from
@locations l
left outer join 
	(select 
		ic.IncubatorLocationNumber
		--,convert(date,incubator.LoadDateTime) as LoadDate
		--,convert(time,incubator.LoadDateTime) as LoadTime
		,IsNull(f.FlockID,0) as FlockID
		,convert(numeric(19,2),Round(convert(numeric(19,2),oic.ActualQty)/4608,2)) as CartQty
		,oic.ActualQty
		,IsNull(oic.ClutchID,0) as ClutchID
		,c.LayDate
		,IsNull(oic.IncubatorCartID,0) as IncubatorCartID
		,IsNull(oi.OrderIncubatorID,0) as OrderIncubatorID
		,IsNull(oic.OrderIncubatorCartID,0) as OrderIncubatorCartID
		,case 
			when IsNull(oic.ActualQty,0) in (0,4608) then '' -- when it is either empty or a full cart
		    else 'yellowBackground' 
		 end as className
	from
		[Order] o
		left outer join OrderIncubator oi on o.OrderID = oi.OrderID and oi.IncubatorID = @IncubatorID
		left outer join OrderIncubatorCart oic on oi.OrderIncubatorID = oic.OrderIncubatorID
		left outer join Clutch c on oic.ClutchID = c.ClutchID
		left outer join Flock f on c.FlockID = f.FlockID
		left outer join IncubatorCart ic on oic.IncubatorCartID = ic.IncubatorCartID

		
		where @OrderID = o.OrderID

	) cart on cart.IncubatorLocationNumber = l.LocationNumber

left outer join Flock f on cart.FlockID = f.FlockID
left outer join Farm fr on f.FarmID = fr.FarmID



GO
