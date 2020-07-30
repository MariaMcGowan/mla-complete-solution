USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ContractType_Find]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ContractType_Find]
GO
/****** Object:  StoredProcedure [dbo].[ContractType_Find]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContractType_Find]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ContractType_Find] AS' 
END
GO



ALTER proc [dbo].[ContractType_Find]
@ContractTypeID int = null
as

	select @ContractTypeID  = isnull(nullif(@ContractTypeID,''), 1)

	select 
	@ContractTypeID as ContractTypeID



GO
