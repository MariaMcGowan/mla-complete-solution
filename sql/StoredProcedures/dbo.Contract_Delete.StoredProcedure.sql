USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Contract_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Contract_Delete]
GO
/****** Object:  StoredProcedure [dbo].[Contract_Delete]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contract_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Contract_Delete] AS' 
END
GO



ALTER  proc [dbo].[Contract_Delete]   
	@I_vContractID int
	,@O_iErrorState int=0 output   
	,@oErrString varchar(255)='' output  
	,@iRowID varchar(255)=NULL output  
	
AS    

delete from ContractVolume where ContractID = @I_vContractID
delete from Contract where ContractID = @I_vContractID



GO
