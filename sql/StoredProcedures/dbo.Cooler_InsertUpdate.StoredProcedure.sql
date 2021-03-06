USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Cooler_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Cooler_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Cooler_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cooler_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cooler_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[Cooler_InsertUpdate]
	@I_vCoolerID int
	,@I_vCooler varchar(255)=null
	,@I_vCartCapacity int=null
	,@I_vNotes varchar(1000)=null
	,@I_vSortOrder int=null
	,@I_vIsActive bit=1
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if @I_vCoolerID = 0
begin
	declare @CoolerID table (CoolerID int)
	insert into dbo.Cooler (
		
		Cooler
		, CartCapacity
		, Notes
		, SortOrder
		, IsActive
	)
	output inserted.CoolerID into @CoolerID(CoolerID)
	select
		
		@I_vCooler
		,@I_vCartCapacity
		,@I_vNotes
		,@I_vSortOrder
		,@I_vIsActive
	select top 1 @I_vCoolerID = CoolerID, @iRowID = CoolerID from @CoolerID
end
else
begin
	update dbo.Cooler
	set
		
		Cooler = @I_vCooler
		,CartCapacity = @I_vCartCapacity
		,Notes = @I_vNotes
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vCoolerID = CoolerID
	select @iRowID = @I_vCoolerID
end


select @I_vCoolerID as ID,'forward' As referenceType



GO
