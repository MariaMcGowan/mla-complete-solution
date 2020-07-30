USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[TrueFalse_Lookup]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[TrueFalse_Lookup]
GO
/****** Object:  StoredProcedure [dbo].[TrueFalse_Lookup]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrueFalse_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TrueFalse_Lookup] AS' 
END
GO


ALTER proc [dbo].[TrueFalse_Lookup]
As

select 'True' as TrueFalse, 1 as TrueFalseID
union all
select 'False' as TrueFalse, 0 as TrueFalseID



GO
