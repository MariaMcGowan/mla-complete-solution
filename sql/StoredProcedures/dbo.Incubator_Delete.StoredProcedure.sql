USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[Incubator_Delete]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Incubator_Delete]
GO
/****** Object:  StoredProcedure [dbo].[Incubator_Delete]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Incubator_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Incubator_Delete] AS' 
END
GO


ALTER proc [dbo].[Incubator_Delete]
	@I_vIncubatorID int
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output
AS


delete from dbo.Incubator where IncubatorID = @I_vIncubatorID



GO
