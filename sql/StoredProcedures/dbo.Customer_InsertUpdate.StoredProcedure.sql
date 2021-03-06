USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Customer_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Customer_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[Customer_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Customer_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[Customer_InsertUpdate]  
 @I_vCustomerID int
 ,@I_vCustomerTypeID int=null
 ,@I_vCustomerName varchar(100) = null
 ,@I_vSortOrder int=null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

if @I_vCustomerID = 0  
begin   
	declare @CustomerID table (CustomerID int)   
	insert into Customer (
		CustomerTypeID
		, CustomerName
		, SortOrder
		, IsActive
	 )   
	 output inserted.CustomerID into @CustomerID(CustomerID)  
	 select
	  @I_vCustomerTypeID
	  ,@I_vCustomerName
	  ,@I_vSortOrder
	  ,1

 select top 1 @I_vCustomerID = CustomerID, @iRowID = CustomerID 
 from @CustomerID  
end  
else  
begin   
	update Customer set
	   CustomerTypeID = @I_vCustomerTypeID
	  ,CustomerName = @I_vCustomerName
	  ,SortOrder = @I_vSortOrder
	 where @I_vCustomerID = CustomerID   
	 
	 select @iRowID = @I_vCustomerID  
end

select @I_vCustomerID as ID,'forward' As referenceType



GO
