USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ContractVolume_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ContractVolume_Get]
GO
/****** Object:  StoredProcedure [dbo].[ContractVolume_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContractVolume_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ContractVolume_Get] AS' 
END
GO



ALTER proc [dbo].[ContractVolume_Get]  @ContractID int = null
As    
	select  
	 ContractVolumeID
	 , ContractID
	 , WeekEndingDate
	 , Volume
	from ContractVolume  
	where @ContractID = ContractID  
	order by WeekEndingDate

	--exec ContractVolume_Get @ContractID = '1'



GO
