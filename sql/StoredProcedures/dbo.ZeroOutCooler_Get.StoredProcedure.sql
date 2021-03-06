USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ZeroOutCooler_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ZeroOutCooler_Get]
GO
/****** Object:  StoredProcedure [dbo].[ZeroOutCooler_Get]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZeroOutCooler_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ZeroOutCooler_Get] AS' 
END
GO



ALTER proc [dbo].[ZeroOutCooler_Get] @Date date, @CoolerQty numeric(10,1), @ContractTypeID int
as

declare @ZeroOut bit 

if exists (select 1 from HatcheryRecord where date = @Date and ContractTypeID = @ContractTypeID)
begin
	select @ZeroOut = ZeroOutCooler from HatcheryRecord where date = @Date and ContractTypeID = @ContractTypeID
end
else
begin
	select @ZeroOut = 0
end
select Date = @Date, CoolerQuantity = @CoolerQty, ZeroOut = @ZeroOut, ContractTypeID = @ContractTypeID



GO
