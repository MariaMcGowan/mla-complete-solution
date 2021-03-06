
/****** Object:  StoredProcedure [dbo].[Flock_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Flock_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Flock_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Flock_InsertUpdate]
	@I_vFlockID int
	--,@I_vFlock nvarchar(255)=null
	--,@I_vFarmID int
	--,@I_vHatchDate date = null
	--,@I_vSortOrder int=null
	,@I_vIsActive int =null
	,@I_vUserName nvarchar(255)
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS


--declare @I_vHatchDate date

--if @I_vFlockID = 0
--begin
--	declare @FlockID table (FlockID int)
--	insert into dbo.Flock (
		
--		Flock
--		, FarmID
--		, HatchDate
--		, SortOrder
--		, IsActive
--	)
--	output inserted.FlockID into @FlockID(FlockID)
--	select
		
--		@I_vFlock
--		,@I_vFarmID
--		,@I_vHatchDate
--		,@I_vSortOrder
--		,@I_vIsActive
--	select top 1 @I_vFlockID = FlockID, @iRowID = FlockID from @FlockID
--end
--else

select @I_vIsActive= isnull(@I_vIsActive, -1)
 
if @I_vFlockID > 0 
	and @I_vIsActive >= 0 
	and exists (select 1 from dbo.Flock where FlockID = @I_vFlockID and IsActive <> convert(bit, @I_vIsActive))
begin
print 'Got here'
	update PulletFarmPlan set OverwrittenIsActiveFlag = @I_vIsActive
	where @I_vFlockID = PulletFarmPlanID
	select @iRowID = @I_vFlockID
end

select @I_vFlockID as ID,'forward' As referenceType


GO
