USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[PADLSSamplingSchedule_Detail_InsertUpdate]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PADLSSamplingSchedule_Detail_InsertUpdate]
GO
/****** Object:  StoredProcedure [dbo].[PADLSSamplingSchedule_Detail_InsertUpdate]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PADLSSamplingSchedule_Detail_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PADLSSamplingSchedule_Detail_InsertUpdate] AS' 
END
GO



ALTER proc [dbo].[PADLSSamplingSchedule_Detail_InsertUpdate]  
     @I_vPADLSSamplingScheduleDetailID int
	,@I_vDateTargeted date = null
    ,@I_vDateCompleted date = null
	,@I_vCompletedBy varchar(200) = null
	,@I_vNotes varchar(500) = null
	,@O_iErrorState int=0 output
	,@oErrString varchar(255)='' output
	,@iRowID varchar(255)=NULL output  
 
AS  

select 
	@I_vDateTargeted = nullif(@I_vDateTargeted, ''),
	@I_vDateCompleted = nullif(@I_vDateCompleted, ''), 
	@I_vCompletedBy = nullif(@I_vCompletedBy, ''), 
	@I_vNotes = nullif(@I_vNotes, '')

update PADLSSamplingScheduleDetail set DateTargeted = @I_vDateTargeted, DateCompleted = @I_vDateCompleted, CompletedBy = @I_vCompletedBy, Notes = @I_vNotes
where PADLSSamplingScheduleDetailID = @I_vPADLSSamplingScheduleDetailID




GO
