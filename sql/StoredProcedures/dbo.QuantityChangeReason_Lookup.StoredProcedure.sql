USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[QuantityChangeReason_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[QuantityChangeReason_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[QuantityChangeReason_Lookup]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuantityChangeReason_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QuantityChangeReason_Lookup] AS' 
END
GO


ALTER proc [dbo].[QuantityChangeReason_Lookup]
	@IncludeBlank bit = 0
	,@IncludeAll bit = 0
As

select QuantityChangeReason,QuantityChangeReasonID
from dbo.QuantityChangeReason
where IsActive = 1

union all
select '',''
where @IncludeBlank = 1

union all
select 'All',''
where @IncludeAll = 1



GO
