USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[UserPlanningFarmList_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[UserPlanningFarmList_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[UserPlanningFarmList_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPlanningFarmList_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UserPlanningFarmList_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[UserPlanningFarmList_InsertUpdate]  
  @I_vUserID varchar(255)
 ,@I_vContractTypeID int
 ,@I_vFarmID int
 ,@I_vDefaultPulletQty int = 0
 ,@I_vIncludeFarmInPlan bit
 ,@O_iErrorState int=0 output   
 ,@oErrString varchar(255)='' output   
 ,@iRowID varchar(255)=NULL output  
 
 AS  

 -- Can't exclude a farm if it has an active flock!
 if @I_vIncludeFarmInPlan = 0 and exists 
 (
	select 1 
	from RollingDailySchedule rds 
	where rds.Date between dateadd(year,-1,getdate()) and dateadd(year,2,getdate())
	and ContractTypeID = @I_vContractTypeID
	and FarmID = @I_vFarmID
	and rds.SellableEggs > 0
)
begin
	declare @ErrorMessage varchar(255)
	declare @FarmNumber varchar(10)

	select @FarmNumber = FarmNumber
	from Farm 
	where FarmID = @I_vFarmID

	select @ErrorMessage = 'Farm ' + @FarmNumber + ' is included in active flocks; it may not be hidden.'
	RAISERROR(@ErrorMessage,16,1)
end
else
begin
	if @I_vIncludeFarmInPlan = 1
	begin
		insert into UserPlanningFarmList (UserID, FarmID, ContractTypeID)
		select @I_vUserID, @I_vFarmID, @I_vContractTypeID
		where not exists (select 1 from UserPlanningFarmList where FarmID = @I_vFarmID and UserID = @I_vUserID and ContractTypeID = @I_vContractTypeID)
	end

	if @I_vIncludeFarmInPlan = 0
	begin
		delete from UserPlanningFarmList where FarmID = @I_vFarmID and UserID = @I_vUserID and ContractTypeID = @I_vContractTypeID
	end

	if isnull(@I_vDefaultPulletQty,0) = 0
	begin
		select @I_vDefaultPulletQty = isnull(ConstantValue, 30000)
		from SystemConstant
		where ConstantName like '%Default%pullet%quantity%'
	end

	update Farm set DefaultPulletQty = @I_vDefaultPulletQty where FarmID = @I_vFarmID
end


GO
