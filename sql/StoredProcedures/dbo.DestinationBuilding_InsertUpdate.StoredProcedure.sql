USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[DestinationBuilding_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[DestinationBuilding_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[DestinationBuilding_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DestinationBuilding_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DestinationBuilding_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[DestinationBuilding_InsertUpdate]
	@I_vDestinationBuildingID int
	,@I_vDestinationBuilding varchar(255) = ''
	,@I_vDestinationID int
	,@I_vInvoiceContactInfo varchar(100)= ''
	,@I_vAddress1 varchar(100) = null
	,@I_vAddress2 varchar(100) = null
	,@I_vCity varchar(100) = null
	,@I_vState varchar(2) = null
	,@I_vZip varchar(10) = null
	,@I_vNotes varchar(1000) = ''
	,@I_vDefaultContractTypeID int = 1
	,@I_vSortOrder int = null
	,@I_vIsActive bit = 1
	,@I_vUserName nvarchar(255) = ''
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

if @I_vDestinationBuildingID = 0
begin
	declare @DestinationBuildingID table (DestinationBuildingID int)
	insert into dbo.DestinationBuilding (		
		DestinationBuilding
		, DestinationID
		, InvoiceContactInfo
		, Address1
		, Address2
		, City
		, State
		, Zip
		, Notes
		, DefaultContractTypeID
		, SortOrder
		, IsActive
	)
	output inserted.DestinationBuildingID into @DestinationBuildingID(DestinationBuildingID)
	select
		
		@I_vDestinationBuilding
		,@I_vDestinationID
		,@I_vInvoiceContactInfo
		,@I_vAddress1
		,@I_vAddress2
		,@I_vCity
		,@I_vState
		,@I_vZip
		,@I_vNotes
		,@I_vDefaultContractTypeID
		,@I_vSortOrder
		,@I_vIsActive
	select top 1 @I_vDestinationBuildingID = DestinationBuildingID, @iRowID = DestinationBuildingID from @DestinationBuildingID
end
else
begin
	update dbo.DestinationBuilding
	set
		
		DestinationBuilding = @I_vDestinationBuilding
		,DestinationID = @I_vDestinationID
		,InvoiceContactInfo = @I_vInvoiceContactInfo
		,Address1 = @I_vAddress1
		,Address2 = @I_vAddress2
		,City = @I_vCity
		,State = @I_vState
		,Zip = @I_vZip
		,Notes = @I_vNotes
		,DefaultContractTypeID = @I_vDefaultContractTypeID
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vDestinationBuildingID = DestinationBuildingID
	select @iRowID = @I_vDestinationBuildingID
end

select @I_vDestinationBuildingID as ID,'forward' As referenceType



GO
