USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Customer_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Customer_Get]
GO
/****** Object:  StoredProcedure [dbo].[Customer_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Customer_Get] AS' 
END
GO



ALTER proc [dbo].[Customer_Get]  @CustomerID int = null  ,@IncludeNew bit = 0
As    


select  
	  CustomerID
	, c.CustomerTypeID
	, CustomerType
	, CustomerName
	, SortOrder
	, c.IsActive
from Customer c
left outer join CustomerType ct on c.CustomerTypeID = ct.CustomerTypeID
where 
(@CustomerID is not null and CustomerID = @CustomerID)
or 
(@CustomerID is null and c.IsActive = 1)
union all  
select  
	  CustomerID = convert(int,0)
	, CustomerTypeID = convert(int,null)
	, CustomerType = convert(nvarchar(255),null)
	, CustomerName = convert(nvarchar(255),null)
	, SortOrder = convert(int,null)
	, IsActive = convert(bit,null)
where @IncludeNew = 1  


GO
