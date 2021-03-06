USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[OverridePulletFarmPlans_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[OverridePulletFarmPlans_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[OverridePulletFarmPlans_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OverridePulletFarmPlans_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[OverridePulletFarmPlans_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[OverridePulletFarmPlans_InsertUpdate]  
 @I_vSetDate date
 ,@I_vReserveReleaseID varchar(1)
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  
 
AS  

if @I_vReserveReleaseID <> ''
begin
	update PulletFarmPlanDetail set ReservedForContract = convert(bit, @I_vReserveReleaseID)
	where Date = @I_vSetDate
end



GO
