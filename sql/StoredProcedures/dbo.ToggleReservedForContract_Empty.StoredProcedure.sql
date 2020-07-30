USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[ToggleReservedForContract_Empty]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ToggleReservedForContract_Empty]
GO
/****** Object:  StoredProcedure [dbo].[ToggleReservedForContract_Empty]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ToggleReservedForContract_Empty]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ToggleReservedForContract_Empty] AS' 
END
GO



ALTER proc [dbo].[ToggleReservedForContract_Empty]
as

select UserMessage = 
	'There in nothing to Release / Reserve.',
	BlankFieldForSpace = convert(varchar(50), null)
			


GO
