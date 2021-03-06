USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[SystemConstant_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SystemConstant_Get]
GO
/****** Object:  StoredProcedure [dbo].[SystemConstant_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SystemConstant_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SystemConstant_Get] AS' 
END
GO



ALTER proc [dbo].[SystemConstant_Get]  @SystemConstantID int = null  ,@IncludeNew bit = 0  
As    

select  
 SystemConstantID
 , ConstantName
 , ConstantValue
 , IsActive
from SystemConstant  
where IsNull(@SystemConstantID,SystemConstantID) = SystemConstantID  
and IsActive = 1

union all  select  
 SystemConstantID = convert(int,0)
 , ConstantName = convert(varchar(100),null)
 , ConstantValue = convert(numeric(8,6),null)
 , IsActive = convert(bit,null)
where @IncludeNew = 1  



GO
