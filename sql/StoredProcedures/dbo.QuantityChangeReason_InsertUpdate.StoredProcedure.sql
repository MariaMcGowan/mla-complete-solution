USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QuantityChangeReason_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QuantityChangeReason_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[QuantityChangeReason_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuantityChangeReason_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QuantityChangeReason_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[QuantityChangeReason_InsertUpdate]
	@I_vQuantityChangeReasonID int
	,@I_vQuantityChangeReason varchar(255) = null
	,@I_vNotes varchar(1000) = null
	,@I_vSortOrder int = null
	,@I_vIsActive bit = null
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS
if @I_vQuantityChangeReasonID = 0
begin
	declare @QuantityChangeReasonID table (QuantityChangeReasonID int)
	insert into dbo.QuantityChangeReason (
		
		QuantityChangeReason
		, Notes
		, SortOrder
		, IsActive
	)
	output inserted.QuantityChangeReasonID into @QuantityChangeReasonID(QuantityChangeReasonID)
	select
		
		@I_vQuantityChangeReason
		,@I_vNotes
		,@I_vSortOrder
		,@I_vIsActive
	select top 1 @I_vQuantityChangeReasonID = QuantityChangeReasonID, @iRowID = QuantityChangeReasonID from @QuantityChangeReasonID
end
else
begin
	update dbo.QuantityChangeReason
	set
		
		QuantityChangeReason = @I_vQuantityChangeReason
		,Notes = @I_vNotes
		,SortOrder = @I_vSortOrder
		,IsActive = @I_vIsActive
	where @I_vQuantityChangeReasonID = QuantityChangeReasonID
	select @iRowID = @I_vQuantityChangeReasonID
end



GO
