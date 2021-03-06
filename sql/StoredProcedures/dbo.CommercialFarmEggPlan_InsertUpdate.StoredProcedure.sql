USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialFarmEggPlan_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialFarmEggPlan_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[CommercialFarmEggPlan_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialFarmEggPlan_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialFarmEggPlan_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[CommercialFarmEggPlan_InsertUpdate] @CommercialFarmEggPlanID int, @PulletFarmPlanID int
as

select @CommercialFarmEggPlanID = isnull(nullif(@CommercialFarmEggPlanID,''),0)
select @PulletFarmPlanID = isnull(nullif(@PulletFarmPlanID,''),0)

if @CommercialFarmEggPlanID = 0
begin
	if @PulletFarmPlanID > 0
	begin
		if not exists (select 1 from CommercialFarmEggPlan where PulletFarmPlanID = @PulletFarmPlanID)
		begin
			insert into CommercialFarmEggPlan (PulletFarmPlanID)
			select @PulletFarmPlanID
		end
	end
end
else
begin
	update CommercialFarmEggPlan set PulletFarmPlanID = @PulletFarmPlanID
	where CommercialFarmEggPlanID = @CommercialFarmEggPlanID
end
	



GO
