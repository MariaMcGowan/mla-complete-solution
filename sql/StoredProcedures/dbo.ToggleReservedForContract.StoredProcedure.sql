USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ToggleReservedForContract]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ToggleReservedForContract]
GO
/****** Object:  StoredProcedure [dbo].[ToggleReservedForContract]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ToggleReservedForContract]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ToggleReservedForContract] AS' 
END
GO



ALTER proc [dbo].[ToggleReservedForContract] @PulletFarmPlanDetailID int
as

declare @Reserved bit

select @PulletFarmPlanDetailID = nullif(@PulletFarmPlanDetailID, '')

select @Reserved = ReservedForContract
from PulletFarmPlanDetail
where PulletFarmPlanDetailID = @PulletFarmPlanDetailID


select 
	PulletFarmPlanDetailID = @PulletFarmPlanDetailID,
	referenceType = 
		case 
			when @PulletFarmPlanDetailID is null then 'Empty'
			when @Reserved = 1 then 'Release'	-- this is already reserved for embryo process, therefore user wants to "Release" it'
			else 'Reserve'
		end
			


GO
