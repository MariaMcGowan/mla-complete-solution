USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialMarket_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialMarket_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[CommercialMarket_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialMarket_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialMarket_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[CommercialMarket_InsertUpdate]  
 @I_vCommercialMarketID int
 ,@I_vCommercialMarket nvarchar(100)=null
 ,@I_vPrimaryContactID int = null
 ,@I_vSecondaryContactID int = null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

if @I_vCommercialMarketID = 0  
begin   
	declare @CommercialMarketID table (CommercialMarketID int)   
	insert into CommercialMarket (
	  CommercialMarket
	  ,PrimaryContactID
	  ,SecondaryContactID
	  ,IsActive
	 )   
	 output inserted.CommercialMarketID into @CommercialMarketID(CommercialMarketID)  
	 select
	  @I_vCommercialMarket
	  ,@I_vPrimaryContactID
	  ,@I_vSecondaryContactID
	  ,1

 select top 1 @I_vCommercialMarketID = CommercialMarketID, @iRowID = CommercialMarketID 
 from @CommercialMarketID  
end  
else  
begin   
	update CommercialMarket set
	   CommercialMarket = @I_vCommercialMarket
	   ,PrimaryContactID = @I_vPrimaryContactID
	   ,SecondaryContactID = @I_vSecondaryContactID
	 where @I_vCommercialMarketID = CommercialMarketID   
	 
	 select @iRowID = @I_vCommercialMarketID  
end

select @I_vCommercialMarketID as ID,'forward' As referenceType



GO
