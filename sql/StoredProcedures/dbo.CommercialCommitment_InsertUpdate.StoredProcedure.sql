USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialCommitment_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_InsertUpdate]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitment_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialCommitment_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[CommercialCommitment_InsertUpdate]  
 @I_vCommercialCommitmentID int
 ,@I_vCommercialMarketID int =null
 ,@I_vTurnOffWarning bit = null
 ,@I_vCommitmentDateStart date = null
 ,@I_vCommitmentDateEnd date = null
 ,@I_vCommitmentQty_InCases numeric(10,1) = null
 ,@I_vNotes varchar(500) = null
 ,@I_vCommitmentStatusID int = null
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  AS  

 declare @EggsPerCase int = 360


if @I_vCommercialCommitmentID = 0  
begin   
	declare @CommercialCommitmentID table (CommercialCommitmentID int)   
	insert into CommercialCommitment (
	  CommercialMarketID
	  ,CommitmentDateStart
	  ,CommitmentDateEnd
	  ,CommitmentQty
	  ,Notes
	  ,CommitmentStatusID
	 )   
	 output inserted.CommercialCommitmentID into @CommercialCommitmentID(CommercialCommitmentID)  
	 select
		@I_vCommercialMarketID
		,@I_vCommitmentDateStart
		,@I_vCommitmentDateEnd
		,case
			when isnull(@I_vCommitmentQty_InCases,0) = 0 then 0
			else @I_vCommitmentQty_InCases * @EggsPerCase
		 end
		,@I_vNotes
		,@I_vCommitmentStatusID

 select top 1 @I_vCommercialCommitmentID = CommercialCommitmentID, @iRowID = CommercialCommitmentID 
 from @CommercialCommitmentID  
end  
else  
begin   
	update CommercialCommitment set
		CommercialMarketID = @I_vCommercialMarketID
		,CommitmentDateStart = @I_vCommitmentDateStart
		,CommitmentDateEnd = @I_vCommitmentDateEnd
		,CommitmentQty = 
			case
				when isnull(@I_vCommitmentQty_InCases,0) = 0 then 0
				else @I_vCommitmentQty_InCases * @EggsPerCase
			end
		,Notes = @I_vNotes
		,CommitmentStatusID = @I_vCommitmentStatusID
	 where @I_vCommercialCommitmentID = CommercialCommitmentID   
	 
	 select @iRowID = @I_vCommercialCommitmentID  
end

if isnull(@I_vTurnOffWarning,0) = 1
begin
	update CommercialCommitmentDetail set ModifiedAfterCommitment = 0 where CommercialCommitmentID = @I_vCommercialCommitmentID
end
select @I_vCommercialCommitmentID as ID,'forward' As referenceType



GO
