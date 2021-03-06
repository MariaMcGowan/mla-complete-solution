USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CommercialCommitment_Delete]
GO
/****** Object:  StoredProcedure [dbo].[CommercialCommitment_Delete]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommercialCommitment_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CommercialCommitment_Delete] AS' 
END
GO



ALTER proc [dbo].[CommercialCommitment_Delete]
 @I_vCommercialCommitmentID int
 ,@O_iErrorState int=0 output
 ,@oErrString varchar(255)='' output
 ,@iRowID varchar(255)=NULL output  
			
AS

Update CommercialCommitment set CommitmentStatusID = 6 where CommercialCommitmentID = @I_vCommercialCommitmentID

-- Thinking that we should also clear out the PulletFarmPlanID from the detail!
update CommercialCommitmentDetail set PulletFarmPlanID = null, CommitmentStatusID = 6
where CommercialCommitmentID = @I_vCommercialCommitmentID




GO
