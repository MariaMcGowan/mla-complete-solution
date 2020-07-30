USE [MLA]
GO
/****** Object:  StoredProcedure [csb].[Overview_Get]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [csb].[Overview_Get]
GO
/****** Object:  StoredProcedure [csb].[Overview_Get]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[csb].[Overview_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [csb].[Overview_Get] AS' 
END
GO


ALTER procedure [csb].[Overview_Get]
	@OverviewID int
as

select o.GoLiveDate, o.Overview
	from csb.Overview o
	where o.OverviewID = @OverviewID


GO
