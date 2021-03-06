USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ShavingTemplate_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ShavingTemplate_Get]
GO
/****** Object:  StoredProcedure [dbo].[ShavingTemplate_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShavingTemplate_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ShavingTemplate_Get] AS' 
END
GO


ALTER proc [dbo].[ShavingTemplate_Get]
 @PulletFacilityID int = null
As

select @PulletFacilityID = nullif(@PulletFacilityID, '')

	select
		PulletFacility
		, ShavingAmounts
		, ShavingCompany
		, ShavingComments		
	from dbo.PulletFacility pf 
	where pf.PulletFacilityID = isnull(@PulletFacilityID, PulletFacilityID)



GO
