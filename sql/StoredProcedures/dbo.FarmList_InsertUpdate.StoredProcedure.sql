USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[FarmList_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FarmList_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[FarmList_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FarmList_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[FarmList_InsertUpdate] AS' 
END
GO


ALTER proc [dbo].[FarmList_InsertUpdate]
	@I_vFarmID int
	,@I_vSortOrder int=null
	,@I_vIsActive bit=null
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS

	update dbo.Farm
	set	SortOrder = @I_vSortOrder
	where @I_vFarmID = FarmID

-- Can the farm's active / inactive flag be changed?
-- Is it used in a current or future flock?
 if @I_vIsActive = 0 and exists 
 (
	select 1 
	from RollingDailySchedule rds 
	where rds.Date between dateadd(year,-1,getdate()) and dateadd(year,2,getdate())
	and FarmID = @I_vFarmID
	and rds.SellableEggs > 0
)
begin
	declare @ErrorMessage varchar(255)
	declare @FarmNumber varchar(10)

	select @FarmNumber = FarmNumber
	from Farm 
	where FarmID = @I_vFarmID

	select @ErrorMessage = 'Farm ' + @FarmNumber + ' is included in active flocks; it may not be deactivated.'
	RAISERROR(@ErrorMessage,16,1)
end
else
begin
	update dbo.Farm
	set	IsActive = @I_vIsActive
	where @I_vFarmID = FarmID
end

select @iRowID = @I_vFarmID



GO
