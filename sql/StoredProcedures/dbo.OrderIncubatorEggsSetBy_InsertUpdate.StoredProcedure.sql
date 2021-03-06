USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubatorEggsSetBy_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OrderIncubatorEggsSetBy_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OrderIncubatorEggsSetBy_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderIncubatorEggsSetBy_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OrderIncubatorEggsSetBy_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[OrderIncubatorEggsSetBy_InsertUpdate]
	@I_vOrderIncubatorEggsSetByID int
	,@I_vOrderIncubatorID int
	,@I_vContactID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

if @I_vOrderIncubatorEggsSetByID = 0
begin
	declare @OrderIncubatorEggsSetByID table (OrderIncubatorEggsSetByID int)
	insert into OrderIncubatorEggsSetBy (
		
		OrderIncubatorID
		, ContactID
	)
	output inserted.OrderIncubatorEggsSetByID into @OrderIncubatorEggsSetByID(OrderIncubatorEggsSetByID)
		select
		
		@I_vOrderIncubatorID
		,@I_vContactID
	select @I_vOrderIncubatorEggsSetByID = OrderIncubatorEggsSetByID, @iRowID = OrderIncubatorEggsSetByID from @OrderIncubatorEggsSetByID
end
else
begin
	update OrderIncubatorEggsSetBy
	set
		
		OrderIncubatorID = @I_vOrderIncubatorID
		,ContactID = @I_vContactID
	where @I_vOrderIncubatorEggsSetByID = OrderIncubatorEggsSetByID
	select @iRowID = @I_vOrderIncubatorEggsSetByID
end



GO
