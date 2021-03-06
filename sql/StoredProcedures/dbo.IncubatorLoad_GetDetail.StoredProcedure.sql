USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_GetDetail]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IncubatorLoad_GetDetail]
GO
/****** Object:  StoredProcedure [dbo].[IncubatorLoad_GetDetail]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IncubatorLoad_GetDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IncubatorLoad_GetDetail] AS' 
END
GO


ALTER proc [dbo].[IncubatorLoad_GetDetail]
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

declare @invalidCoolerClutches table (ClutchID int)

insert into @invalidCoolerClutches (ClutchID)
select c.ClutchID
from CoolerClutch cc
inner join Clutch c on cc.ClutchID = c.ClutchID
group by c.ClutchID
having sum(isnull(cc.ActualQty,0)) < 0



Select
*
,@OrderID as OrderID
,@IncubatorID as IncubatorID
from
@locations l
left outer join 
	(select 
		ic.IncubatorLocationNumber
		,IsNull(f.FlockID,0) as FlockID
		,oic.ActualQty
		,IsNull(oic.ClutchID,0) as ClutchID
		,c.LayDate
		,IsNull(oic.IncubatorCartID,0) as IncubatorCartID
		,IsNull(oi.OrderIncubatorID,0) as OrderIncubatorID
		,IsNull(oic.OrderIncubatorCartID,0) as OrderIncubatorCartID
		,case 
			when exists (select 1 from @invalidCoolerClutches where ClutchID = oic.ClutchID) then 'InvalidClutchQty'
			when IsNull(oic.ActualQty,0) in (0,4608) then '' -- when it is either empty or a full cart
		    else 'yellowBackground' 
		 end as className
		,convert(bit, 0) as FlockQtyError
		,IsNull(f.FlockID,0) as Orig_FlockID
		,oic.ActualQty as Orig_ActualQty
		,IsNull(oic.ClutchID,0) as Orig_ClutchID
		,c.LayDate as Orig_LayDate
		,case 
			when exists (select 1 from @invalidCoolerClutches where ClutchID = oic.ClutchID) then 'InvalidClutchQty'
			when IsNull(oic.ActualQty,0) in (0,4608) then '' -- when it is either empty or a full cart
		    else 'yellowBackground' 
		 end as Orig_className
	from
		[Order] o
		left outer join OrderIncubator oi on o.OrderID = oi.OrderID and oi.IncubatorID = @IncubatorID
		left outer join OrderIncubatorCart oic on oi.OrderIncubatorID = oic.OrderIncubatorID
		left outer join Clutch c on oic.ClutchID = c.ClutchID
		left outer join Flock f on c.FlockID = f.FlockID
		left outer join IncubatorCart ic on oic.IncubatorCartID = ic.IncubatorCartID
		where @OrderID = o.OrderID

	) cart on cart.IncubatorLocationNumber = l.LocationNumber



GO
