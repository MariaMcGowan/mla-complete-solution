USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[CustomerType_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CustomerType_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[CustomerType_Lookup]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerType_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CustomerType_Lookup] AS' 
END
GO


ALTER proc [dbo].[CustomerType_Lookup]
	@IncludeBlank bit = 1
	,@IncludeAll bit = 0
As

select CustomerType, CustomerTypeID
from dbo.CustomerType
where IsActive = 1

union all
select '',''
where @IncludeBlank = 1

union all
select 'All',''
where @IncludeAll = 1
order by 1



GO
