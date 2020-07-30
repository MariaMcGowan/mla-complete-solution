USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ReserveRelease_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ReserveRelease_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[ReserveRelease_Lookup]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReserveRelease_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReserveRelease_Lookup] AS' 
END
GO




ALTER proc [dbo].[ReserveRelease_Lookup]
	@IncludeBlank bit = 1
	,@IncludeAll bit = 0

As

  select ReserveRelease = 'Release', ReserveReleaseID = '0'
  union all

  select ReserveRelease = 'Reserve', ReserveReleaseID = '1'
  union all

  select '', ''
  where @IncludeBlank = 1    

  order by 2
  


GO
