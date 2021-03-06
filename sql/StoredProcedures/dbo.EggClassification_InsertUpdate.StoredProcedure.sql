USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[EggClassification_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EggClassification_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[EggClassification_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EggClassification_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EggClassification_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[EggClassification_InsertUpdate]  
 @I_vEggClassificationID int
 ,@I_vEggClassification nvarchar(255)=null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

if @I_vEggClassificationID = 0  
begin   
	declare @EggClassificationID table (EggClassificationID int)   
	insert into EggClassification (
	  EggClassification
	  ,IsActive
	 )   
	 output inserted.EggClassificationID into @EggClassificationID(EggClassificationID)  
	 select
	  @I_vEggClassification
	  ,1

 select top 1 @I_vEggClassificationID = EggClassificationID, @iRowID = EggClassificationID 
 from @EggClassificationID  
end  
else  
begin   
	update EggClassification set
	   EggClassification = @I_vEggClassification
	 where @I_vEggClassificationID = EggClassificationID   
	 
	 select @iRowID = @I_vEggClassificationID  
end

select @I_vEggClassificationID as ID,'forward' As referenceType



GO
