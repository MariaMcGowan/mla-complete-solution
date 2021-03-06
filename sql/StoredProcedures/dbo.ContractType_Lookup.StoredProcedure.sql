USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ContractType_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ContractType_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[ContractType_Lookup]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContractType_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ContractType_Lookup] AS' 
END
GO


ALTER proc [dbo].[ContractType_Lookup]
	@IncludeBlank bit = 1
	,@IncludeAll bit = 0
	,@IncludeCommercial bit = 1
	,@IncludePulletOnly bit = 0
As

select ContractType, ContractTypeID
from dbo.ContractType
where IsActive = 1
and 
(
	ContractType not like 'Pullet%Only'
	or
	@IncludePulletOnly = 1
)
and 
(
	ContractType <> 'Commercial'
	or (ContractType = 'Commercial' and @IncludeCommercial = 1)
)

union all
select '',''
where @IncludeBlank = 1

union all
select 'All',''
where @IncludeAll = 1
order by 1


GO
