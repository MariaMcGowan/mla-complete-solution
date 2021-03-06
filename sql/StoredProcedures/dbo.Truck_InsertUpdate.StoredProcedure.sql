USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Truck_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Truck_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Truck_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Truck_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Truck_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[Truck_InsertUpdate]
	@I_vTruckID int
	,@I_vTruck nvarchar(255) = ''
	,@I_vSortOrder int = null
	,@I_vIsActive bit = 1
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if @I_vTruckID = 0
begin
	declare @TruckID table (TruckID int)
	insert into Truck (
		
		Truck
		, SortOrder
		, IsActive
	)
	output inserted.TruckID into @TruckID(TruckID)
	select
		
		@I_vTruck
		,@I_vSortOrder
		,@I_vIsActive
	select top 1 @I_vTruckID = TruckID, @iRowID = TruckID from @TruckID
end
else
begin
	update Truck
	set
		
		Truck = @I_vTruck
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vTruckID = TruckID
	select @iRowID = @I_vTruckID
end



GO
