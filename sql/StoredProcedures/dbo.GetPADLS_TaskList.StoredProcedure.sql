USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[GetPADLS_TaskList]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetPADLS_TaskList]
GO
/****** Object:  StoredProcedure [dbo].[GetPADLS_TaskList]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPADLS_TaskList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPADLS_TaskList] AS' 
END
GO



ALTER proc [dbo].[GetPADLS_TaskList]
as

set nocount off

select *
from dbo.GetPADLSReport_ColumnList()



GO
