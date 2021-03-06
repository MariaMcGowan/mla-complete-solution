USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OverrideExpectedYield_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OverrideExpectedYield_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OverrideExpectedYield_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OverrideExpectedYield_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OverrideExpectedYield_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[OverrideExpectedYield_InsertUpdate]  
 @I_vSetDate date
 ,@I_vContractTypeID int
 ,@I_vEstimatedYield numeric(4,2)
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  
 
AS  

if @I_vEstimatedYield > 1
	select @I_vEstimatedYield = round(@I_vEstimatedYield / 100.0, 2)

update pfpd set pfpd.OverwrittenEstimatedYield = @I_vEstimatedYield
from PulletFarmPlan pfp 
inner join PulletFarmPlanDetail pfpd on pfP.PulletFarmPlanID = pfpd.PulletFarmPlanID
where Date = @I_vSetDate and ContractTypeID = @I_vContractTypeID



GO
