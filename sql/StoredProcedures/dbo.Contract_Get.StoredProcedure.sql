USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Contract_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Contract_Get]
GO
/****** Object:  StoredProcedure [dbo].[Contract_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contract_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Contract_Get] AS' 
END
GO



ALTER proc [dbo].[Contract_Get]  @ContractID int = null  ,@IncludeNew bit = 1  
As   

	select  
	 ContractID
	 , ContractTypeID
	 , CustomerID
	 , EffectiveDateStart
	 , EffectiveDateEnd
	 , CaseWeightMin
	 , IsActive
	 , FlockAgeInWeeksMax
	 , ProductTypeID
	from Contract  
	where IsActive = 1 and IsNull(@ContractID,ContractID) = ContractID  
	union all  select  
	 ContractID = convert(int,0)
	 , ContractTypeID = convert(int,0)
	 , CustomerID = convert(int,1)
	 , EffectiveDateStart = convert(date,null)
	 , EffectiveDateEnd = convert(date,null)
	 , CaseWeightMin = convert(numeric(10,4),null)
	 , IsActive = convert(bit,null)
	 , FlockAgeInWeeksMax = convert(int,null)
	 , ProductTypeID = convert(int,null)
	where @IncludeNew = 1  



GO
