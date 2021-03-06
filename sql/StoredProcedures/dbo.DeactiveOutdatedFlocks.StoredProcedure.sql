USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[DeactiveOutdatedFlocks]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[DeactiveOutdatedFlocks]
GO
/****** Object:  StoredProcedure [dbo].[DeactiveOutdatedFlocks]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeactiveOutdatedFlocks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeactiveOutdatedFlocks] AS' 
END
GO
ALTER proc [dbo].[DeactiveOutdatedFlocks] as

update Flock set IsActive = 0, Date_Deactivate = getdate()
where Date_65Weeks < getdate()
GO
