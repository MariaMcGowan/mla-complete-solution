USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Clutch_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Clutch_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[Clutch_Lookup]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Clutch_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Clutch_Lookup] AS' 
END
GO


ALTER proc [dbo].[Clutch_Lookup]
	@IncludeBlank bit = 1
	,@IncludeAll bit = 0
As

select rtrim(f.Flock) + ' ' + convert(varchar,LayDate,101),ClutchID
from dbo.Clutch c
inner join Flock f on c.FlockID = f.FlockID
where c.IsActive = 1

union all
select '',''
where @IncludeBlank = 1

union all
select 'All',''
where @IncludeAll = 1
order by 1



GO
