USE [MLA]
GO
/****** Object:  View [dbo].[DayOfWeek]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP VIEW IF EXISTS [dbo].[DayOfWeek]
GO
/****** Object:  View [dbo].[DayOfWeek]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[DayOfWeek]'))
EXEC dbo.sp_executesql @statement = N'create view [dbo].[DayOfWeek]
as

WITH    week (dn) AS
        (
        SELECT  1
        UNION ALL
        SELECT  dn + 1
        FROM    week
        WHERE   dn < 7
        )

select DayOfWeekID = dn
	, DayOfWeek = datename(dw,dateadd(day,dn,''03/16/2019''))
FROM    week


' 
GO
